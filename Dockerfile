ARG BASE_IMAGE=nvidia/cudagl:10.0-devel-ubuntu18.04
FROM ${BASE_IMAGE}

# Disable dpkg/gdebi interactive dialogs
ENV DEBIAN_FRONTEND=noninteractive

# Intall Webots runtime dependencies
RUN apt-get update && apt-get install --yes wget lsb-release sudo
RUN wget https://raw.githubusercontent.com/cyberbotics/webots/master/scripts/install/linux_runtime_dependencies.sh
RUN chmod +x linux_runtime_dependencies.sh
RUN ./linux_runtime_dependencies.sh
RUN rm ./linux_runtime_dependencies.sh

# Install Webots dependencies and build it from sources
# https://github.com/cyberbotics/webots/wiki/Linux-installation
WORKDIR /opt
RUN apt-get update && apt-get install --yes git g++ cmake execstack libusb-dev \
    swig python2.7-dev libglu1-mesa-dev libglib2.0-dev libfreeimage-dev \
    libfreetype6-dev libxml2-dev libzzip-0-13 libboost-dev libavcodec-extra \
    libgd-dev libssh-gcrypt-dev libzip-dev libreadline-dev pbzip2 libpci-dev \
    libxcb-keysyms1 libxcb-image0 libxcb-icccm4 libxcb-randr0 libxcb-render-util0 \
    libxcb-xinerama0 ffmpeg python3.6-dev python3.7-dev python-pip

# Webots dependencies:
# https://github.com/cyberbotics/webots/wiki/Linux-Optional-Dependencies
RUN apt-get update && apt-get install --yes openjdk-11-jdk
# Do not install npm since it requires libssl1.0-dev
# but there is a conflict between libssl1.0-dev and libcurl4-openssl-dev
# needed by ros-melodic-moveit
# See: https://stackoverflow.com/a/52676447
# See: https://askubuntu.com/questions/1088662/npm-depends-node-gyp-0-10-9-but-it-is-not-going-to-be-installed#comment2035361_1092849
# Maybe try this: https://answers.ros.org/question/339940/try-to-use-npm-with-ros-melodic-on-ubuntu-1804/
# RUN apt-get update && apt-get install --yes npm

RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update && apt-get install --yes python3.6-dev python3.7-dev python3.8-dev python3-pip

RUN sudo -H pip3 install --upgrade pip
RUN sudo -H pip3 install websocket-client tornado nvidia-ml-py3 psutil requests
RUN wget https://github.com/netblue30/firejail/archive/0.9.56.2-LTS.tar.gz
RUN tar xzf 0.9.56.2-LTS.tar.gz
WORKDIR /opt/firejail-0.9.56.2-LTS/
RUN ./configure && make && sudo make install-strip
WORKDIR /opt
RUN rm -r 0.9.56.2-LTS.tar.gz firejail-0.9.56.2-LTS

RUN git clone --recurse-submodules https://github.com/Acwok/webots.git
WORKDIR /opt/webots
RUN git checkout fe5893b968e160447a52cc4619ad68a8f41f8022
ENV WEBOTS_DISABLE_SAVE_PERSPECTIVE_ON_CLOSE 1
ENV WEBOTS_ALLOW_MODIFY_INSTALLATION=1
ENV WEBOTS_HOME /opt/webots
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:/opt/webots/lib
RUN make -j2
ENV PATH /opt/webots:${PATH}

# Copy webots preferences
#ADD ./Webots-R2020b.conf /root/.config/Cyberbotics/Webots-R2020b.conf
