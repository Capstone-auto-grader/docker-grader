FROM ruby:2.5

RUN apt-get update && \
    apt-get install -y \
        awscli \
        zip \
        unzip \
        tree \
    && apt-get clean \ 
    && gem install moss_ruby
COPY ./moss.sh /
RUN chmod +x moss.sh
COPY ./moss.rb /
CMD ls