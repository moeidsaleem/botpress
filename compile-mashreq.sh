# Install dependencies
yarn

# Build everything
yarn build --linux --prod

# Create distributable package
yarn package --linux --prod

# Build docker image
cd ./out/binaries/ && docker build -t moeidsaleem/botpressx:dev -f ../../build/docker/Dockerfile .