FROM ubuntu

RUN apt-get update && \
    apt-get install -y \
        awscli \
        zip \
        unzip \
    && apt-get clean
COPY ./unzip-and-recombine.sh / 
RUN chmod +x unzip-and-recombine.sh
CMD ls
