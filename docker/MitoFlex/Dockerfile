ARG baseimageversion=latest
FROM base:${baseimageversion}

ARG VERSION=master
ARG VCS_REF
ARG BUILD_DATE

RUN echo "VCS_REF: "${VCS_REF}", BUILD_DATE: "${BUILD_DATE}", VERSION: "${VERSION}
RUN mkdir /app
WORKDIR /app
RUN wget -c https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh -O /app/anaconda.sh && bash /app/anaconda.sh -b -p /app/anaconda && rm -rf /app/anaconda.sh
ENV PATH=/app/anaconda/bin:/opt/spades/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN conda config --add channels defaults
RUN conda config --add channels bioconda
RUN conda config --add channels conda-forge
RUN conda config --add channels flomertens
RUN conda install python=3.6.10
RUN conda install -c bioconda megahit=1.2.9
RUN conda install -c conda-forge psutil
RUN conda install -c flomertens wise2=2.4.1
RUN conda install -c bioconda hmmer=3.2.1
RUN conda install -c bioconda circos=0.69.8
RUN conda install -c bioconda bwa=0.7.17
RUN conda install -c bioconda samtools=1.3.1
RUN conda install -c bioconda infernal=1.1.2
RUN conda install -c bioconda blast=2.5.0
RUN conda install -c anaconda pandas
RUN conda install -c etetoolkit ete3
RUN conda install -c conda-forge biopython
 
	
ENV MITOFLEXVERSION ff536e1c26ce3a3e1251aab114e8f33b4e6e32c5
WORKDIR /data/Nirmal_analysis/docker
RUN git clone --depth=1 https://github.com/Prunoideae/MitoFlex && \
    cd MitoFlex && \
    git checkout ${MITOFLEXVERSION} && \
    rm -rf .git
RUN chmod -R +rX /data/Nirmal_analysis/docker/MitoFlex
ENV PATH "/data/Nirmal_analysis/docker/MitoFlex/:$PATH"
WORKDIR /data/Nirmal_analysis/docker/MitoFlex
RUN sed -i "s|use_old = \"\"|use_old = \"y\" |g" ncbi.py
RUN ./ncbi.py

# Setup of /data volume and set it as working directory
VOLUME /data/Nirmal_analysis/simulated_reads
WORKDIR /data/Nirmal_analysis/simulated_reads
