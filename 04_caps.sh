#!/bin/bash
source "$(dirname "$0")/lib.sh"
need_root

header "РАЗДЕЛ 4. Capabilities"

if ! command -v getcap &>/dev/null; then
    sudo dnf install -y libcap
fi

cp /bin/chown "$WORKDIR/mychown"
sudo setcap cap_chown+ep "$WORKDIR/mychown"
log "mychown создан"
getcap "$WORKDIR/mychown"

# смена владельца файла без sudo от user1
TESTFILE="/tmp/testfile_for_caps"
sudo -u "$USER_NAME" touch "$TESTFILE"
info "до:    $(ls -l $TESTFILE | awk '{print $3, $4, $9}')"

sudo -u "$USER_NAME" "$WORKDIR/mychown" root:root "$TESTFILE"
if [ $? -eq 0 ]; then
    log "владелец изменён без sudo"
    info "после: $(ls -l $TESTFILE | awk '{print $3, $4, $9}')"
else
    err "не удалось"
fi

getcap "$WORKDIR/mychown" > "$ART/section4_caps/getcap.out"
stat   "$WORKDIR/mychown" > "$ART/section4_caps/stat_mychown.out"
ls -l  "$TESTFILE"        > "$ART/section4_caps/testfile_after.out" 2>&1