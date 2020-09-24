FROM node:lts
LABEL author="Biosency IT | web@biosency.com" version="1.0"

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
