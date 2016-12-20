# example from official https://github.com/membrane/service-proxy/blob/master/distribution/examples/docker/Dockerfile

FROM anapsix/alpine-java

RUN	apk update && apk add curl wget openssl

RUN	curl -s https://api.github.com/repos/membrane/service-proxy/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4 | xargs wget -P /opt
RUN cd /opt && \
	ls -la && \
	unzip *.zip && \
	rm *.zip && \
	ln -s membrane-service-proxy-* membrane

COPY nodes.xml /opt/membrane/conf/proxies.xml

COPY acl.xml /opt/membrane/conf/acl.xml

EXPOSE 8000-9900

ENTRYPOINT ["/opt/membrane/service-proxy.sh"]