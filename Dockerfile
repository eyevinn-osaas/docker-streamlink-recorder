FROM python:3-alpine 

RUN apk add gcc musl-dev --no-cache \ 
	&& pip install streamlink \ 
	&& apk del gcc musl-dev --no-cache \ 
	&& rm -Rf /tmp/* 

ADD https://raw.githubusercontent.com/back-to/streamlink/277d064051e9166f61df315ae04cc71011a61e98/src/streamlink/plugins/chaturbate.py /home
ADD https://gist.githubusercontent.com/lauwarm/5cae7bd36e4f3079a420618c9585e644/raw/a649cf467ba063ab784233696ff067431fbea232/streamlink-recorder.py /

CMD python ./streamlink-recorder.py ${streamLink} ${streamQuality} ${streamName}
