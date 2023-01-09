ARG baseimageversion=latest
FROM base:${baseimageversion}

ARG VERSION=master
ARG VCS_REF
ARG BUILD_DATE

RUN echo "VCS_REF: "${VCS_REF}", BUILD_DATE: "${BUILD_DATE}", VERSION: "${VERSION}
RUN mkdir /module
WORKDIR /module
RUN wget -c https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh -O /module/anaconda.sh && bash /module/anaconda.sh -b -p /module/anaconda && rm -rf /module/anaconda.sh
ENV PATH="/module/anaconda/bin:/opt/spades/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"
RUN conda config --add channels defaults
RUN conda config --add channels bioconda
RUN conda config --add channels conda-forge
RUN conda config --add channels flomertens

ENV MITOZVERSION 9ea563400f03a0adec3a0edcd078c0d4acfb5477
WORKDIR /data/Nirmal_analysis/docker
ADD mitoz.txt /data/Nirmal_analysis/docker/
RUN conda install --file mitoz.txt
RUN git clone --no-checkout https://github.com/linzhi2013/MitoZ.git && \
    cd MitoZ && \
    git config core.symlinks false && \
    git checkout ${MITOZVERSION} && \
    rm -rf .git
WORKDIR /data/Nirmal_analysis/docker/MitoZ/version_2.3
RUN tar -jxvf release_MitoZ_v2.3.tar.bz2 && rm -rf release_MitoZ_v2.3.tar.bz2
ENV PATH "/data/Nirmal_analysis/docker/MitoZ/version_2.3/release_MitoZ_v2.3/:$PATH"
WORKDIR /data/Nirmal_analysis/docker/MitoZ/version_2.3/release_MitoZ_v2.3
RUN sed -i 's/db.execute("INSERT INTO synonym (taxid, spname) VALUES (?, ?);", (taxid, spname))/db.execute("INSERT OR REPLACE INTO synonym (taxid, spname) VALUES (?, ?);", (taxid, spname))/g' \
    /module/anaconda/lib/python3.6/site-packages/ete3/ncbi_taxonomy/ncbiquery.py
RUN python3 -c 'from ete3 import NCBITaxa; ncbi = NCBITaxa()' ; rm -rf taxdump.tar.gz
# Setup of /data volume and set it as working directory
VOLUME /data/Nirmal_analysis/simulated_reads
WORKDIR /data/Nirmal_analysis/simulated_reads
