if [ -d "./out/bp/data/deployment/" ]; then
  # Control will enter here if $DIRECTORY exists.
  rm -rf ./out/bp/data/deployment/
  echo "Removed deployment"
fi

# (1) - FIRST STEP - BUILD TAR FILES 
mkdir ./out/bp/data/deployment && yarn package-release

# (3) - Deploy on Git 
git add . && git commit -m ':fire: updating new build. :construction:'  && git push origin master

# Now we will configure our docker file to run the commands accordingly. The 
# docker file will fetch from latest botpress, copy deployments into their respective locations, 
# and
# docker build -t "botpress/server" .