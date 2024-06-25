FROM sonroyaalmerol/steamcmd-arm64:root as build_stage

LABEL maintainer="ponfertato@ya.ru"
LABEL description="A Dockerised version of the Garry's Mod dedicated server for ARM64 (using box86)"

ENV STEAMAPPID 232250
ENV STEAMAPP tf2
ENV STEAMAPPDIR /home/steam/${STEAMAPP}-server
ENV HOMEDIR /home/steam

RUN dpkg --add-architecture amd64 \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
    net-tools \
    lib32gcc-s1:amd64 \
    lib32stdc++6 \
    lib32z1 \
    libcurl3-gnutls:i386 \
    libcurl4-gnutls-dev:i386 \
    libcurl4:i386 \
    libgcc1 \
    libncurses5:i386 \
    libsdl1.2debian \
    libtinfo5 \
    && wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_i386.deb \
    && dpkg -i libssl1.1_1.1.1f-1ubuntu2_i386.deb \
    && rm libssl1.1_1.1.1f-1ubuntu2_i386.deb \
    && rm -rf /var/lib/apt/lists/* 

COPY etc/entry.sh ${HOMEDIR}/entry.sh

WORKDIR ${STEAMAPPDIR}

RUN chmod +x "${HOMEDIR}/entry.sh" \
    && chown -R "${USER}:${USER}" "${HOMEDIR}/entry.sh" "${STEAMAPPDIR}"

FROM build_stage AS bookworm-root

EXPOSE 27015/tcp 27015/udp 27005/udp 27020/udp

ENV TF2_ARGS=""\
    TF2_CLIENTPORT="27005" \
    TF2_IP="" \
    CSS_LAN="0" \
    TF2_MAP="ctf_2fort" \
    TF2_MAXPLAYERS="12" \
    TF2_PORT="27015" \
    TF2_SOURCETVPORT="27020" \
    TF2_TICKRATE=""

USER ${USER}

WORKDIR ${HOMEDIR}

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD netstat -l | grep "27015.*LISTEN"

CMD ["bash", "entry.sh"]