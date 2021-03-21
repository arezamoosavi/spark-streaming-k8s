FROM openjdk:11-jre-slim

RUN apt-get update -y && apt-get install -y libzbar-dev bash gcc git libc-dev curl wget vim nano \
    && apt-get install -y iputils-ping telnet openssh-client net-tools \
    man unzip vim-tiny bc openssh-server thrift-compiler netcat sudo \
    && apt-get install -y build-essential \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean


RUN set -ex && \
    sed -i 's/http:\/\/deb.\(.*\)/https:\/\/deb.\1/g' /etc/apt/sources.list && \
    apt-get update && \
    ln -s /lib /lib64 && \
    apt-get install -y bash tini libc6 libpam-modules libnss3 procps && \
    rm /bin/sh && \
    ln -sv /bin/bash /bin/sh && \
    echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su && \
    chgrp root /etc/passwd && chmod ug+rw /etc/passwd && \
    rm -rf /var/cache/apt/*

#install python3.7
RUN apt-get update && apt-get install -y software-properties-common && \
    apt-add-repository -r ppa:armagetronad-dev/ppa && \
    apt-get update && apt-get install -y python3.7 python3-pip \
    python3-distutils python3-setuptools && \
    python3.7 -m pip install pip --upgrade pip && \
    echo "alias python=python3.7" >> ~/.bashrc && \
    export PATH=${PATH}:/usr/bin/python3.7 && \
    /bin/bash -c "source ~/.bashrc" && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1 && \
    update-alternatives --set python /usr/bin/python3.7

# install spark
RUN wget --no-verbose https://downloads.apache.org/spark/spark-3.1.1/spark-3.1.1-bin-hadoop3.2.tgz && \
    tar -xzvf spark-3.1.1-bin-hadoop3.2.tgz && \
    mv spark-3.1.1-bin-hadoop3.2 /opt/spark && \
    rm -rf spark-3.1.1-bin-hadoop3.2.tgz

ENV SPARK_HOME=/opt/spark
ENV PATH=$PATH:$SPARK_HOME/bin
ENV PATH=$PATH:$SPARK_HOME/sbin
ENV PYTHONPATH=$SPARK_HOME/python3:$SPARK_HOME/python3/lib/py4j-0.10.7-src.zip:$PYTHONPATH

COPY container/k8s/requirements.txt requirements.txt
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    rm -rf requirements.txt

RUN mkdir -p /opt/work-dir
COPY ./src /opt/work-dir

COPY container/k8s/entrypoint.sh /opt/
COPY container/k8s/decom.sh /opt/

RUN chmod g+w /opt/work-dir
RUN chmod a+x /opt/decom.sh

WORKDIR /opt/work-dir
ENTRYPOINT [ "/opt/entrypoint.sh" ]