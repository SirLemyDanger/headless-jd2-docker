FROM consol/ubuntu-xfce-vnc

LABEL maintainer="docker-image@lemydanger.eu"

#install java
USER 0
RUN \
    apt-get update; \
    apt-get install -y openjdk-8-jre; \
    apt-get clean -y

RUN groupadd -r -g 1100 jdownloader \
&& useradd -r -u 1100 -g 1100 -d /jdownloader -m jdownloader

# Create directory, downloader JD2 and start JD2 for the initial update and creation of config files.
RUN \
    mkdir -p /opt/JDownloader/ &&\
	wget -O /opt/JDownloader/JDownloader.jar --user-agent="https://hub.docker.com/r/lemydanger/vnc-jdownloader/" --progress=bar:force http://installer.jdownloader.org/JDownloader.jar && \
	java -Djava.awt.headless=true -jar /opt/JDownloader/JDownloader.jar
    

COPY startJD2.sh /opt/JDownloader/
RUN chmod +x /opt/JDownloader/startJD2.sh

RUN chown -R 1100:1100 /opt/JDownloader/

VOLUME /opt/JDownloader/cfg
RUN chown -R 1100:1100 /opt/JDownloader/cfg
#click'n'load port
EXPOSE 9666

# ADD ./dockerstartup/ /dockerstartup/
# RUN chmod +x /dockerstartup/jdownloader_startup.sh

USER 1100:1100
# Run this when the container is started
# ENTRYPOINT ["/dockerstartup/jdownloader_startup.sh"]
CMD /opt/JDownloader/startJD2.sh
