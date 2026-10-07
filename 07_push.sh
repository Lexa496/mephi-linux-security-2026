#!/bin/bash
source "$(dirname "$0")/lib.sh"

GITHUB_USER="${GITHUB_USER:-Lexa496}"
REPO="mephi-linux-security-2026"

header "РАЗДЕЛ 7. Публикация на GitHub"

cd "$WORKDIR"

if [ ! -f mephi-screenshot.png ]; then
    err "нет mephi-screenshot.png"
    exit 1
fi

cat > .gitignore <<'EOF'
*.swp
*.bak
*.tmp
__pycache__/
EOF

[ -d .git ] || { git init; git branch -M main; }

git add .
git commit -m "MEPHI homework 2026" || warn "нечего коммитить"

if git remote | grep -q origin; then
    git remote set-url origin "https://github.com/$GITHUB_USER/$REPO.git"
else
    git remote add origin "https://github.com/$GITHUB_USER/$REPO.git"
fi

info "push → https://github.com/$GITHUB_USER/$REPO"
git push -u origin main