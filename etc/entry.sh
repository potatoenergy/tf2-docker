#!/bin/bash

# Create steam app directory
mkdir -p "${STEAMAPPDIR}" || true

# Download updates
bash "${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "${STEAMAPPDIR}" \
    +login "anonymous" \
    +app_update "${STEAMAPPID}" \
    +quit

# Switch to server directory
cd "${STEAMAPPDIR}"

# Check architecture
if [ "$(uname -m)" = "aarch64" ]; then
    # ARM64 architecture
	# create an arm64 version of srcds_run
	cp ./srcds_run ./srcds_run-arm64
    SRCDS_RUN="srcds_run-arm64"
    sed -i 's/$HL_CMD/box86 $HL_CMD/g' "$SRCDS_RUN"
    chmod +x "$SRCDS_RUN"
else
    # Other architectures
    SRCDS_RUN="srcds_run"
fi

# Start server
"./$SRCDS_RUN" -game tf \
	"${TF2_ARGS}" \
    +clientport "${TF2_CLIENTPORT}" \
    +map "${TF2_MAP}" \
    +sv_lan "${TF2_LAN}" \
    +tv_port "${TF2_SOURCETVPORT}" \
    -autoupdate \
    -console \
    -ip "${TF2_IP}" \
    -master \
    -maxplayers "${TF2_MAXPLAYERS}" \
    -port "${TF2_PORT}" \
    -steam_dir "${HOMEDIR}/Steam" \
    -steamcmd_script "${STEAMCMDDIR}" \
    -strictportbind \
    -tickrate "${TF2_TICKRATE}" \
    -usercon