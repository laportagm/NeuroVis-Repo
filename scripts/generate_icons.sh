#!/bin/bash
# NeuroVis Icon Generation Script
# Creates all required icon formats from a single source image

set -e

echo "🎨 NeuroVis Icon Generator"
echo "=========================="
echo ""

# Check for ImageMagick
if ! command -v convert &> /dev/null; then
    echo "❌ Error: ImageMagick is required but not installed."
    echo "Install with: brew install imagemagick (macOS) or apt-get install imagemagick (Linux)"
    exit 1
fi

# Check for source icon
SOURCE_ICON="assets/icons/neurovis_icon_1024.png"
if [ ! -f "$SOURCE_ICON" ]; then
    echo "❌ Error: Source icon not found at $SOURCE_ICON"
    echo "Please create a 1024x1024 PNG icon first."
    exit 1
fi

# Create icons directory
mkdir -p assets/icons/windows
mkdir -p assets/icons/macos
mkdir -p assets/icons/linux
mkdir -p assets/icons/web

echo "📱 Generating icons from $SOURCE_ICON..."

# Windows ICO (multiple sizes in one file)
echo "→ Creating Windows ICO..."
convert "$SOURCE_ICON" \
    \( -clone 0 -resize 16x16 \) \
    \( -clone 0 -resize 32x32 \) \
    \( -clone 0 -resize 48x48 \) \
    \( -clone 0 -resize 64x64 \) \
    \( -clone 0 -resize 128x128 \) \
    \( -clone 0 -resize 256x256 \) \
    -delete 0 \
    assets/icons/windows/neurovis.ico

# macOS ICNS
echo "→ Creating macOS ICNS..."
# Create iconset directory
ICONSET="assets/icons/macos/NeuroVis.iconset"
mkdir -p "$ICONSET"

# Generate all required sizes for macOS
convert "$SOURCE_ICON" -resize 16x16     "$ICONSET/icon_16x16.png"
convert "$SOURCE_ICON" -resize 32x32     "$ICONSET/icon_16x16@2x.png"
convert "$SOURCE_ICON" -resize 32x32     "$ICONSET/icon_32x32.png"
convert "$SOURCE_ICON" -resize 64x64     "$ICONSET/icon_32x32@2x.png"
convert "$SOURCE_ICON" -resize 128x128   "$ICONSET/icon_128x128.png"
convert "$SOURCE_ICON" -resize 256x256   "$ICONSET/icon_128x128@2x.png"
convert "$SOURCE_ICON" -resize 256x256   "$ICONSET/icon_256x256.png"
convert "$SOURCE_ICON" -resize 512x512   "$ICONSET/icon_256x256@2x.png"
convert "$SOURCE_ICON" -resize 512x512   "$ICONSET/icon_512x512.png"
convert "$SOURCE_ICON" -resize 1024x1024 "$ICONSET/icon_512x512@2x.png"

# Convert to ICNS (macOS only)
if [[ "$OSTYPE" == "darwin"* ]]; then
    iconutil -c icns "$ICONSET" -o assets/icons/macos/NeuroVis.icns
    rm -rf "$ICONSET"
else
    echo "⚠️  Skipping ICNS creation (requires macOS)"
fi

# Linux PNG icons
echo "→ Creating Linux PNG icons..."
for size in 16 24 32 48 64 128 256 512; do
    convert "$SOURCE_ICON" -resize ${size}x${size} \
        "assets/icons/linux/neurovis_${size}x${size}.png"
done

# Web favicons
echo "→ Creating web favicons..."
convert "$SOURCE_ICON" -resize 16x16   assets/icons/web/favicon-16x16.png
convert "$SOURCE_ICON" -resize 32x32   assets/icons/web/favicon-32x32.png
convert "$SOURCE_ICON" -resize 180x180 assets/icons/web/apple-touch-icon.png
convert "$SOURCE_ICON" -resize 192x192 assets/icons/web/android-chrome-192x192.png
convert "$SOURCE_ICON" -resize 512x512 assets/icons/web/android-chrome-512x512.png

# Create favicon.ico with multiple sizes
convert "$SOURCE_ICON" \
    \( -clone 0 -resize 16x16 \) \
    \( -clone 0 -resize 32x32 \) \
    \( -clone 0 -resize 48x48 \) \
    -delete 0 \
    assets/icons/web/favicon.ico

# Generate web manifest
cat > assets/icons/web/site.webmanifest << EOF
{
    "name": "NeuroVis",
    "short_name": "NeuroVis",
    "icons": [
        {
            "src": "/android-chrome-192x192.png",
            "sizes": "192x192",
            "type": "image/png"
        },
        {
            "src": "/android-chrome-512x512.png",
            "sizes": "512x512",
            "type": "image/png"
        }
    ],
    "theme_color": "#00D9FF",
    "background_color": "#0A0A0F",
    "display": "standalone"
}
EOF

# Copy main icons to project root
cp assets/icons/windows/neurovis.ico icon.ico
cp assets/icons/macos/NeuroVis.icns icon.icns 2>/dev/null || true
cp assets/icons/linux/neurovis_256x256.png icon.png

echo ""
echo "✅ Icon generation complete!"
echo ""
echo "Generated icons:"
echo "  • Windows: assets/icons/windows/neurovis.ico"
echo "  • macOS: assets/icons/macos/NeuroVis.icns"
echo "  • Linux: assets/icons/linux/neurovis_*.png"
echo "  • Web: assets/icons/web/*"
echo ""
echo "Main project icons copied to:"
echo "  • icon.ico (Windows)"
echo "  • icon.icns (macOS)"
echo "  • icon.png (Linux)"
