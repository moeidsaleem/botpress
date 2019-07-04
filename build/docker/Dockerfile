FROM alpine:latest
MAINTAINER moeidsaleem@gmail.com 
ADD . /botpress
WORKDIR /botpress


RUN apk update && \
	apk install -y wget ca-certificates && \
	update-ca-certificates && \
	wget -O duckling https://s3.amazonaws.com/botpress-binaries/duckling-example-exe && \
	chmod +x duckling && \
	chmod +x bp && \
	chgrp -R 0 /botpress && \
	chmod -R g=u /botpress && \
	# 	apt install -y tzdata && \
	apk install tzdata && \
	ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
	dpkg-reconfigure --frontend noninteractive tzdata && \
	./bp extract


ENV BP_MODULE_NLU_DUCKLINGURL=http://localhost:8000
ENV BP_IS_DOCKER=true

ENV LANG=C.UTF-8
EXPOSE 3000

CMD ./duckling & ./bp

## Compile to kubectl 
