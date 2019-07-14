FROM alpine:latest
MAINTAINER moeidsaleem@gmail.com 
ADD . /botpress
WORKDIR /botpress

ENV TZ=Asia/Dubai
 
RUN apk update && apk upgrade &&  \
apk add curl && \
 apk add vim && \
 apk add git && \
	apk add wget ca-certificates && \
	update-ca-certificates && \
	wget -O duckling https://s3.amazonaws.com/botpress-binaries/duckling-example-exe && \
	chmod +x duckling && \
	chmod +x bp && \
	chgrp -R 0 /botpress && \
	chmod -R g=u /botpress && \
		apk add --update tzdata && \
		apk add --update dpkg && \
	apk add tzdata && \
	ln -fs /usr/share/zoneinfo/$TZ /etc/localtime
	# dpkg-reconfigure --frontend noninteractive tzdata && \


RUN chmod +x ./bp 
ENV BP_MODULE_NLU_DUCKLINGURL=http://localhost:8000
ENV BP_IS_DOCKER=true

RUN echo "Hello World, COmpilation at its Final stage"

ENV LANG=C.UTF-8
EXPOSE 3000

CMD ./duckling & ./bp


    