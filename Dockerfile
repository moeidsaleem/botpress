FROM botpress/server:nightly-2019-07-14
WORKDIR ./
COPY /deployment/whatsapp-module_1_0_0.tgz /botpress/data/modules/
COPY ['bots','global','bot.config.schema.json','botpress.config.schema.json'] ./botpress/data







# FROM ubuntu:18.04
# MAINTAINER moeidsaleem@gmail.com 
# ADD . /botpress
# WORKDIR /botpress

# RUN apt update && \
# 	apt install -y wget ca-certificates && \
# 	update-ca-certificates && \
# 	wget -O duckling https://s3.amazonaws.com/botpress-binaries/duckling-example-exe && \
# 	chmod +x duckling && \
# 	chmod +x bp && \
# 	chgrp -R 0 /botpress && \
# 	chmod -R g=u /botpress && \
# 	apt install -y tzdata && \
# 	ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
# 	dpkg-reconfigure --frontend noninteractive tzdata && \
# 	./bp extract

# ENV BP_NLU_DUCKLINGURL=http://localhost:8000
# ENV BP_IS_DOCKER=true
# ENV LANG=C.UTF-8
# EXPOSE 3000

# CMD ./duckling & ./bp