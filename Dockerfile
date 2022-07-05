FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive \
  TZ=Africa/Johannesburg

# Sysbench
RUN  apt-get -y install curl && \
  curl https://packagecloud.io/install/repositories/akopytov/sysbench/script.deb.sh | bash && \
  apt -y install sysbench

# Phoronix 
RUN apt-get -y install php-cli php-common php-xml && \ 
  wget https://phoronix-test-suite.com/releases/repo/pts.debian/files/phoronix-test-suite_10.8.2_all.deb && \
  dpkg -i phoronix-test-suite_10.8.2_all.deb
RUN apt-get install -y build-essential zlib1g-dev 

# Phoronix tests
RUN phoronix-test-suite batch-install \
  pts/compress-7zip-1.8.0 \
  pts/mbw-1.0.0 \ 
  pts/ramspeed-1.4.3 \ 
  pts/fs-mark-1.0.3 \ 
  pts/redis-1.3.1 \ 
  pts/m-queens-1.1.0 
COPY phoronix-test-suite.xml /etc/
COPY suite-definition.xml /var/lib/phoronix-test-suite/test-suites/local/containerbenchmark/

# AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
  unzip awscliv2.zip && \
  ./aws/install && \
  rm -rf "awscliv2.zip"

RUN apt -y install python3

COPY scripts/run.sh /root/

CMD ["/root/run.sh"]