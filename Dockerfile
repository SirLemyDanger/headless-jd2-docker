FROM consol/ubuntu-xfce-vnc

LABEL maintainer="docker-image@lemydanger.eu"

ENV JD_UID 1100
ENV JD_GID 1100

#install java
USER 0
RUN \
    apt-get update; \
    apt-get install -y openjdk-8-jre; \
    apt-get clean -y

RUN groupadd -r -g $JD_UID jdownloader \
&& useradd -r -u $JD_UID -g $JD_GID -d /jdownloader -m jdownloader

# Create directory, downloader JD2 and start JD2 for the initial update and creation of config files.
RUN \
    mkdir -p /opt/JDownloader/cfg &&\
	wget -O /opt/JDownloader/JDownloader.jar --user-agent="https://hub.docker.com/r/lemydanger/vnc-jdownloader/" --progress=bar:force http://installer.jdownloader.org/JDownloader.jar && \
	java -Djava.awt.headless=true -jar /opt/JDownloader/JDownloader.jar
    

COPY startJD2.sh /opt/JDownloader/
RUN chmod +x /opt/JDownloader/startJD2.sh

RUN chown -R $JD_UID:$JD_GID /opt/JDownloader/

VOLUME /opt/JDownloader/cfg

#click'n'load port
EXPOSE 9666
RUN \
    apt-get update; \
    apt-get install -y iptables; \
    apt-get clean -y
RUN \
    sysctl -w net.ipv4.conf.eth0.route_localnet=1 &&\
    iptables -t nat -I PREROUTING -p tcp --dport 9666 -j DNAT --to-destination 127.0.0.1:9666

USER $JD_UID:$JD_GID
# Run this when the container is started
CMD /opt/JDownloader/startJD2.sh
