ARG BASE_IMAGE=nvidia/opengl:1.2-glvnd-devel-ubuntu20.04
FROM ${BASE_IMAGE} AS downloader

# Determine Webots version to be used and set default argument
ARG WEBOTS_VERSION=R2022b
ARG WEBOTS_PACKAGE_PREFIX=

# Disable dpkg/gdebi interactive dialogs
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install --yes wget && rm -rf /var/lib/apt/lists/ && \
 wget https://github.com/cyberbotics/webots/releases/download/$WEBOTS_VERSION/webots-$WEBOTS_VERSION-x86-64$WEBOTS_PACKAGE_PREFIX.tar.bz2 && \
 tar xjf webots-*.tar.bz2 && rm webots-*.tar.bz2

FROM ${BASE_IMAGE}

# Disable dpkg/gdebi interactive dialogs
ENV DEBIAN_FRONTEND=noninteractive

# Install Webots runtime dependencies
RUN apt update && apt install --yes wget && rm -rf /var/lib/apt/lists/ && \
  wget https://raw.githubusercontent.com/cyberbotics/webots/master/scripts/install/linux_runtime_dependencies.sh && \
  chmod +x linux_runtime_dependencies.sh && ./linux_runtime_dependencies.sh && rm ./linux_runtime_dependencies.sh && rm -rf /var/lib/apt/lists/

# Install X virtual framebuffer to be able to use Webots without GPU and GUI (e.g. CI)
RUN apt update && apt install --yes xvfb && rm -rf /var/lib/apt/lists/

# Install Webots
WORKDIR /usr/local
COPY --from=downloader /webots /usr/local/webots/
ENV QTWEBENGINE_DISABLE_SANDBOX=1
ENV WEBOTS_HOME /usr/local/webots
ENV PATH /usr/local/webots:${PATH}

# Finally open a bash command to let the user interact
CMD ["/bin/bash"]
