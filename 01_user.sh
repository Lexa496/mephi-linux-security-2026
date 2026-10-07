#!/bin/bash
source "$(dirname "$0")/lib.sh"
need_root

header "РАЗДЕЛ 1. Создание пользователя $USER_NAME"

# группа
if getent group "$GROUP_NAME" >/dev/null; then
    warn "Группа $GROUP_NAME уже есть"
else
    sudo groupadd "$GROUP_NAME"
    log "Группа $GROUP_NAME создана"
fi

# пользователь
if id "$USER_NAME" &>/dev/null; then
    warn "Пользователь $USER_NAME уже есть"
else
    sudo useradd -u "$USER_UID" -g "$GROUP_NAME" -m -s /bin/bash "$USER_NAME"
    log "Пользователь $USER_NAME создан"
    sudo passwd "$USER_NAME"
fi

# пароль на 90 дней
sudo chage -M 90 "$USER_NAME"

# артефакты
id "$USER_NAME"                        > "$ART/section1_user/id.out"
sudo chage -l "$USER_NAME"             > "$ART/section1_user/chage.out"
getent passwd "$USER_NAME"             > "$ART/section1_user/passwd_entry.out"
getent group "$GROUP_NAME"             > "$ART/section1_user/group_entry.out"
sudo cp /etc/passwd "$ART/system_files/passwd.out"
sudo cp /etc/shadow "$ART/system_files/shadow.out"
sudo cp /etc/group  "$ART/system_files/group.out"
sudo chown "$USER:$USER" "$ART/system_files/shadow.out"

header "РЕЗУЛЬТАТ РАЗДЕЛА 1"
show "id $USER_NAME"       id "$USER_NAME"
show "chage -l $USER_NAME" sudo chage -l "$USER_NAME"
ls -la "$ART/section1_user/"