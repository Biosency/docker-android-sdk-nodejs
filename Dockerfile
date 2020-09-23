FROM node:lts

ENV ANDROID_SDK_HOME /opt/android-sdk-linux
ENV ANDROID_SDK_ROOT /opt/android-sdk-linux

ENV PATH "${PATH}:${ANDROID_SDK_HOME}/platform-tools:${ANDROID_SDK_HOME}/tools/bin:${ANDROID_SDK_HOME}/emulator:${ANDROID_SDK_HOME}/bin"

RUN dpkg --add-architecture i386 && apt-get update -yqq && apt-get install -y \
  curl \
  expect \
  git \
  libc6:i386 \
  libgcc1:i386 \
  libncurses5:i386 \
  libstdc++6:i386 \
  zlib1g:i386 \
  openjdk-8-jdk \
  wget \
  unzip \
  vim \
  && apt-get clean

RUN groupadd android && useradd -d ${ANDROID_SDK_HOME} -g android android 

WORKDIR ${ANDROID_SDK_HOME}

COPY docker-android-sdk/tools /opt/tools
COPY docker-android-sdk/licenses /opt/licenses

RUN /opt/tools/entrypoint.sh built-in

RUN ${ANDROID_SDK_HOME}/tools/bin/sdkmanager "build-tools;29.0.3" \
  && ${ANDROID_SDK_HOME}/tools/bin/sdkmanager "platforms;android-29" \
  && ${ANDROID_SDK_HOME}/tools/bin/sdkmanager "platform-tools" \
  && ${ANDROID_SDK_HOME}/tools/bin/sdkmanager "emulator" \
  && ${ANDROID_SDK_HOME}/tools/bin/sdkmanager "system-images;android-29;google_apis;x86_64"

CMD /opt/tools/entrypoint.sh built-in

ENV CORDOVA_VERSION 9.0.0
RUN npm i -g cordova@${CORDOVA_VERSION}

ENV GRADLE_HOME /opt/gradle
ENV PATH "${PATH}:${GRADLE_HOME}"
ENV GRADLE_VERSION 6.6.1
ARG GRADLE_DOWNLOAD_SHA256=7873ed5287f47ca03549ab8dcb6dc877ac7f0e3d7b1eb12685161d10080910ac
RUN set -o errexit -o nounset \
    && echo "Downloading Gradle" \
    && wget --no-verbose --output-document=gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
    \
    && echo "Checking download hash" \
    && echo "${GRADLE_DOWNLOAD_SHA256} *gradle.zip" | sha256sum --check - \
    \
    && echo "Installing Gradle" \
    && unzip gradle.zip \
    && rm gradle.zip \
    && mv "gradle-${GRADLE_VERSION}" "${GRADLE_HOME}/" \
    \
    && echo "Testing Gradle installation"
