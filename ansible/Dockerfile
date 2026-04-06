FROM debian:12-slim
RUN apt-get update && apt-get install -y --no-install-recommends ansible
WORKDIR /ansible
CMD ["/bin/bash", "-c", "sleep 5 && /ansible/upperservices.sh"]
