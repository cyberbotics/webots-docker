ARG BASE_IMAGE=nvidia/cudagl:10.0-devel-ubuntu18.04
FROM ${BASE_IMAGE}

# Disable dpkg/gdebi interactive dialogs
ENV DEBIAN_FRONTEND=noninteractive

# Install system tools and dependencies
RUN apt-get update && apt-get install --yes \
    build-essential \
    software-properties-common \
    pkg-config \
    cmake \
    g++ \
    python \
    wget \
    gdebi \
    libxss-dev \
    mlocate \
    cmake-curses-gui \
    gdb \
    nano

# Install ROS Melodic
RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN apt-get update && apt-get install --yes ros-melodic-desktop-full \
    ros-melodic-moveit \
    ros-melodic-joint-state-publisher-gui \
    ros-melodic-plotjuggler \
    ros-melodic-trac-ik-kinematics-plugin \
    python-rosdep \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool

RUN rosdep init
RUN rosdep update
RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc

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

# ROS Webots
RUN apt-get update && apt-get install --yes ros-melodic-webots-ros

# Patch Webots launch from Docker to add --no-sandbox option by default with roslaunch
RUN echo "38a39,40\n> else:\n>     command.append('--no-sandbox')" | patch /opt/ros/melodic/lib/webots_ros/webots_launcher.py

# Build ViSP
WORKDIR /workspace/ViSP
RUN git clone --depth 1 https://github.com/lagadic/visp.git
WORKDIR /workspace/ViSP/visp-build
RUN cmake ../visp -DBUILD_DEMOS=OFF -DBUILD_TESTS=OFF -DBUILD_TUTORIALS=OFF -DBUILD_EXAMPLES=OFF
RUN make -j2
RUN make install
RUN cd /workspace && rm -rf ViSP

# Build pugixml
WORKDIR /workspace/
RUN git clone https://github.com/zeux/pugixml.git
WORKDIR /workspace/pugixml/build
RUN cmake ..
RUN make install
RUN rm -rf /workspace/pugixml/

# Install Groot dependencies and build it from sources
WORKDIR /workspace/
RUN apt-get update && apt-get install --yes qtbase5-dev libqt5svg5-dev  libdw-dev libzmq3-dev
RUN git clone https://github.com/BehaviorTree/Groot.git
WORKDIR /workspace/Groot
RUN git checkout 787ffa1ceda05368e028585615b2a4000292c28a
RUN git submodule update --init --recursive
WORKDIR /workspace/Groot/build
RUN cmake ..
RUN make -j2
RUN make install
RUN rm -rf /workspace/Groot/
# Add to LD_LIBRARY_PATH to let Groot find libbehavior_tree_editor.so
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:/usr/local/lib

# Build I3DS
WORKDIR /workspace
RUN git clone https://github.com/I3DS/i3ds-framework-cpp.git

WORKDIR /workspace/i3ds-framework-cpp
RUN cp -r external/include/* /usr/local/include/
RUN cp -r external/lib/* /usr/local/lib/

WORKDIR /workspace/i3ds-framework-cpp/build
RUN cmake .. -DBUILD_BINDINGS=OFF
RUN make -j2
RUN make install
RUN ldconfig
RUN rm -rf /workspace/i3ds-framework-cpp

# Default workdir
ENV SEQUENCER_DIR /catkin_ws/src/pulsar_simulator_ros/functional_layer/sequencer_node/sequencer/
ENV PULSAR_SIMULATOR_DIR /workspace/pulsar_simulator
ENV LUA_PATH $PULSAR_SIMULATOR_DIR/libraries/LIP/?.lua
WORKDIR ${PULSAR_SIMULATOR_DIR}

# Copy webots preferences
ADD ./Webots-R2020b.conf /root/.config/Cyberbotics/Webots-R2020b.conf
