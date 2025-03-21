FROM python:3.12.2
LABEL maintainer="lauwarm@mailbox.org"

ENV streamlinkCommit=01d401f7db6dd44bed4f31b00817b241824aaa2a

#ENV streamlinkVersion=6.7.4
#ENV PATH "${HOME}/.local/bin:${PATH}"

#ADD https://github.com/streamlink/streamlink/releases/download/${streamlinkVersion}/streamlink-${streamlinkVersion}.tar.gz /opt/

#RUN apt-get update && apt-get install gosu

#RUN pip3 install versioningit

#RUN tar -xzf /opt/streamlink-${streamlinkVersion}.tar.gz -C /opt/ && \
#	rm /opt/streamlink-${streamlinkVersion}.tar.gz && \
#	cd /opt/streamlink-${streamlinkVersion}/ && \
#	python3 setup.py install

EXPOSE 8080

RUN apt-get update && apt-get install gosu && apt-get install python3-pip -y

RUN pip3 install --upgrade git+https://github.com/streamlink/streamlink.git@${streamlinkCommit}

RUN  echo 'export PATH="${HOME}/.local/bin:${PATH}"'

RUN mkdir /home/download
RUN mkdir /home/script
RUN mkdir /home/plugins

#RUN git clone https://github.com/Damianonymous/streamlink-plugins.git
#RUN cp /streamlink-plugins/*.py /home/plugins/

# Kopiera streamlink-recorder.sh till containern
COPY ./streamlink-recorder.sh /home/script/
# COPY ./entrypoint.sh /home/script

COPY ./docker-entrypoint-osc.sh /home/script
RUN chmod +x /home/script/docker-entrypoint-osc.sh
RUN chmod +x /home/script/streamlink-recorder.sh

ENTRYPOINT [ "/home/script/docker-entrypoint-osc.sh" ]

CMD /bin/bash /home/script/streamlink-recorder.sh ${streamOptions} ${streamLink} ${streamQuality} ${streamName}
