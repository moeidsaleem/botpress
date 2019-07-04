import * as sdk from 'botpress/sdk'

import { NLUStructure } from './typings'

export type PipelineStep = (ds: NLUStructure) => Promise<NLUStructure>

export class PipelineManager {
  private _nluds!: NLUStructure
  private _pipeline!: PipelineStep[]

  public withPipeline(pipeline: PipelineStep[]): PipelineManager {
    this._pipeline = pipeline
    return this
  }

  public initFromText(text: string, includedContexts: string[]): PipelineManager {
    this._nluds = initNLUStruct(text, includedContexts)
    return this
  }

  public async run(): Promise<NLUStructure> {
    if (!this._nluds) {
      throw new Error('You must add a NLUDS to the pipeline manager before runinng it')
    }

    if (!this._pipeline) {
      throw new Error('You must add a pipeline to the pipeline manager before runinng it')
    }

    let ds = this._nluds
    for (const step of this._pipeline) {
      ds = await step(ds)
    }
    return ds
  }
}

// exported for testing purposes
export const initNLUStruct = (text: string, includedContexts: string[]): NLUStructure => {
  return {
    rawText: text,
    lowerText: '',
    includedContexts: includedContexts,
    detectedLanguage: '',
    language: '',
    entities: [],
    ambiguous: false,
    intent: {} as sdk.NLU.Intent,
    intents: [],
    sanitizedText: '',
    tokens: [],
    slots: {}
  }
}
