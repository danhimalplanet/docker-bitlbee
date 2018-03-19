FROM alpine

RUN addgroup -g 994 bitlbee
RUN adduser -G bitlbee -H -D -g 'bitlbee' bitlbee -h /var/lib/bitlbee -s /sbin/nologin
RUN apk add --update \
autoconf \
automake \
build-base \
git \
glib-dev \
gnutls-dev \
json-glib-dev \
libtool \
libgcrypt-dev \
libwebp \
mercurial \
pidgin-dev \
protobuf-c-dev 

# bitlbee
RUN git clone https://github.com/bitlbee/bitlbee.git && \
cd bitlbee && \
./configure --jabber=0 --otr=0 --msn=0 --oscar=0 --purple=1 && \
make && \
make install && \
make install-etc && \
make install-dev && \
cd && \
rm -rf bitlbee

# slack libpurple dylex
RUN git clone https://github.com/dylex/slack-libpurple && \
cd slack-libpurple && \
mkdir -p /usr/share/pixmaps/pidgin/protocols/16/ && \
mkdir -p /usr/share/pixmaps/pidgin/protocols/22/ && \
mkdir -p /usr/share/pixmaps/pidgin/protocols/48/ && \
make && \
make install && \
cd && \
rm -rf slack-libpurple

# facebook plugin for bitlbee
RUN git clone https://github.com/bitlbee/bitlbee-facebook.git && \
cd bitlbee-facebook && \
./autogen.sh && \
make && \
make install && \
cd && \
rm -rf bitlbee-facebook

# hangouts plugin for libpurple
RUN cd && \
hg clone https://bitbucket.org/EionRobb/purple-hangouts && \
cd purple-hangouts && \
make && \
make install && \
cd && \
rm -rf purple-hangouts

# rocketchat plugin for libpurple
#RUN cd && \
#hg clone https://bitbucket.org/EionRobb/purple-rocketchat && \
#cd purple-rocketchat && \
#make && \
#make install && \
#cd && \
#rm -rf purple-rocketchat

# matrix plugin for libpurple from matrix
#RUN cd && \
#git clone https://github.com/matrix-org/purple-matrix && \
#cd purple-matrix && \
#make && \
#make install && \
#cd && \
#rm -rf purple-matrix

# matrix plugin for libpurple from EionRobb
#RUN cd && \
#git clone https://github.com/EionRobb/purple-matrix && \
#cd purple-matrix && \
#make && \
#make install && \
#cd && \
#rm -rf purple-matrix

# discord plugin for libpurple
RUN cd && \
git clone https://github.com/EionRobb/purple-discord && \
cd purple-discord && \
make && \
make install && \
cd && \
rm -rf purple-discord

# mattermost plugin for libpurple
#RUN cd && \
#git clone https://github.com/EionRobb/purple-mattermost && \
#cd purple-mattermost && \
#make && \
#make install && \
#cd && \
#rm -rf purple-mattermost

# discord plugin for bitlbee
RUN cd && \
git clone https://github.com/sm00th/bitlbee-discord && \
cd bitlbee-discord && \
./autogen.sh && \
./configure && \
make && \
make install && \
cd && \
rm -rf bitlbee-discord

# https://github.com/majn/telegram-purple
#RUN cd && \
#git clone https://github.com/majn/telegram-purple && \
#cd telegram-purple && \
#./configure && \
#git submodule update --init --recursive && \
#make && \
#make install && \
#cd && \
#rm -rf telegram-purple

RUN apk del git mercurial
RUN rm -rf /var/cache/apk/*
RUN mkdir -p /var/lib/bitlbee
RUN cd && \
chown -R bitlbee:bitlbee /var/lib/bitlbee*
COPY etc/bitlbee/bitlbee.conf /usr/local/etc/bitlbee/bitlbee.conf
COPY etc/bitlbee/motd.txt /usr/local/etc/bitlbee/motd.txt
VOLUME ["/var/lib/bitlbee"]
# dup: otherwise it won't be chown'ed when using volumes
RUN touch /var/run/bitlbee.pid && \
        chown bitlbee:bitlbee /var/run/bitlbee.pid && \
        chown -R bitlbee:bitlbee /usr/local/etc/* && \
        chown -R bitlbee:bitlbee /var/lib/bitlbee*
USER bitlbee
EXPOSE 16667
CMD [ "/usr/local/sbin/bitlbee", "-c", "/usr/local/etc/bitlbee/bitlbee.conf", "-n", "-u", "bitlbee" ]
