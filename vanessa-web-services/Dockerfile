# Докер файл с 1C Apache

FROM silverbulleters/vanessa-32bit-baseimage

ENV LANG ru_RU.UTF-8
ENV LC_MESSAGES "POSIX"

ENV RDATA=/opt/database
ENV REPODATA=/opt/repo
ENV DESCRIPTORS=/opt/descriptors

ADD conf /distr/
RUN chmod -v +x /distr/docker-entrypoint.sh && chmod -v +x /distr/installapache.sh && sleep 1 && /distr/installapache.sh

RUN sh /distr/download.sh

RUN dpkg -i /distr/distr/1c*.deb \
    && rm -rf /distr/distr/*.deb \
    && apt-get clean && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/tmp/* /tmp/* 
    
VOLUME $RDATA
VOLUME $REPODATA
VOLUME $DESCRIPTORS

ENTRYPOINT ["dumb-init", "/distr/docker-entrypoint.sh"]

EXPOSE 80

CMD ["apache"]