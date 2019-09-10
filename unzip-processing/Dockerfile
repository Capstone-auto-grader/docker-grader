FROM alpine
RUN apk -v --update add \
        python \
        py-pip \
        groff \
        less \
        mailcap \
        zip \
        tree \ 
    && pip install --upgrade awscli \
    && apk -v --purge del py-pip \
    && rm /var/cache/apk/*

COPY ./unzip-and-recombine.sh / 
RUN chmod +x unzip-and-recombine.sh
CMD ls