#!/usr/bin/env bash
# CHORSUR Icon Setup Script
# Run this after cloning to generate and place all icon assets
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
ICON_SRC="$ROOT_DIR/resources/chorsur/chorsur-icon.png"

echo "🔥 CHORSUR Icon Setup"
echo "===================="

if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is required. Install it first."
    exit 1
fi

if ! python3 -c "from PIL import Image" 2>/dev/null; then
    echo "📦 Installing Pillow..."
    pip3 install Pillow
fi

if [ ! -f "$ICON_SRC" ]; then
    echo "❌ Source icon not found at: $ICON_SRC"
    echo "   Place your CHORSUR icon PNG at that path and retry."
    exit 1
fi

echo "📐 Generating icon sizes..."

python3 << 'PYEOF'
import os, sys
from PIL import Image

root = os.environ.get('ROOT_DIR', '.')
src = os.path.join(root, 'resources', 'chorsur', 'chorsur-icon.png')
img = Image.open(src).convert('RGBA')

# Linux icons
linux_dir = os.path.join(root, 'resources', 'linux')
for size in [16, 24, 32, 48, 64, 128, 192, 256, 512]:
    out = os.path.join(linux_dir, f'chorsur_{size}x{size}.png')
    img.resize((size, size), Image.LANCZOS).save(out)
    print(f'  ✅ Linux: {size}x{size}')

# Main Linux icon
img.resize((256, 256), Image.LANCZOS).save(os.path.join(linux_dir, 'chorsur.png'))
print('  ✅ Linux: chorsur.png (256x256)')

# macOS icon (just the 1024 PNG, .icns generation needs iconutil on macOS)
darwin_dir = os.path.join(root, 'resources', 'darwin')
img.resize((1024, 1024), Image.LANCZOS).save(os.path.join(darwin_dir, 'chorsur.png'))
print('  ✅ macOS: chorsur.png (1024x1024)')

# Win32 - generate .ico with multiple sizes
win32_dir = os.path.join(root, 'resources', 'win32')
ico_sizes = [(16,16), (24,24), (32,32), (48,48), (64,64), (128,128), (256,256)]
ico_images = [img.resize(s, Image.LANCZOS) for s in ico_sizes]
ico_images[0].save(
    os.path.join(win32_dir, 'chorsur.ico'),
    format='ICO',
    sizes=ico_sizes,
    append_images=ico_images[1:]
)
print('  ✅ Win32: chorsur.ico (multi-size)')

print('\n🔥 All icons generated successfully!')
PYEOF

echo ""
echo "✅ Icon setup complete!"
echo "   You can now build CHORSUR with: yarn && yarn compile"
