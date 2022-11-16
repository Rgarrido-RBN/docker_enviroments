FROM ubuntu:20.04

ENV TZ=Europe/Spain
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ARG DEBIAN_FRONTEND=noninteractive

# We need libpython2.7 due to GDB tools
RUN : \
  && apt-get update \
  && apt-get install -y \
    apt-utils \
    bison \
    ca-certificates \
    ccache \
    cmake \
    check \
    curl \
    flex \
    git \
    gperf \
    lcov \
    libffi-dev \
    libncurses-dev \
    libpython2.7 \
    libusb-1.0-0-dev \
    make \
    ninja-build \
    vim \
    python3 \
    python3-pip \
    unzip \
    wget \
    xz-utils \
    zip \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/* \
  && update-alternatives --install /usr/bin/python python /usr/bin/python3 10 \
  && python -m pip install --upgrade \
    pip \
    virtualenv \
  && :

# To build the image for a branch or a tag of IDF, pass --build-arg IDF_CLONE_BRANCH_OR_TAG=name.
# To build the image with a specific commit ID of IDF, pass --build-arg IDF_CHECKOUT_REF=commit-id.
# It is possibe to combine both, e.g.:
#   IDF_CLONE_BRANCH_OR_TAG=release/vX.Y
#   IDF_CHECKOUT_REF=<some commit on release/vX.Y branch>.

ARG IDF_CLONE_URL=https://github.com/espressif/esp-idf.git
ARG IDF_CLONE_BRANCH_OR_TAG=master

ENV IDF_PATH=/opt/esp/idf
ENV IDF_TOOLS_PATH=/opt/esp

RUN echo IDF_CHECKOUT_REF=$IDF_CHECKOUT_REF IDF_CLONE_BRANCH_OR_TAG=$IDF_CLONE_BRANCH_OR_TAG && \
    git clone --recursive \
      ${IDF_CLONE_BRANCH_OR_TAG:+-b $IDF_CLONE_BRANCH_OR_TAG} \
      $IDF_CLONE_URL $IDF_PATH && \
    if [ -n "$IDF_CHECKOUT_REF" ]; then \
      cd $IDF_PATH && \
      git checkout $IDF_CHECKOUT_REF && \
      git submodule update --init --recursive; \
    fi

# Install all the required tools
RUN : \
  && update-ca-certificates --fresh \
  && $IDF_PATH/tools/idf_tools.py --non-interactive install required \
  && $IDF_PATH/tools/idf_tools.py --non-interactive install cmake \
  && $IDF_PATH/tools/idf_tools.py --non-interactive install-python-env \
  && rm -rf $IDF_TOOLS_PATH/dist \
  && :

# Ccache is installed, enable it by default
ENV IDF_CCACHE_ENABLE=1

ARG USERNAME
ARG GROUPNAME
ARG USERID
ARG GROUPID
RUN echo $GROUPID
RUN echo $GROUPNAME
RUN groupadd -g $GROUPID $GROUPNAME && \
    useradd -m -r -u $USERID -g $GROUPNAME $USERNAME

# Builder with depot tools used for building 
ARG USERNAME
USER $USERNAME
WORKDIR /home/$USERNAME
RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git .depot_tools
ENV PATH="/home/$USERNAME/.depot_tools:${PATH}"

USER root
ARG USERNAME

RUN dpkg --add-architecture i386 

ENV GOSU_VERSION=1.10

RUN dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
	&& wget -q -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
	&& chmod +sx /usr/local/bin/gosu

RUN cd /root && git clone https://github.com/Distrotech/flux && cd flux && \
  autoreconf -fi  && ./configure --host=arm-linux-gnueabihf && make && make install 

VOLUME ["/rbn"]

WORKDIR /rbn

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh 
RUN chmod +s /usr/local/bin/gosu

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["/bin/bash"]
 
ENV USER_NAME=$USERNAME

WORKDIR /rbn
