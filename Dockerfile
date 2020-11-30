FROM alpine

RUN apk add --no-cache \
	curl \
	bash

COPY feed.sh /

ENTRYPOINT ["/feed.sh"]
