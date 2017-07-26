# Dockerfile

FROM buildpack-deps

WORKDIR /

RUN groupadd -g 994 bitlbee 
RUN useradd -ms /sbin/nologin -u 996 -g 994 -d /var/lib/bitlbee bitlbee

#COPY build/get-sources.sh /get-sources.sh

RUN cd && \

apt-get update && apt-get install -y --no-install-recommends autoconf automake gettext gcc git libtool make dpkg-dev libglib2.0-dev libotr5-dev libpurple-dev libgnutls28-dev libjson-glib-dev libprotobuf-c-dev protobuf-c-compiler mercurial unzip && \
cd && \

# libpurple-rocketchat
apt-get install -y libmarkdown2-dev && \
cd && \

# libpurple-matrix
apt-get install -y libhttp-parser-dev && \
cd && \

git clone https://github.com/bitlbee/bitlbee.git && \
cd bitlbee && \
./configure --jabber=1 --otr=1 --purple=1 && \
make && \
make install && \
make install-etc && \
make install-dev && \
cd && \

git clone https://github.com/bitlbee/bitlbee-facebook.git && \
cd bitlbee-facebook && \
./autogen.sh && \
make && \
make install && \
cd && \  

hg clone https://bitbucket.org/EionRobb/purple-hangouts && \
cd purple-hangouts && \
make && \
make install && \
cd && \

hg clone https://bitbucket.org/EionRobb/purple-rocketchat && \
cd purple-rocketchat && \
make && \
make install && \
cd && \

git clone https://github.com/EionRobb/purple-matrix && \
cd purple-matrix && \
make && \
make install && \
cd && \

git clone https://github.com/EionRobb/purple-discord && \
cd purple-discord && \
make && \
make install && \
cd && \

git clone https://github.com/EionRobb/purple-mattermost && \
cd purple-mattermost && \
make && \
make install && \
cd && \

apt-get autoremove -y --purge autoconf automake gcc git libtool make mercurial dpkg-dev && \
apt-get autoremove -y --purge protobuf-c-compiler unzip && \

apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /tmp/* && \
cd && \

rm -fr bitlbee-master* && \
rm -fr bitlbee-facebook* && \
rm -rf purple-hangouts* && \
rm -rf purple-rocketchat && \
rm -rf purple-matrix && \
rm -rf purple-discord && \
rm -rf purple-mattermost && \

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
