FROM consol/ubuntu-xfce-vnc

MAINTAINER LemyDanger <docker-image@lemydanger.eu>

#install java
USER 0
apt-get update 
apt-get install -y openjdk-8-jre
apt-get clean -y

RUN groupadd -r -g 1100 jdownloader \
&& useradd -r -u 1100 -g 1100 -d /jdownloader -m jdownloader

USER 1100:1100
# Create directory, downloader JD" and start JD2 for the initial update and creation of config files.
RUN \
	mkdir -p /opt/JDownloader/ && \
	wget -O /opt/JDownloader/JDownloader.jar --user-agent="https://hub.docker.com/r/lemydanger/vnc-jdownloader/" --progress=bar:force http://installer.jdownloader.org/JDownloader.jar && \
	java -Djava.awt.headless=true -jar /opt/JDownloader/JDownloader.jar


COPY startJD2.sh /opt/JDownloader/
RUN chmod +x /opt/JDownloader/startJD2.sh


# Run this when the container is started
CMD /opt/JDownloader/startJD2.sh
