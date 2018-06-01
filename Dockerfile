FROM alpine:latest

ENV BITLBEE_COMMIT 49ab3cb
ENV PURPLE_HANGOUTS_COMMIT 9d008f2
ENV TELEGRAM_COMMIT f38ea48
ENV FACEBOOK_COMMIT 553593d
ENV DYLEX_SLACK_COMMIT a803b73
ENV EIONROBB_DISCORD_COMMIT b895521
ENV EIONROBB_ROCKETCHAT_COMMIT fb8dcc6
ENV EIONROBB_MATTERMOST_COMMIT bc02343
ENV EIONROBB_MATRIX_COMMIT 148a207
ENV MATRIX_PURPLE_COMMIT 49ea988
#ENV SMOOTH_DISCORD_COMMIT 54c06e6

RUN set -x \
    && apk update \
    && apk upgrade \
    && apk add --virtual build-dependencies \
        autoconf \
        automake \
        build-base \
        curl \
        git \
        json-glib-dev \
        libtool \
        mercurial \
    && apk add --virtual runtime-dependencies \
        discount \
        discount-dev \
        discount-libs \
        glib-dev \
        gnutls-dev \
        http-parser-dev \
        json-glib \
        json-glib-dev \
        libgcrypt-dev \
        libotr \
        libpurple \
        libwebp-dev \
        pidgin-dev \
	protobuf-c-dev \
    && cd /root \
    && git clone -n https://github.com/bitlbee/bitlbee \
    && cd bitlbee \
    && git checkout ${BITLBEE_COMMIT} \
    && mkdir /bitlbee-data \
    && ./configure --purple=1 --otr=0 --config=/bitlbee-data \
    && make \
    && make install \
    && make install-dev \
    && make install-etc \
    && cd /root \
    && rm -rf bitlbee \
    && cd /root \
    && hg clone https://bitbucket.org/EionRobb/purple-hangouts \
    && cd purple-hangouts \
    && hg update ${PURPLE_HANGOUTS_COMMIT} \
    && make \
    && make install \
    && cd /root \
    && rm -rf purple-hangouts \
    && cd /root \
    && git clone -n https://github.com/majn/telegram-purple \
    && cd telegram-purple \
    && git checkout ${TELEGRAM_COMMIT} \
    && ./configure \
    && git submodule update --init --recursive \
    && make \
    && make install \
    && cd /root \
    && rm -rf telegram-purple \
    && cd /root \
    && git clone -n https://github.com/bitlbee/bitlbee-facebook.git \
    && cd bitlbee-facebook \
    && git checkout ${FACEBOOK_COMMIT} \
    && ./autogen.sh \
    && make \
    && make install \
    && cd /root \
    && rm -rf bitlbee-facebook \
    && cd /root \
    && git clone -n https://github.com/dylex/slack-libpurple \
    && cd slack-libpurple \
    && git checkout ${DYLEX_SLACK_COMMIT} \
    && mkdir -p /usr/share/pixmaps/pidgin/protocols/16/ \
    && mkdir -p /usr/share/pixmaps/pidgin/protocols/22/ \
    && mkdir -p /usr/share/pixmaps/pidgin/protocols/48/ \
    && make \
    && make install \
    && cd /root \
    && rm -rf slack-libpurple \
    && cd /root \
    && hg clone https://bitbucket.org/EionRobb/purple-rocketchat \
    && cd purple-rocketchat \
    && hg update ${EIONROBB_ROCKETCHAT_COMMIT} \
    && make \
    && make install \
    && cd /root \
    && rm -rf purple-rocketchat \
    && cd /root \
    && git clone -n https://github.com/EionRobb/purple-matrix \
    && cd purple-matrix \
    && git checkout ${EIONROBB_MATRIX_COMMIT} \
    && make \
    && make install \
    && cd /root \
    && rm -rf purple-matrix \
    && cd /root \
    && git clone -n https://github.com/matrix-org/purple-matrix \
    && cd purple-matrix \
    && git checkout ${MATRIX_PURPLE_COMMIT} \
    && make \
    && make install \
    && cd /root \
    && rm -rf purple-matrix \
    && cd /root \
    && git clone -n https://github.com/EionRobb/purple-discord \
    && cd purple-discord \
    && git checkout ${EIONROBB_DISCORD_COMMIT} \
    && make \
    && make install \
    && cd /root \
    && rm -rf purple-discord \
#    && cd /root \
#    && git clone -n https://github.com/sm00th/bitlbee-discord \
#    && cd bitlbee-discord \
#    && git checkout ${SMOOTH_DISCORD_COMMIT} \
#    && ./autogen.sh \
#    && ./configure \
#    && make \
#    && make install \
#    && cd /root \
#    && rm -rf bitlbee-discord \
    && cd /root \
    && git clone -n https://github.com/EionRobb/purple-mattermost \
    && cd purple-mattermost \
    && git checkout ${EIONROBB_MATTERMOST_COMMIT} \
    && make \
    && make install \
    && cd /root \
    && rm -rf purple-mattermost \
    && cd /root \
    && apk del --purge build-dependencies \
    && rm -rf /root/* \
    && rm -rf /var/cache/apk/* \
    && adduser -u 1000 -S bitlbee \
    && addgroup -g 1000 -S bitlbee \
    && chown -R bitlbee:bitlbee /bitlbee-data \
    && touch /var/run/bitlbee.pid \
    && chown bitlbee:bitlbee /var/run/bitlbee.pid; exit 0

USER bitlbee
VOLUME /bitlbee-data
ENTRYPOINT ["/usr/local/sbin/bitlbee", "-F", "-n", "-d", "/bitlbee-data"]
