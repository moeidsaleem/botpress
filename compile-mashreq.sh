# # # Install dependencies
# yarn

# # # Build everything
# yarn build --linux --prod

# # # Create distributable package
# yarn package --linux --prod

# # Build docker image
# cd ./out/binaries/ && docker build -t moeidsaleem/botpressx:dev -f ../../build/docker/Dockerfile .


# #show 
# docker container ls -a

# ## Compile to kubectl 
#  kubectl get nodes && kubectl get pods 
