FROM androidsdk/android-29
LABEL author="Biosency IT | web@biosency.com" version="1.0"

RUN apt-get update && apt-get install -y gradle \
	nodejs \
	npm
