FROM quay.io/continuouspipe/ubuntu16.04:latest

MAINTAINER Matt Chapman <matt.chapman+cp-dockerfiles@inviqa.com>

# Ensure local build is used instead of system build.
ENV PATH /usr/local/bin:$PATH

ARG PYTHON_VERSION
ENV PYTHON_VERSION ${PYTHON_VERSION:-3.6.0}

# Install the build dependencies
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install \
    build-essential \
    python-dev \
    tcl \
    tcl-dev \
    tk \
    tk-dev

# Do the following tasks in the temp dir, we don't need to keep any of it
# around.
WORKDIR /tmp

# Install Python.
RUN wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz \
  && tar xfv Python-${PYTHON_VERSION}.tgz

WORKDIR Python-${PYTHON_VERSION}

RUN ./configure \
  && make \
  && make install

# Setup symlinks.
WORKDIR /usr/local/bin

RUN [ -e easy_install ] || ln -s easy_install-* easy_install \
  && ln -s idle3 idle \
  && ln -s pydoc3 pydoc \
  && ln -s python3 python \
  && ln -s python3-config python-config \
  && ln -s pip3 pip

# Cleanup.
RUN rm /tmp/Python-${PYTHON_VERSION}.tgz \
  && rm -rf /tmp/Python-${PYTHON_VERSION}

# End in app directory.
WORKDIR /app