mkdir -p ~/.config/opencode
cat > ~/.config/opencode/opencode.json << 'EOF'
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
          "name": "devops"
        }
      }
    }
  }
}
EOF
