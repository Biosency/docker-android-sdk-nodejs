FROM androidsdk/android-29
LABEL author="Biosency IT | web@biosency.com" version="1.0"

RUN apt-get update \
	&& apt-get install -y sudo gradle \
	&& curl -sL https://deb.nodesource.com/setup_lts.x | sudo -E bash - \
	&& apt-get install -y nodejs
