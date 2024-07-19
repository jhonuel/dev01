FROM alpine:latest

RUN apk add --no-cache bash docker-cli

COPY start_exited_containers.sh /usr/local/bin/start_exited_containers.sh

RUN chmod +x /usr/local/bin/start_exited_containers.sh

CMD ["sh", "-c", "while true; do /usr/local/bin/start_exited_containers.sh; sleep 60; done"]
