ARG BASE_IMAGE=nvidia/cudagl:10.0-devel-ubuntu18.04
FROM ${BASE_IMAGE}

# Disable dpkg/gdebi interactive dialogs
ENV DEBIAN_FRONTEND=noninteractive

# Install Webots runtime dependencies
RUN apt-get update && apt-get install --yes wget
RUN wget https://raw.githubusercontent.com/cyberbotics/webots/improve-install-script/scripts/install/linux_runtime_dependencies.sh
RUN chmod +x linux_runtime_dependencies.sh
RUN ./linux_runtime_dependencies.sh
RUN rm ./linux_runtime_dependencies.sh

# Install Webots
WORKDIR /usr/local
RUN wget https://github.com/cyberbotics/webots/releases/download/R2020b/webots-R2020b-x86-64_ubuntu-16.04.tar.bz2
RUN tar xjf webots-R2020b-x86-64_ubuntu-16.04.tar.bz2
RUN rm webots-R2020b-x86-64_ubuntu-16.04.tar.bz2
RUN sed -i 's/"$webots_home\/bin\/webots-bin" "$@"/"$webots_home\/bin\/webots-bin" --no-sandbox "$@"/g' /usr/local/webots/webots
ENV WEBOTS_HOME /usr/local
ENV PATH /usr/local/webots:${PATH}

# Finally open a bash command to let the user interact
CMD ["/bin/bash"]
