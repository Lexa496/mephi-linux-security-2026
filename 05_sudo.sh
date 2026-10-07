#!/bin/bash
source "$(dirname "$0")/lib.sh"
need_root

header "РАЗДЕЛ 5. sudo"

SUDO_LINE="$USER_NAME ALL=(root) /usr/bin/date, /bin/date, /usr/bin/timedatectl"
SUDO_FILE="/etc/sudoers.d/$USER_NAME"

if sudo test -f "$SUDO_FILE"; then
    warn "правило уже есть: $SUDO_FILE"
else
    echo "$SUDO_LINE" | sudo tee "$SUDO_FILE" >/dev/null
    sudo chmod 440 "$SUDO_FILE"
    log "создано: $SUDO_FILE"
fi

sudo visudo -cf "$SUDO_FILE" && log "синтаксис OK"

# попытка сменить дату от user1
DATE_BIN=$(command -v date)
sudo -u "$USER_NAME" sudo "$DATE_BIN" 2>&1 || true
sudo -u "$USER_NAME" sudo -S "$DATE_BIN" -s "2026-01-01 12:00:00" 2>&1 \
    | tee "$ART/section5_sudo/sudo_date_test.out" || true

sudo cp "$SUDO_FILE" "$ART/section5_sudo/sudoers_user1.out"
sudo cp /etc/sudoers "$ART/system_files/sudoers.out"
sudo chown "$USER:$USER" "$ART/system_files/sudoers.out"