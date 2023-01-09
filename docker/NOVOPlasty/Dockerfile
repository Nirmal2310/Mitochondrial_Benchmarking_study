ARG baseimageversion=latest
FROM base:${baseimageversion}

ARG VERSION=master
ARG VCS_REF
ARG BUILD_DATE

RUN echo "VCS_REF: "${VCS_REF}", BUILD_DATE: "${BUILD_DATE}", VERSION: "${VERSION}


ENV NOVOPLASTYVERSION acab0d4f14f8b4d3b3e4a900ce55c697fe85fa80

WORKDIR /data/Nirmal_analysis/docker
RUN git clone --recursive https://github.com/ndierckx/NOVOPlasty.git && \
    cd NOVOPlasty && \
    git checkout ${NOVOPLASTYVERSION} && \
    rm -rf .git && \
    chmod +x NOVOPlasty*.pl && \
    ln -s NOVOPlasty*.pl NOVOPlasty.pl
ENV PATH "/data/Nirmal_analysis/docker/NOVOPlasty:$PATH"

# Setup of /data volume and set it as working directory
VOLUME /data/Nirmal_analysis/results/simulated_data
WORKDIR /data1/Nirmal_analysis/results/simulated_data
