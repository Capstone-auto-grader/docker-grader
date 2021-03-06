FROM maven:3.6.0-jdk-8-alpine
# COPY ./Gemfile /
RUN apk -v --update add \
        python \
        py-pip \
        groff \
        less \
        mailcap \
    && pip install --upgrade awscli \
    && apk -v --purge del py-pip \
    && rm /var/cache/apk/*
COPY ./unzip-and-grade.sh / 
RUN chmod +x unzip-and-grade.sh
CMD ls




