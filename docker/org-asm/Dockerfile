ARG baseimageversion=latest
FROM base:${baseimageversion}

ARG VERSION=master
ARG VCS_REF
ARG BUILD_DATE

RUN echo "VCS_REF: "${VCS_REF}", BUILD_DATE: "${BUILD_DATE}", VERSION: "${VERSION}


ENV ORGASMVERSION 830313acae3ca773b63f6bea9fc6d017e021bde5
WORKDIR /data/Nirmal_analysis/docker
RUN git clone https://git.metabarcoding.org/org-asm/org-asm.git && \
    cd org-asm && \
    git checkout ${ORGASMVERSION} && \
    rm -rf .git && \
    python3.7 get_orgasm/get-orgasm.py

RUN cd org-asm/src && \
    sed -i 's#<stdio.h>#<bsd/stdio.h>#' fastq.c && \
    make && \
    cp orgasmi /data/Nirmal_analysis/docker/org-asm/ORG.asm-1.0.3/bin

ENV PATH "/data/Nirmal_analysis/docker/org-asm/ORG.asm-1.0.3/bin:$PATH"

# Setup of /data volume and set it as working directory
VOLUME /data/Nirmal_analysis/docker/simulated_data
WORKDIR /data/Nirmal_analysis/docker/simulated_data

#ENTRYPOINT
CMD ["/bin/bash"]
