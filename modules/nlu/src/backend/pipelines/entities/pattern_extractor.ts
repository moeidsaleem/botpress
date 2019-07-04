import 'bluebird-global'
import * as sdk from 'botpress/sdk'
import { flatMap, flatten } from 'lodash'
import _ from 'lodash'

import { extractPattern } from '../../tools/patterns-utils'
import { LanguageProvider } from '../../typings'
import { NLUStructure } from '../../typings'
import { sanitize } from '../language/sanitizer'

const debug = DEBUG('nlu').sub('entities')
const debugLists = debug.sub('lists')

const MIN_LENGTH_FUZZY_MATCH = 4
const MIN_CONFIDENCE = 0.65

export default class PatternExtractor {
  constructor(private toolkit: typeof sdk.MLToolkit, private languageProvider: LanguageProvider) {}

  async extractLists(ds: NLUStructure, entityDefs: sdk.NLU.EntityDefinition[]): Promise<sdk.NLU.Entity[]> {
    const entities = flatten(
      flatten(
        await Promise.mapSeries(entityDefs, async entityDef => {
          return await Promise.mapSeries(entityDef.occurences || [], occurence =>
            this._extractEntitiesFromOccurence(ds, occurence, entityDef)
          )
        })
      )
    )

    return _.orderBy(entities, ['meta.confidence'], ['desc'])
  }

  protected async _extractEntitiesFromOccurence(
    ds: NLUStructure,
    occurence: sdk.NLU.EntityDefOccurence,
    entityDef: sdk.NLU.EntityDefinition
  ): Promise<sdk.NLU.Entity[]> {
    const values = await Promise.all(
      [occurence.name, ...occurence.synonyms].map(async x =>
        (await this.languageProvider.tokenize(x.toLowerCase(), ds.language)).map(sanitize).filter(t => t.length)
      )
    )

    const findings: sdk.NLU.Entity[] = []

    let cur = 0
    for (const tok of ds.tokens) {
      cur = cur + ds.lowerText.substr(cur).indexOf(tok)

      let highest = 0
      let extracted = ''
      let source = ''

      for (const val of values) {
        let partOfPhrase = tok
        const occ = val.join('+')

        if (val.length > 1) {
          const text = ds.lowerText.substr(cur + partOfPhrase.length)
          // TODO use ds.tokens
          const _tokens = (await this.languageProvider.tokenize(text, ds.language)).map(sanitize).filter(t => t.length)

          while (_tokens && _tokens.length && partOfPhrase.length < occ.length) {
            partOfPhrase += '+' + _tokens.shift()
          }
        }

        let distance = 0.0

        if (entityDef.fuzzy && partOfPhrase.length > MIN_LENGTH_FUZZY_MATCH) {
          const d1 = this.toolkit.Strings.computeLevenshteinDistance(partOfPhrase, occ)
          const d2 = this.toolkit.Strings.computeJaroWinklerDistance(partOfPhrase, occ, { caseSensitive: true })
          distance = Math.min(d1, d2)
          const diffLen = Math.abs(partOfPhrase.length - occ.length)
          if (diffLen <= 3) {
            distance = Math.min(1, distance * (0.1 * (4 - diffLen) + 1))
          }
        } else {
          const strippedPop = sanitize(partOfPhrase.toLowerCase())
          const strippedOcc = sanitize(occ.toLowerCase())
          if (strippedPop.length && strippedOcc.length) {
            distance = strippedPop === strippedOcc ? 1 : 0
          }
        }

        // if is closer OR if the match found is longer
        if (distance > highest || (distance === highest && extracted.length < occ.length)) {
          extracted = occ
          highest = distance
          source = ds.lowerText.substr(cur, partOfPhrase.length)
        }
      }

      const start = cur
      const end = cur + source.length

      // prevent adding substrings of an already matched, longer entity
      // prioretize longer matches with confidence * its length higher
      const hasBiggerMatch = findings.find(
        x =>
          start >= x.meta.start &&
          end <= x.meta.end &&
          x.meta.confidence * Math.log(x.meta.source.length) > highest * Math.log(source.length)
      )

      if (highest >= MIN_CONFIDENCE && !hasBiggerMatch) {
        debugLists('found list entity', {
          lang: ds.language,
          occurence: occurence.name,
          input: ds.lowerText,
          extracted,
          confidence: highest,
          source
        })

        const newMatch = {
          name: entityDef.name,
          type: 'list',
          meta: {
            confidence: highest, // extrated with synonyme as patterns
            provider: 'native',
            source: source,
            start,
            end,
            raw: {}
          },
          data: {
            extras: { occurence: extracted },
            value: occurence.name, // cannonical value,
            unit: 'string'
          }
        }

        const idxToSwap = findings.findIndex(match => match.meta.start < start || match.meta.end > end)
        if (idxToSwap !== -1) {
          findings[idxToSwap] = newMatch
        } else {
          findings.push(newMatch)
        }
      }
    }

    return findings
  }

  async extractPatterns(input: string, entityDefs: sdk.NLU.EntityDefinition[]): Promise<sdk.NLU.Entity[]> {
    return flatMap(entityDefs, entityDef => {
      try {
        const regex = new RegExp(entityDef.pattern!)
        return extractPattern(input, regex).map(res => ({
          name: entityDef.name,
          type: entityDef.type, // pattern
          sensitive: entityDef.sensitive,
          meta: {
            confidence: 1, // pattern always has 1 confidence
            provider: 'native',
            source: res.value,
            start: res.sourceIndex,
            end: res.sourceIndex + res.value.length,
            raw: {}
          },
          data: {
            extras: {},
            value: res.value,
            unit: 'string'
          }
        }))
      } catch (error) {
        throw Error(`Pattern of entity ${entityDef.name} is invalid`)
      }
    })
  }
}
