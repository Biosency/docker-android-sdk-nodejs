FROM androidsdk/android-30
LABEL author="Biosency IT | web@biosency.com" version="1.0"

RUN apt-get update \
	&& apt-get install -y sudo gradle \
	&& curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash - \
	&& sudo apt-get install -y nodejs
