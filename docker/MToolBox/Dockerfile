ARG baseimageversion=latest
FROM base:${baseimageversion}

ARG VERSION=master
ARG VCS_REF
ARG BUILD_DATE

RUN echo "VCS_REF: "${VCS_REF}", BUILD_DATE: "${BUILD_DATE}", VERSION: "${VERSION}

ENV MTOOLBOXVERSION 2db6754 

WORKDIR /data/Nirmal_analysis/docker
RUN git clone --recursive https://github.com/Nirmal2310/MToolBox.git && \
    cd MToolBox && \
    git checkout ${MTOOLBOXVERSION} && \
    rm -rf .git

WORKDIR /data/Nirmal_analysis/docker/MToolBox
ENV PATH "/data/Nirmal_analysis/docker/MToolBox/:/data/Nirmal_analysis/docker/MToolBox/:$PATH"
RUN install.sh
RUN apt-get update
#RUN apt-get install --yes --fix-missing python-pip
ENV PATH "/data/Nirmal_analysis/docker/MToolBox/MToolBox/:/data/Nirmal_analysis/docker/MToolBox/MToolBox/:$PATH"
# Setup of /data volume and set it as working directory
VOLUME /data/Nirmal_analysis/simulated_reads
WORKDIR /data/Nirmal_analysis/simulated_reads
