#!/bin/bash
source "$(dirname "$0")/lib.sh"
need_root

header "РАЗДЕЛ 6. Сбор артефактов"

# история
history > "$WORKDIR/history.out" 2>/dev/null || cp ~/.bash_history "$WORKDIR/history.out"
log "history.out: $(wc -l < $WORKDIR/history.out) строк"

# stat
{
    echo "=== /home/$USER_NAME ==="
    sudo stat "/home/$USER_NAME"
    echo ""
    echo "=== mycat ==="
    stat "$WORKDIR/mycat"
    echo ""
    echo "=== mychown ==="
    stat "$WORKDIR/mychown"
} > "$WORKDIR/stat.out"

# getcap
{
    echo "=== mychown ==="
    getcap "$WORKDIR/mychown"
    echo ""
    echo "=== mycat ==="
    getcap "$WORKDIR/mycat"
} > "$WORKDIR/getcap.out"

# скриншот
if [ -f "$WORKDIR/mephi-screenshot.png" ]; then
    log "mephi-screenshot.png найден"
else
    warn "mephi-screenshot.png отсутствует"
fi

header "РЕЗУЛЬТАТ РАЗДЕЛА 6"
ls -la "$WORKDIR"/*.out "$WORKDIR"/*.png 2>/dev/null || true
echo ""
find "$ART" -type f | sort