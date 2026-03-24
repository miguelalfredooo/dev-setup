#!/bin/bash
# setup-env.sh - Initialize global environment variables and shell configuration
# Run: bash ~/setup-env.sh (or bash ./setup-env.sh from dev-setup directory)
# This script is part of the dev-setup repo

set -e

echo "🔧 Setting up environment..."

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. Create ~/.env.global from template if it doesn't exist
ENV_FILE="$HOME/.env.global"
TEMPLATE_FILE="$SCRIPT_DIR/env.global.template"

if [ -f "$ENV_FILE" ]; then
    echo "📄 $ENV_FILE already exists, skipping..."
else
    if [ -f "$TEMPLATE_FILE" ]; then
        echo "📝 Copying $TEMPLATE_FILE to $ENV_FILE..."
        cp "$TEMPLATE_FILE" "$ENV_FILE"
        chmod 600 "$ENV_FILE"
        echo "✅ Created $ENV_FILE with mode 600"
    else
        echo "⚠️  Template file not found at $TEMPLATE_FILE"
        echo "📝 Creating $ENV_FILE with placeholder variables..."
        cat > "$ENV_FILE" << 'EOF'
# Global Environment Variables Template
# Fill in your actual values here

# Supabase
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_URL=
SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=

# APIs
ANTHROPIC_API_KEY=
OPENAI_API_KEY=
PEXELS_API_KEY=

# Carrier & Services
CARRIER_API_URL=http://localhost:5001
CREW_API_URL=http://localhost:8000

# Browserbase
BROWSERBASE_API_KEY=
BROWSERBASE_PROJECT_ID=

# Ollama
OLLAMA_BASE_URL=http://localhost:11434
OLLAMA_MODEL=qwen3.5

# App Config
NEXT_PUBLIC_AUTH_REQUIRED=false
CLAUDE_MODEL=claude-haiku-4-5-20251001

# Design Tools
DESIGN_TOOLS_PASSWORD=

# Other
MODEL_API_KEY=
EOF
        chmod 600 "$ENV_FILE"
        echo "✅ Created $ENV_FILE with mode 600"
    fi
fi

# 2. Add sourcing block to ~/.zshrc if not already present
ZSHRC="$HOME/.zshrc"
SOURCE_BLOCK="# Load global environment variables
set -a
source ~/.env.global
set +a"

if grep -q "source ~/.env.global" "$ZSHRC" 2>/dev/null; then
    echo "✅ ~/.zshrc already has global environment sourcing"
else
    echo "📝 Adding sourcing block to ~/.zshrc..."
    {
        echo ""
        echo "$SOURCE_BLOCK"
        echo ""
    } >> "$ZSHRC"
    echo "✅ Added sourcing block to ~/.zshrc"
fi

# 3. Reload shell configuration
echo "🔄 Reloading ~/.zshrc..."
set +e
source "$ZSHRC" 2>/dev/null
set -e

echo ""
echo "✨ Environment setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Edit ~/.env.global and replace placeholder values with real keys"
echo "2. For project-specific overrides, use .env.local (will not be committed)"
echo "3. Verify: echo \${#ANTHROPIC_API_KEY}"
echo "4. Run your dev server"
