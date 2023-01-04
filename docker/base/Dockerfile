ARG osversion=bionic-20210930
FROM ubuntu:${osversion}

ARG VERSION=master
ARG VCS_REF
ARG BUILD_DATE

RUN echo "VCS_REF: "${VCS_REF}", BUILD_DATE: "${BUILD_DATE}", VERSION: "${VERSION}

RUN apt update && \
    apt install --yes \
       locales
RUN locale-gen en_GB.UTF-8  

ENV DEBIAN_FRONTEND=noninteractive LANG=en_GB.UTF-8 LANGUAGE=en_GB:UTF-8 LC_ALL=en_GB.UTF-8  

RUN apt install --yes \
	software-properties-common && \
    add-apt-repository --yes ppa:deadsnakes/ppa && \
    apt update && \
    apt install --yes \
       python3.7 \
       python3.7-venv \
       python3.7-dev && \
    apt install --yes \
       nvi \
       nano \
       libbsd-dev \
       liblog-log4perl-perl \
       libmoose-perl \
       libfile-which-perl \
       libipc-run-perl \
       libterm-progressbar-perl \
       libgraph-perl \
       liblist-moreutils-perl \
       bowtie2 \
       bowtie \
       build-essential \
       trimmomatic \
       ncbi-blast+ \
       samtools \
       bedtools \
       r-base \
       ghostscript \
       jellyfish \
       python \
       wget \
       python3-pip \
       python3-venv \
       python-wget \
       python-matplotlib \
       python-biopython \
       python3-distutils \
       git

RUN cd /tmp/ && \
    wget -O - http://cab.spbu.ru/files/release3.13.0/SPAdes-3.13.0-Linux.tar.gz | \
       tar -xzf - && \
    mv SPAdes-3.13.0-Linux/ /opt/spades/

ENV PATH "/opt/spades/bin:$PATH"

# Setup of /data volume and set it as working directory
VOLUME /data1/nirmal/results/simulated_data
WORKDIR /data1/nirmal/results/simulated_data
