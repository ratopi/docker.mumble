FROM debian:10.7 AS BUILDER

ARG MUMBLE_VERSION=1.3.4

RUN apt-get update
RUN apt-get install -y wget bzip2

WORKDIR /BUILD/

RUN wget "https://github.com/mumble-voip/mumble/releases/download/${MUMBLE_VERSION}/murmur-static_x86-${MUMBLE_VERSION}.tar.bz2"

RUN tar xjf murmur*.tar.bz2
RUN rm murmur*.tar.bz2
RUN mv -v murmur*/* .
RUN rmdir murmur*/

RUN chmod a+rw ./
RUN chmod a+r ./*
RUN chmod a+rx ./murmur.x86

RUN sed -e 's+^;uname=.*+uname=mumble+' -e '/^welcometext=\"/s+\"$+<i>Running on docker with image: ratopi/mumble</i><br />\"+' -i murmur.ini

# ---

FROM debian:10.7
LABEL maintainer="Ralf Th. Pietsch <ratopi@abwesend.de>"

EXPOSE 64738 64738/udp
VOLUME /conf/

RUN adduser mumble

WORKDIR /app/

COPY --from=BUILDER /BUILD/* ./

CMD test -e /conf/murmur.ini || cp -va ./murmur.ini /conf/murmur.ini ; chown mumble.mumble /conf/ /conf/* ; ./murmur.x86 -fg -ini /conf/murmur.ini
