ARG BASE_IMAGE=nvidia/cudagl:11.4.2-devel-ubuntu20.04
FROM ${BASE_IMAGE}

# Disable dpkg/gdebi interactive dialogs
ENV DEBIAN_FRONTEND=noninteractive

# Determine Webots version to be used and set default argument
ARG WEBOTS_VERSION=R2022a
ARG WEBOTS_PACKAGE_PREFIX=

# Fix NVIDIA CUDA Linux repository key rotation
RUN apt-key del 7fa2af80
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu$(cat /etc/os-release | grep VERSION_ID | awk '{print substr($0,13,5)}' | awk -F'.' '{print $1$2}')/x86_64/3bf863cc.pub

# Install Webots runtime dependencies
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
