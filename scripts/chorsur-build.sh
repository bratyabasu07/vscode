#!/usr/bin/env bash
# CHORSUR - Quick Build Script
# Handles setup + compilation
set -e

echo ""
echo "  ██████╗██╗  ██╗ ██████╗ ██████╗ ███████╗██╗   ██╗██████╗ "
echo " ██╔════╝██║  ██║██╔═══██╗██╔══██╗██╔════╝██║   ██║██╔══██╗"
echo " ██║     ███████║██║   ██║██████╔╝███████╗██║   ██║██████╔╝"
echo " ██║     ██╔══██║██║   ██║██╔══██╗╚════██║██║   ██║██╔══██╗"
echo " ╚██████╗██║  ██║╚██████╔╝██║  ██║███████║╚██████╔╝██║  ██║"
echo "  ╚═════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝"
echo ""
echo "  🔥 The Devil's Code Editor 🔥"
echo "  Built by ElliotJr"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$ROOT_DIR"

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is required (v20+). Install from https://nodejs.org"
    exit 1
fi

NODE_VER=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VER" -lt 20 ]; then
    echo "❌ Node.js v20+ required. You have v$NODE_VER"
    exit 1
fi
echo "✅ Node.js $(node -v)"

# Check Python
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is required."
    exit 1
fi
echo "✅ Python $(python3 --version | cut -d' ' -f2)"

# Check yarn
if ! command -v yarn &> /dev/null; then
    echo "📦 Installing yarn..."
    npm install -g yarn
fi
echo "✅ Yarn $(yarn --version)"

# Install dependencies
echo ""
echo "📦 Installing dependencies..."
yarn

# Setup icons if source exists
if [ -f "$ROOT_DIR/resources/chorsur/chorsur-icon.png" ]; then
    echo ""
    echo "🎨 Setting up CHORSUR icons..."
    bash "$SCRIPT_DIR/chorsur-setup-icons.sh"
fi

# Compile
echo ""
echo "⚡ Compiling CHORSUR..."
yarn compile

echo ""
echo "🔥 CHORSUR build complete!"
echo "   Run with: ./scripts/code.sh"
