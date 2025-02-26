FROM ubuntu:22.04 AS base

ARG spark_version="3.5.4"
ARG delta_version="2.4.0"
ARG openjdk_version="17"
ARG python_version="3.11"
ENV workdir="/app"

# Set WorkDir
WORKDIR $workdir

RUN apt update && apt install -y openjdk-${openjdk_version}-jdk && \
    rm -rf /var/lib/apt/lists/* && \
    export JAVA_HOME="${HOME}/spark/jdk-${openjdk_version}" && \
    export PATH="${JAVA_HOME}/bin:${PATH}"

# Install Spark
RUN \
    apt update && \
    apt install -y wget && \
    wget https://archive.apache.org/dist/spark/spark-${spark_version}/spark-${spark_version}-bin-hadoop3.tgz && \
    tar xzfv spark-${spark_version}-bin-hadoop3.tgz && \
    mv spark-${spark_version}-bin-hadoop3/ /opt/spark && \
    export SPARK_HOME="${HOME}/spark/spark-${spark_version}-bin-hadoop3" && \
    export PATH="${SPARK_HOME}/bin:${PATH}" && \
    export PYSPARK_PYTHON=/usr/bin/python3 && \
    rm spark-${spark_version}-bin-hadoop3.tgz

# Install Python in new layer to improve rebuilds with different versions
RUN \
    apt update && \
    apt install -y python${python_version} python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Copy Requirements
COPY requirements.txt .

# Install Python Dependencys
RUN \
    pip install -r requirements.txt

# Expose ports for Jupyter notebook (8888) and Spark UI (4040)
EXPOSE 8888 4040


# Setup the entrypoint to run Jupyter and start Spark
CMD bash -c "start-master.sh & jupyter notebook --ip='0.0.0.0' --port=8888 --no-browser --allow-root"
