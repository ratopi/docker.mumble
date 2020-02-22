FROM debian:10 AS BUILDER

RUN apt-get update
RUN apt-get install -y wget bzip2

WORKDIR /BUILD/

RUN wget https://github.com/mumble-voip/mumble/releases/download/1.3.0/murmur-static_x86-1.3.0.tar.bz2

RUN tar xjf murmur*.tar.bz2

RUN rm murmur*.tar.bz2

RUN mv -v murmur*/* .

RUN rmdir murmur*/

# ---

FROM debian:10

WORKDIR /app/

COPY --from=BUILDER /BUILD/* ./

RUN find

RUN mkdir /conf/

CMD test -e /conf/murmur.ini || cp -v ./murmur.ini /conf/murmur.ini ; ./murmur.x86 -fg -ini /conf/murmur.ini

