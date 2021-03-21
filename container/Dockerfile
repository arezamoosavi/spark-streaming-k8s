FROM python:3.7-slim-stretch

RUN apt-get update -y && apt-get install -y libzbar-dev bash gcc git libc-dev curl wget vim nano \
    && apt-get install -y ranger caca-utils highlight atool w3m poppler-utils mediainfo \
    && apt-get install -y iputils-ping telnet openssh-client net-tools \
    man unzip vim-tiny bc openssh-server thrift-compiler netcat sudo \
    && apt-get install -y build-essential \
    && apt-get autoremove -y \
    && apt-get clean

# Install OpenJDK 8
RUN mkdir -p /usr/share/man/man1mkdir -p /usr/share/man/man1 && \
    apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin
RUN echo $JAVA_HOME

# install spark
RUN wget --no-verbose https://downloads.apache.org/spark/spark-3.1.1/spark-3.1.1-bin-hadoop3.2.tgz
RUN tar -xzvf spark-3.1.1-bin-hadoop3.2.tgz
RUN mv spark-3.1.1-bin-hadoop3.2 /opt/spark
RUN rm -rf spark-3.1.1-bin-hadoop3.2.tgz

ENV SPARK_HOME=/opt/spark
ENV PATH=$PATH:$SPARK_HOME/bin
ENV PATH=$PATH:$SPARK_HOME/sbin
ENV PYTHONPATH=$SPARK_HOME/python3:$SPARK_HOME/python3/lib/py4j-0.10.7-src.zip:$PYTHONPATH
RUN mkdir -p /opt/spark/history
COPY container/spark-defaults.conf /opt/spark/conf/spark-defaults.conf

COPY container/requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

RUN mkdir -p /opt/project
ADD container/common.sh container/spark-master container/spark-worker /
