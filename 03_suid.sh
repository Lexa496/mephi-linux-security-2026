#!/bin/bash
source "$(dirname "$0")/lib.sh"
need_root

header "РАЗДЕЛ 3. set-UID"

cp /bin/cat "$WORKDIR/mycat"
sudo chown root:root "$WORKDIR/mycat"
sudo chmod 4755 "$WORKDIR/mycat"
log "mycat создан"
ls -l "$WORKDIR/mycat"

# попытка прочитать /etc/shadow от user1
sudo -u "$USER_NAME" "$WORKDIR/mycat" /etc/shadow > "$ART/section3_suid/shadow_via_mycat.out" 2>&1
if [ $? -eq 0 ]; then
    log "/etc/shadow прочитан через mycat"
    sudo -u "$USER_NAME" "$WORKDIR/mycat" /etc/shadow | head -3
else
    err "прочитать /etc/shadow не удалось"
    cat "$ART/section3_suid/shadow_via_mycat.out"
fi

stat "$WORKDIR/mycat" > "$ART/section3_suid/stat_mycat.out"