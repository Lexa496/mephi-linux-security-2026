#!/bin/bash
source "$(dirname "$0")/lib.sh"
need_root

header "РАЗДЕЛ 2. Мониторинг файлов и процессов"

# SUID-файлы
sudo find / -perm -4000 -type f 2>/dev/null > "$ART/section2_monitoring/suid_files.out"
SUID_COUNT=$(wc -l < "$ART/section2_monitoring/suid_files.out")
log "SUID-файлов: $SUID_COUNT"

# процессы с eUID=0 и rUID!=0
{
    echo "# снимок $(date)"
    echo "# PID RUID EUID COMMAND"
    ps -eo pid,ruid,euid,comm --no-headers | awk '$2!=0 && $3==0'
    echo ""
    echo "# через /proc"
    for p in /proc/[0-9]*; do
        r=$(awk '/^Uid:/{print $2}' "$p/status" 2>/dev/null)
        e=$(awk '/^Uid:/{print $3}' "$p/status" 2>/dev/null)
        if [ -n "$r" ] && [ "$r" != "0" ] && [ "$e" = "0" ]; then
            echo "$p rUID=$r eUID=$e cmd=$(cat $p/comm 2>/dev/null)"
        fi
    done
} > "$ART/section2_monitoring/priv_procs.out"

PRIV_COUNT=$(grep -c "rUID=" "$ART/section2_monitoring/priv_procs.out" || echo 0)
log "Привилегированных процессов: $PRIV_COUNT"

header "РЕЗУЛЬТАТ РАЗДЕЛА 2"
echo "SUID (первые 10):"
head -10 "$ART/section2_monitoring/suid_files.out"
echo ""
echo "Привилегированные процессы:"
cat "$ART/section2_monitoring/priv_procs.out"