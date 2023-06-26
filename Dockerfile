ARG BASE_IMAGE=nvidia/cuda:11.8.0-base-ubuntu22.04
FROM ${BASE_IMAGE} AS downloader

# Determine Webots version to be used and set default argument
ARG WEBOTS_VERSION=R2023b
ARG WEBOTS_PACKAGE_PREFIX=

# Disable dpkg/gdebi interactive dialogs
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --yes wget bzip2 && rm -rf /var/lib/apt/lists/ && \
 wget https://github.com/cyberbotics/webots/releases/download/$WEBOTS_VERSION/webots-$WEBOTS_VERSION-x86-64$WEBOTS_PACKAGE_PREFIX.tar.bz2 && \
 tar xjf webots-*.tar.bz2 && rm webots-*.tar.bz2

FROM ${BASE_IMAGE}

# Disable dpkg/gdebi interactive dialogs
ENV DEBIAN_FRONTEND=noninteractive

# Install Webots runtime dependencies
RUN apt-get update && apt-get install --yes wget xvfb && rm -rf /var/lib/apt/lists/ && \
  wget https://raw.githubusercontent.com/cyberbotics/webots/master/scripts/install/linux_runtime_dependencies.sh && \
  chmod +x linux_runtime_dependencies.sh && ./linux_runtime_dependencies.sh && rm ./linux_runtime_dependencies.sh && rm -rf /var/lib/apt/lists/

# Install Webots
WORKDIR /usr/local
COPY --from=downloader /webots /usr/local/webots/
ENV QTWEBENGINE_DISABLE_SANDBOX=1
ENV WEBOTS_HOME /usr/local/webots
ENV PATH /usr/local/webots:${PATH}

# Enable OpenGL capabilities
ENV NVIDIA_DRIVER_CAPABILITIES graphics,compute,utility

# Finally open a bash command to let the user interact
CMD ["/bin/bash"]
