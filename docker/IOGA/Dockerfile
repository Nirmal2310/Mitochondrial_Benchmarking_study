ARG baseimageversion=latest
FROM base:${baseimageversion}

ARG VERSION=master
ARG VCS_REF
ARG BUILD_DATE

RUN echo "VCS_REF: "${VCS_REF}", BUILD_DATE: "${BUILD_DATE}", VERSION: "${VERSION}

ENV IOGAVERSION 8367ac1d2b1225f923e1e24d6a77c2a8ad76ba37

WORKDIR /data/Nirmal_analysis/docker
RUN git clone --recursive https://github.com/holmrenser/IOGA.git && \
    cd IOGA && \
    git checkout ${IOGAVERSION} && \
    rm -rf .git && \
    python setup_IOGA.py

RUN chmod -R +rX /data/Nirmal_analysis/docker/IOGA

ENV PATH "/data/Nirmal_analysis/docker/IOGA:$PATH"

# Setup of /data volume and set it as working directory
VOLUME /data/Nirmal_analysis/simulated_data
WORKDIR /data/Nirmal_analysis/simulated_data
