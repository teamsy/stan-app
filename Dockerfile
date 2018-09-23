# Pull base image.
FROM ubuntu:16.04

# Install base software packages
RUN apt-get update && \
    apt-get install software-properties-common \
    python-software-properties \
    wget \
    curl \
    git \
    lftp \
    usbutils\
    unzip -y && \
    apt-get clean


# ——————————
# Install Java.
# ——————————

RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer


# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle



# ——————————
# Installs i386 architecture required for running 32 bit Android tools
# ——————————

RUN dpkg --add-architecture i386 && \
    apt-get update -y && \
    apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y && \
    apt-get clean


# ——————————
# Installs Android SDK
# ——————————

ENV ANDROID_SDK_VERSION r24.4.1
ENV ANDROID_BUILD_TOOLS_VERSION build-tools-27.0.3,build-tools-25.0.3,build-tools-25.0.2,build-tools-25.0.1,build-tools-23.0.2,build-tools-23.0.3,build-tools-23.0.1

ENV ANDROID_SDK_FILENAME android-sdk_${ANDROID_SDK_VERSION}-linux.tgz
ENV ANDROID_SDK_URL http://dl.google.com/android/${ANDROID_SDK_FILENAME}
ENV ANDROID_API_LEVELS android-27,android-25,android-23
ENV ANDROID_EXTRA_COMPONENTS extra-android-m2repository,extra-google-m2repository
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools
RUN cd /opt && \
    wget -q ${ANDROID_SDK_URL} && \
    tar -xzf ${ANDROID_SDK_FILENAME} && \
    rm ${ANDROID_SDK_FILENAME} && \
    echo y | android update sdk --no-ui -a --filter tools,platform-tools,${ANDROID_API_LEVELS},${ANDROID_BUILD_TOOLS_VERSION} && \
    echo y | android update sdk --no-ui --all --filter "${ANDROID_EXTRA_COMPONENTS}"

# ——————————
# Install Node
# ——————————
ENV NODE_VERSION 8
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash
RUN apt-get install --yes nodejs
RUN node -v
RUN npm -v
RUN npm i -g nodemon
RUN nodemon -v

ENV PATH ${PATH}:/opt/node/bin

# ——————————
# Install Basic React-Native packages
# ——————————
RUN npm install -g react-native-cli
RUN npm install -g react-native-update-cli
RUN npm install -g yarn
RUN npm install -g rnpm
ENV LANG en_US.UTF-8

# Clean up when done.
RUN apt-get clean

# Default react-native web server port
EXPOSE 8081

WORKDIR /app

COPY . /app
