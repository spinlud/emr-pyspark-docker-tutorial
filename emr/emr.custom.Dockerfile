FROM openjdk:8

ARG PYTHON_MIN_VERSION=3.8
ARG PYTHON_VERSION=3.8.5

RUN apt-get update --fix-missing \
	&& apt-get install -y \
	build-essential \
	zlib1g-dev \
	libncurses5-dev \
	libgdbm-dev \
	libnss3-dev \
	libssl-dev \
	libsqlite3-dev \
	libreadline-dev \
	libffi-dev \
	libbz2-dev

RUN curl -O https://www.python.org/ftp/python/"$PYTHON_VERSION"/Python-"$PYTHON_VERSION".tgz \
	&& tar -xf Python-"$PYTHON_VERSION".tgz \
	&& cd Python-"$PYTHON_VERSION" \
	&& ./configure \
	&& make -j 8 \
	&& make altinstall

RUN rm -fr Python-"$PYTHON_VERSION"*

RUN ln -s /usr/local/bin/pip"$PYTHON_MIN_VERSION" /usr/local/bin/pip3 && pip3 -V
RUN ln -s /usr/local/bin/python"$PYTHON_MIN_VERSION" /usr/local/bin/python3 && python3 -V

RUN pip3 install --upgrade pip \
	&& pip3 install boto3 \
	&& python3 -c "import boto3"

ENV PYSPARK_DRIVER_PYTHON python3
ENV PYSPARK_PYTHON python3
ENV JAVA_HOME /usr/local/openjdk-8

CMD []
ENTRYPOINT []
