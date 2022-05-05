ARG BASE_IMAGE=nvidia/cudagl:11.4.2-devel-ubuntu20.04
FROM ${BASE_IMAGE}

# Disable dpkg/gdebi interactive dialogs
ENV DEBIAN_FRONTEND=noninteractive

ENV BASE_IMAGE $BASE_IMAGE

# Determine Webots version to be used and set default argument
ARG WEBOTS_VERSION=R2022a
ARG WEBOTS_PACKAGE_PREFIX=

# Install Webots runtime dependencies
RUN echo ${BASE_IMAGE}
RUN apt-key del 7fa2af80
RUN https://developer.download.nvidia.com/compute/cuda/repos/ubuntu$(echo ${BASE_IMAGE} | awk '{print substr($0,length($0)-4,5)}' | awk -F'.' '{print $1$2}')/x86_64/cuda-keyring_1.0-1_all.deb
RUN dpkg -i cuda-keyring_1.0-1_all.deb
RUN apt update && apt install --yes wget && rm -rf /var/lib/apt/lists/
RUN wget https://raw.githubusercontent.com/cyberbotics/webots/master/scripts/install/linux_runtime_dependencies.sh
RUN chmod +x linux_runtime_dependencies.sh && ./linux_runtime_dependencies.sh && rm ./linux_runtime_dependencies.sh && rm -rf /var/lib/apt/lists/

# Install X virtual framebuffer to be able to use Webots without GPU and GUI (e.g. CI)
RUN apt update && apt install --yes xvfb && rm -rf /var/lib/apt/lists/

# Install Webots
WORKDIR /usr/local
RUN wget https://github.com/cyberbotics/webots/releases/download/$WEBOTS_VERSION/webots-$WEBOTS_VERSION-x86-64$WEBOTS_PACKAGE_PREFIX.tar.bz2
RUN tar xjf webots-*.tar.bz2 && rm webots-*.tar.bz2
ENV QTWEBENGINE_DISABLE_SANDBOX=1
ENV WEBOTS_HOME /usr/local/webots
ENV PATH /usr/local/webots:${PATH}

# Finally open a bash command to let the user interact
CMD ["/bin/bash"]
