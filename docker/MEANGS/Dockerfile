ARG baseimageversion=latest
FROM base:${baseimageversion}

ARG VERSION=master
ARG VCS_REF
ARG BUILD_DATE

RUN echo "VCS_REF: "${VCS_REF}", BUILD_DATE: "${BUILD_DATE}", VERSION: "${VERSION}

RUN apt-get install --yes gcc-8 g++-8 \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 800 --slave /usr/bin/g++ g++ /usr/bin/g++-8

RUN wget http://ftp.cs.stanford.edu/pub/exim/pcre/pcre-8.41.tar.gz && tar -xvf pcre-8.41.tar.gz && cd pcre-8.41 && \
    ./configure --enable-utf8 --prefix=/usr                     \
            --docdir=/usr/share/doc/pcre-8.41 \
            --enable-unicode-properties       \
            --enable-pcre16                   \
            --enable-pcre32                   \
            --enable-pcregrep-libz            \
            --enable-pcregrep-libbz2          \
            --enable-pcretest-libreadline     \
            --disable-static && \
    	      make && make install

ENV MEANGSVERSION de27552322bfeeef9a92681ed1354a454f4737a0

WORKDIR /data/Nirmal_analysis/docker
RUN git clone --recursive https://github.com/YanCCscu/MEANGS.git && \
    cd MEANGS && \
    git checkout ${MEANGSVERSION} && \
    rm -rf .git

ENV PATH "/data/Nirmal_analysis/docker/MEANGS:/data/Nirmal_analysis/docker/MEANGS:$PATH"
RUN cd MEANGS/tools/assembler_v1.0/src && make && cp assembler ../../
# Setup of /data volume and set it as working directory
VOLUME /data/Nirmal_analysis/simulated_data
WORKDIR /data/Nirmal_analysis/simulated_data
