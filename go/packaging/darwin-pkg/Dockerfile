FROM ubuntu:bionic
RUN apt-get update && apt-get install cpio git make g++ wget libxml2-dev libssl1.0-dev zlib1g-dev -y
WORKDIR /tmp
RUN git clone https://github.com/hogliux/bomutils && cd bomutils && make > /dev/null && make install > /dev/null
RUN wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/xar/xar-1.5.2.tar.gz && tar -zxvf xar-1.5.2.tar.gz > /dev/null && cd xar-1.5.2 && ./configure > /dev/null && make > /dev/null && make install > /dev/null
