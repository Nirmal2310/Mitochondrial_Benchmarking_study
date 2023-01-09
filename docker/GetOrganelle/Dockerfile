ARG baseimageversion=latest
FROM base:${baseimageversion}

ARG VERSION=master
ARG VCS_REF
ARG BUILD_DATE

RUN echo "VCS_REF: "${VCS_REF}", BUILD_DATE: "${BUILD_DATE}", VERSION: "${VERSION}

RUN apt install --yes \
    python-scipy \
    python-numpy \
    python-sympy

ENV GETORGANELLEVERSION b3fe5a026cf0e905ba73243e18ededccadd12700

WORKDIR /data/Nirmal_analysis/docker
RUN git clone --recursive https://github.com/Kinggerm/GetOrganelle.git && \
    cd GetOrganelle && \
    git checkout ${GETORGANELLEVERSION} && \
    rm -rf .git

ENV PATH "/data/Nirmal_analysis/docker/GetOrganelle:/data/Nirmal_analysis/docker/GetOrganelle/Utilities:$PATH"
RUN get_organelle_config.py -a all
# Setup of /data volume and set it as working directory
VOLUME /data/Nirmal_analysis/simulated_data
WORKDIR /data/Nirmal_analysis/simulated_data
