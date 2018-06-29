FROM debian:stretch-slim

ENV DKRON_VERSION 0.10.3

RUN set -eux; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends ca-certificates wget openssl awscli jq; \
	\
	mkdir -p /opt/local/dkron; \
	cd /opt/local/dkron; \
	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	wget -O /opt/local/dkron/dkron.tar.gz "https://github.com/victorcoder/dkron/releases/download/v${DKRON_VERSION}/dkron_${DKRON_VERSION}_linux_$dpkgArch.tar.gz"; \
	tar -xzf dkron.tar.gz; \
	rm /opt/local/dkron/dkron.tar.gz; \
	\
	rm -rf /var/lib/apt/lists/*;

ENV SHELL /bin/bash
WORKDIR /opt/local/dkron

ADD ecs-run /usr/local/bin/
RUN chmod +x /usr/local/bin/ecs-run

ADD docker-entrypoint /opt/local/dkron/
RUN chmod +x /opt/local/dkron/docker-entrypoint

EXPOSE 8080 8946 6868

ENTRYPOINT ["/opt/local/dkron/docker-entrypoint"]
CMD ["--help"]
