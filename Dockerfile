FROM buildpack-deps
WORKDIR /
RUN groupadd -g 994 bitlbee 
RUN useradd -ms /sbin/nologin -u 996 -g 994 -d /var/lib/bitlbee bitlbee
RUN cd && \
apt-get update && apt-get install -y --no-install-recommends autoconf automake dpkg-dev gettext gcc git libtool libtool-bin make libglib2.0-dev libhttp-parser-dev libmarkdown2-dev libotr5-dev libpurple-dev libgnutls28-dev libjson-glib-dev libprotobuf-c-dev protobuf-c-compiler mercurial unzip && \
cd && \
# bitlbee
git clone https://github.com/bitlbee/bitlbee.git && \
cd bitlbee && \
./configure --jabber=1 --otr=1 --purple=1 && \
make && \
make install && \
make install-etc && \
make install-dev && \
cd && \
# facebook plugin for bitlbee
git clone https://github.com/bitlbee/bitlbee-facebook.git && \
cd bitlbee-facebook && \
./autogen.sh && \
make && \
make install && \
libtool --finish /usr/local/lib/bitlbee && \
cd && \  
# hangouts plugin for libpurple
hg clone https://bitbucket.org/EionRobb/purple-hangouts && \
cd purple-hangouts && \
make && \
make install && \
libtool --finish /usr/local/lib/bitlbee && \
cd && \
# rocketchat plugin for libpurple
hg clone https://bitbucket.org/EionRobb/purple-rocketchat && \
cd purple-rocketchat && \
make && \
make install && \
libtool --finish /usr/local/lib/bitlbee && \
cd && \
# matrix plugin for libpurple
git clone https://github.com/EionRobb/purple-matrix && \
#git clone https://github.com/matrix-org/purple-matrix && \
cd purple-matrix && \
make && \
make install && \
libtool --finish /usr/local/lib/bitlbee && \
cd && \
# discord plugin for libpurple
git clone https://github.com/EionRobb/purple-discord && \
cd purple-discord && \
make && \
make install && \
libtool --finish /usr/local/lib/bitlbee && \
cd && \
# mattermost plugin for libpurple
git clone https://github.com/EionRobb/purple-mattermost && \
cd purple-mattermost && \
make && \
make install && \
libtool --finish /usr/local/lib/bitlbee && \
cd && \
# discord plugin for bitlbee
git clone https://github.com/sm00th/bitlbee-discord && \
cd bitlbee-discord && \
./autogen.sh && \
./configure && \
make && \
make install && \
libtool --finish /usr/local/lib/bitlbee && \
cd && \
# https://github.com/dylex/slack-libpurple
# https://api.slack.com/custom-integrations/legacy-tokens
git clone https://github.com/udp/json-parser && \
cd json-parser && \
./configure && \
make && \
make install && \
cd && \
git clone https://github.com/dylex/slack-libpurple && \
cd slack-libpurple && \
make && \
make install && \
libtool --finish /usr/local/lib/bitlbee && \
cd && \
apt-get autoremove -y --purge autoconf automake gcc git libtool make mercurial dpkg-dev && \
apt-get autoremove -y --purge protobuf-c-compiler unzip && \
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /tmp/* && \
cd && \
rm -fr bitlbee-master && \
rm -fr bitlbee-facebook && \
rm -rf purple-hangouts && \
rm -rf purple-rocketchat && \
rm -rf purple-matrix && \
rm -fr bitlbee-discord && \
rm -rf purple-mattermost && \
rm -rf purple-discord && \
rm -rf slack-libpurple && \
mkdir -p /var/lib/bitlbee && \
chown -R bitlbee:bitlbee /var/lib/bitlbee* # dup: otherwise it won't be chown'ed when using volumes
COPY etc/bitlbee/bitlbee.conf /usr/local/etc/bitlbee/bitlbee.conf
COPY etc/bitlbee/motd.txt /usr/local/etc/bitlbee/motd.txt
VOLUME ["/var/lib/bitlbee"]
RUN touch /var/run/bitlbee.pid && \
	chown bitlbee:bitlbee /var/run/bitlbee.pid && \
	chown -R bitlbee:bitlbee /usr/local/etc/* && \
	chown -R bitlbee:bitlbee /var/lib/bitlbee*  # dup: otherwise it won't be chown'ed when using volumes
USER bitlbee
EXPOSE 16667
CMD [ "/usr/local/sbin/bitlbee", "-c", "/usr/local/etc/bitlbee/bitlbee.conf", "-n", "-u", "bitlbee" ]
# use this instead for debugging
#ENV BITLBEE_DEBUG=1
#CMD [ "/usr/local/sbin/bitlbee", "-Dnv", "-c", "/usr/local/etc/bitlbee/bitlbee.conf", "-n", "-u", "bitlbee" ]
