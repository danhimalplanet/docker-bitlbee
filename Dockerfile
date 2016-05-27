# downloads latest bitlbee
# downlaods latest skype4pidgin-master
# downloads latest bitlbee-facebook-master
# downloads latest purple-hangouts

FROM buildpack-deps:latest
MAINTAINER Michele Bologna <michele.bologna@gmail.com>

#ENV PURPLE_HANGOUTS_VER=ec3277ac484b

RUN groupadd -g 994 bitlbee 
RUN useradd -ms /sbin/nologin -u 996 -g 994 -d /var/lib/bitlbee bitlbee

RUN apt-get update && apt-get install -y --no-install-recommends autoconf automake gettext gcc libtool make dpkg-dev libglib2.0-dev libotr5-dev libpurple-dev libgnutls28-dev libjson-glib-dev libprotobuf-c-dev protobuf-c-compiler unzip && \
cd && \

curl -o bitlbee-master.zip -LO# https://github.com/bitlbee/bitlbee/archive/master.zip && \

curl -o skype4pidgin-master.zip -LO# https://github.com/EionRobb/skype4pidgin/archive/master.zip && \

curl -o bitlbee-facebook-master.zip -LO# https://github.com/bitlbee/bitlbee-facebook/archive/master.zip && \

curl -o purple-hangouts.zip -LO# https://bitbucket.org/EionRobb/purple-hangouts/get/tip.zip && \

unzip bitlbee-master.zip && \
cd bitlbee-master && \
./configure --jabber=1 --otr=1 --purple=1 && \
make && \
make install && \
make install-etc && \
make install-dev && \
cd && \

unzip skype4pidgin-master.zip && \
cd skype4pidgin-master/skypeweb && \
make && \
make install && \
cd && \

unzip bitlbee-facebook-master.zip && \
cd bitlbee-facebook-master && \
./autogen.sh && \
make && \
make install && \
cd && \  

unzip purple-hangouts.zip && \
mv EionRobb-purple-hangouts-* purple-hangouts && \
cd purple-hangouts && \
make && \
make install && \
cd && \

apt-get autoremove -y --purge autoconf automake gcc libtool make dpkg-dev && \
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /tmp/* && \
cd && \

rm -fr bitlbee-master* && \
rm -fr skype4pidgin* && \
rm -fr bitlbee-facebook* && \
rm -rf purple-hangouts* && \

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
EXPOSE 6667
CMD ["/usr/local/sbin/bitlbee", "-c", "/usr/local/etc/bitlbee/bitlbee.conf", "-n", "-u", "bitlbee"]
