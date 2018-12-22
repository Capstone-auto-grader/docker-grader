FROM maven:3-jdk-8
# COPY ./Gemfile /
RUN apt-get update && \
    apt-get install -y \
        python \
        python-dev \
        python-pip \
        python-setuptools \
        groff \
        less \
    && pip install --upgrade awscli \
    && apt-get clean
COPY ./unzip-and-grade.sh / 
RUN chmod +x unzip-and-grade.sh
CMD ls




