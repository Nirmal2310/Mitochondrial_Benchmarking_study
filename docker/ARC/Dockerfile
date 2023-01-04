ARG baseimageversion=latest
FROM base:${baseimageversion}

ARG VERSION=master
ARG VCS_REF
ARG BUILD_DATE

RUN echo "VCS_REF: "${VCS_REF}", BUILD_DATE: "${BUILD_DATE}", VERSION: "${VERSION}

RUN apt install --yes \
    python-biopython

ENV ARCVERSION 3831cb83f76f0263ddfa7c8c184a373120b8dc05

WORKDIR /data/Nirmal_analysis/docker
RUN git clone --recursive https://github.com/ibest/ARC.git && \
    cd ARC && \
    git checkout ${ARCVERSION} && \
    rm -rf .git

ENV PATH "/data/Nirmal_analysis/docker/ARC:/data/Nirmal_analysis/docker/ARC/bin:$PATH"
# Setup of /data volume and set it as working directory
VOLUME /data/Nirmal_analysis/simulated_data
WORKDIR /data/Nirmal_analysis/simulated_data
