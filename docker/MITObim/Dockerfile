ARG baseimageversion=latest
FROM base:${baseimageversion}

ARG VERSION=master
ARG VCS_REF
ARG BUILD_DATE

RUN echo "VCS_REF: "${VCS_REF}", BUILD_DATE: "${BUILD_DATE}", VERSION: "${VERSION}

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y -q build-essential git wget curl perl

ENV MITOBIMVERSION 1a15c5aa1b2cb2b725792cd66dade47df761355b

WORKDIR /data/Nirmal_analysis/docker
RUN git clone --recursive https://github.com/chrishah/MITObim.git && \
    cd MITObim && \
    git checkout ${MITOBIMVERSION} && \
    rm -rf .git
ENV PATH "/data/Nirmal_analysis/docker/MITObim:/data/Nirmal_analysis/docker/MITObim:$PATH"
RUN chmod -R a+x /data/Nirmal_analysis/docker/MITObim/misc_scripts && ln -s /data/Nirmal_analysis/docker/MITObim/docker/external_software/mira_4.0.2/mira* /usr/bin
RUN echo "export LC_ALL=C" >> /root/.bashrc
# Setup of /data volume and set it as working directory
VOLUME /data/Nirmal_analysis/simulated_data
WORKDIR /data/Nirmal_analysis/simulated_data
