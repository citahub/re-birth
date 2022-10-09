FROM ruby:2.5.3

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update -qq && \
 apt-get install -y build-essential libpq-dev nodejs git autoconf locales locales-all && \
 apt-get clean && \
 rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN cd /tmp && git clone https://github.com/bitcoin-core/secp256k1.git && \
cd secp256k1 && ./autogen.sh && \
./configure --enable-module-recovery && \
make && make install && rm -rf /tmp/secp256k1

RUN echo 'gem: --no-document' >> /usr/local/etc/gemrc
RUN gem install bundler

#upgrade openssl 1.1.1
RUN cd /tmp && \
wget https://www.openssl.org/source/openssl-1.1.1g.tar.gz && \
tar -xzvf openssl-1.1.1g.tar.gz && \
cd openssl-1.1.1g && \
./config && \
make && make install && \
mv /usr/bin/openssl /usr/bin/openssl.old && \
cp /usr/local/bin/openssl /usr/bin/ && \
ldconfig && rm -rf /tmp/openssl-1.1.1g.tar.gz /tmp/openssl-1.1.1g

RUN mkdir /app
WORKDIR /app
# 快速构建镜像
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --jobs 20 --retry 5 --without development test
COPY . /app

ENV RAILS_ENV production

EXPOSE 3000
RUN mkdir -p /app/tmp/pids
