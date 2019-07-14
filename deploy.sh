#!/bin/bash



#removing current files 
# rm -rf  ./modules/whatsapp-module/
rm -rf ./out/bp/data/ 
# rm -rf .

#botpress setup
git pull origin master 

#creating new foldelrs
cd ./modules/ && sud  o mkdir whatsapp-module/
cd ./out &&  cd bp/  && sudo mkdir data/
#fetching latest build update from botpress.io  
git pull origin master 
#fetching modules 
cd ./modules/whatsapp-module/ && git init && git remote add origin https://mashreqmoeid@bitbucket.org/JijeshMashreq/whatsapp-module.git && git pull origin next && yarn && yarn build 
#fetching bots 
cd ./out/bp/data/bots/ && git init && git remote add origin https://mashreqmoeid@bitbucket.org/JijeshMashreq/whatsapp-bots.git && git pull origin next 
#compile the whole project 

yarn
yarn build 
yarn start 


#dockerize it 
#docker build -t moeidsaleem/mashreq-bot:latest . --no-cache

#deploy it 
#docker push mashreq-bot:latest



#fetching the files for the latest version of module 

# mv ../bots/ ./out/bp/data/bots/ 
# cd ./modules/whatsapp-module/ && yarn && yarn build 
# mv ../whatsapp-module/ ./modules/whatsapp-module/
# yarn
# yarn build 
# yarn start 
# docker build -t moeidsaleem/mashreq-bot:latest . --no-cache
# docker push mashreq-bot:latest
