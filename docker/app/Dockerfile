FROM ruby:2.5.3

RUN apt-get update -qq && \
 apt-get install -y build-essential libpq-dev nodejs git autoconf locales locales-all && \
 apt-get clean && \
 rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN mkdir /secp256k1
WORKDIR /secp256k1
RUN git clone https://github.com/bitcoin-core/secp256k1.git . && ./autogen.sh && ./configure --enable-module-recovery && make && make install

RUN echo 'gem: --no-document' >> /usr/local/etc/gemrc
RUN gem install bundler

RUN mkdir /app
WORKDIR /app
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --jobs 20 --retry 5 --without development test
COPY . /app

ENV RAILS_ENV production

EXPOSE 3000

#CMD ["bundle", "exec", "puma", "-C", "config/puma.docker.rb"]
