#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# Icons
CHECK="✅"
CROSS="❌"
ARROW="➜"
GEAR="⚙️"
ROCKET="🚀"
PACKAGE="📦"
SPARKLE="✨"

print_banner() {
  echo -e "${CYAN}${BOLD}"
  echo "  ╔═══════════════════════════════════════╗"
  echo "  ║       OpenCode Setup by MejiSec       ║"
  echo "  ║      Powered by femboynet.biz.id      ║"
  echo "  ╚═══════════════════════════════════════╝"
  echo -e "${NC}"
}

print_step() {
  echo -e "\n${BLUE}${BOLD}[ ${1} ]${NC} ${DIM}${2}${NC}"
}

print_ok() {
  echo -e "  ${GREEN}${CHECK} ${1}${NC}"
}

print_warn() {
  echo -e "  ${YELLOW}⚠️  ${1}${NC}"
}

print_info() {
  echo -e "  ${CYAN}${ARROW} ${1}${NC}"
}

print_error() {
  echo -e "  ${RED}${CROSS} ${1}${NC}"
}

spinner() {
  local pid=$1
  local msg=$2
  local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
  local i=0
  while kill -0 $pid 2>/dev/null; do
    i=$(( (i+1) % 10 ))
    printf "\r  ${CYAN}${spin:$i:1}${NC} ${msg}..."
    sleep 0.1
  done
  printf "\r  ${GREEN}${CHECK}${NC} ${msg}   \n"
}

write_config() {
  mkdir -p ~/.config/opencode
  cat > ~/.config/opencode/opencode.json << 'CONF'
{
  "$schema": "https://opencode.ai/config.json",
  "model": "mejisecurity/ds-meji",
  "provider": {
    "mejisecurity": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "MejiSecurity",
      "options": {
        "baseURL": "https://femboynet.biz.id/v1",
        "apiKey": "sk-90f5fdf8274f44f9a4aac061963f128f"
      },
      "models": {
        "mejisecurity": {
          "name": "mejisecurity"
        }
      }
    }
  }
}
CONF
}

# ─────────────────────────────────────────
print_banner
sleep 0.5

# ─── STEP 1: CHECK NVM ───────────────────
print_step "1/4" "Checking NVM"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

if command -v nvm &>/dev/null; then
  NVM_VER=$(nvm --version)
  print_ok "NVM already installed (v${NVM_VER})"
  NVM_INSTALLED=true
else
  print_warn "NVM not found — installing..."
  (curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash) &>/dev/null &
  spinner $! "Installing NVM"

  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

  if command -v nvm &>/dev/null; then
    print_ok "NVM installed successfully"
    NVM_INSTALLED=true
  else
    print_error "NVM installation failed"
    exit 1
  fi
fi

# ─── STEP 2: CHECK NODE 26 ───────────────
print_step "2/4" "Checking Node.js v26"

CURRENT_NODE=$(node --version 2>/dev/null | grep -oP '\d+' | head -1)

if nvm ls 26 2>/dev/null | grep -q "v26"; then
  print_ok "Node.js v26 already installed"
  nvm use 26 --silent &>/dev/null
else
  print_warn "Node.js v26 not found — installing..."
  (nvm install 26) &>/dev/null &
  spinner $! "Installing Node.js v26"
  nvm use 26 --silent &>/dev/null
  print_ok "Node.js v26 ready ($(node --version))"
fi

print_info "Active: Node $(node --version) | npm $(npm --version)"

# ─── STEP 3: CHECK OPENCODE ──────────────
print_step "3/4" "Checking opencode-ai"

if command -v opencode &>/dev/null; then
  OC_VER=$(opencode --version 2>/dev/null || echo "unknown")
  print_ok "opencode-ai already installed (${OC_VER})"
else
  print_warn "opencode-ai not found — installing..."
  (npm install -g opencode-ai) &>/dev/null &
  spinner $! "Installing opencode-ai"

  if command -v opencode &>/dev/null; then
    print_ok "opencode-ai installed successfully"
  else
    print_error "opencode-ai installation failed"
    exit 1
  fi
fi

# ─── STEP 4: WRITE CONFIG ────────────────
print_step "4/4" "Writing MejiSecurity config"

write_config
print_ok "Config written to ~/.config/opencode/opencode.json"
print_info "Model   : mejisecurity/ds-meji"
print_info "BaseURL : https://femboynet.biz.id/v1"

# ─── LAUNCH ──────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}  ${SPARKLE} All set! Launching OpenCode...${NC}"
echo -e "${DIM}  ─────────────────────────────────────────${NC}"
sleep 1

exec opencode
