#!/bin/bash
# общие настройки и функции

export G='\033[0;32m'
export R='\033[0;31m'
export Y='\033[1;33m'
export B='\033[0;34m'
export N='\033[0m'

export WORKDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export ART="$WORKDIR/artifacts"

export STUDENT_ID="${STUDENT_ID:-372718}"
export USER_NAME="user1"
export USER_UID=1234
export GROUP_NAME="students"

log()  { echo -e "${G}[+]${N} $1"; }
warn() { echo -e "${Y}[!]${N} $1"; }
err()  { echo -e "${R}[-]${N} $1"; }
info() { echo -e "${B}[i]${N} $1"; }

header() {
    echo ""
    echo -e "${B}───────────────────────────────────────────────${N}"
    echo -e "${B}  $1${N}"
    echo -e "${B}───────────────────────────────────────────────${N}"
}

need_root() {
    if ! sudo -n true 2>/dev/null; then
        sudo -v
    fi
}

show() {
    echo -e "${Y}--- $1 ---${N}"
    shift
    "$@"
    echo ""
}

# ── автосоздание каталогов артефактов ──
mkdir -p "$ART"/{section1_user,section2_monitoring,section3_suid,section4_caps,section5_sudo,system_files}