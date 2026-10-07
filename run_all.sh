#!/bin/bash
# запуск всех этапов по порядку
set -e
cd "$(dirname "$0")"

REQUIRED=(lib.sh 01_user.sh 02_monitoring.sh 03_suid.sh 04_caps.sh 05_sudo.sh 06_artifacts.sh)
MISSING=()
for f in "${REQUIRED[@]}"; do
    [ -f "$f" ] || MISSING+=("$f")
done

if [ ${#MISSING[@]} -gt 0 ]; then
    echo "не хватает:"
    printf '    %s\n' "${MISSING[@]}"
    exit 1
fi

chmod +x lib.sh 01_user.sh 02_monitoring.sh 03_suid.sh 04_caps.sh 05_sudo.sh 06_artifacts.sh

for script in 01_user.sh 02_monitoring.sh 03_suid.sh 04_caps.sh 05_sudo.sh 06_artifacts.sh; do
    echo ""
    echo -e "\033[1;33m>>> $script\033[0m"
    ./"$script" || { echo -e "\033[0;31mошибка в $script\033[0m"; exit 1; }
done

echo ""
echo -e "\033[0;32mвсе этапы выполнены\033[0m"
ls -la "$PWD"/*.out "$PWD"/mephi-screenshot.png 2>/dev/null || true