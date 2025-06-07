#!/bin/bash
echo "🔧 Setting up automated linting for NeuroVis project..."
echo "=================================================="

# Install pre-commit if not already installed
if ! command -v pre-commit &> /dev/null; then
    echo "📦 Installing pre-commit..."
    pip3 install pre-commit
fi

# Install Python linting tools
echo "🐍 Installing Python linting tools..."
pip3 install black flake8 pylint

# Install markdownlint if not already installed
if ! command -v markdownlint &> /dev/null; then
    echo "📝 Installing markdownlint..."
    npm install -g markdownlint-cli
fi

# Install pre-commit hooks
echo "🪝 Installing pre-commit hooks..."
pre-commit install

# Run initial check on all files
echo "🔍 Running initial lint check..."
echo ""
echo "Shell scripts:"
find . -name "*.sh" -not -path "./.git/*" | head -5 | xargs -I {} sh -c 'echo "Checking: {}"; shellcheck {}'

echo ""
echo "Python files:"
find . -name "*.py" -not -path "./.git/*" | head -3 | xargs -I {} sh -c 'echo "Checking: {}"; flake8 {} || true'

echo ""
echo "✅ Linting setup complete!"
echo ""
echo "🚀 Usage:"
echo "  - Linting runs automatically on git commit"
echo "  - Manual check: 'pre-commit run --all-files'"
echo "  - Single file: 'shellcheck filename.sh'"
echo "  - Fix shell issues: Edit file based on shellcheck suggestions"
