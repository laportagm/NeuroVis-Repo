#!/bin/bash
echo "🔧 Fixing Shell Script Linting Issues..."
echo "======================================"

# Install missing Python tools first
echo "📦 Installing missing Python linting tools..."
pip3 install flake8 black pylint

echo ""
echo "🛠️  Fixing shell script issues..."

# Fix install-hooks.sh
echo "Fixing tools/git-hooks/install-hooks.sh..."
sed -i '' 's/print_status \$RED "/print_status "$RED" "/g' tools/git-hooks/install-hooks.sh
sed -i '' 's/print_status \$GREEN "/print_status "$GREEN" "/g' tools/git-hooks/install-hooks.sh
sed -i '' 's/print_status \$YELLOW "/print_status "$YELLOW" "/g' tools/git-hooks/install-hooks.sh

# Fix test-runner.sh
echo "Fixing tools/quality/test-runner.sh..."
sed -i '' 's/print_status \$RED "/print_status "$RED" "/g' tools/quality/test-runner.sh
sed -i '' 's/print_status \$GREEN "/print_status "$GREEN" "/g' tools/quality/test-runner.sh
sed -i '' 's/print_status \$YELLOW "/print_status "$YELLOW" "/g' tools/quality/test-runner.sh
sed -i '' 's/print_status \$BLUE "/print_status "$BLUE" "/g' tools/quality/test-runner.sh

# Remove unused variables
echo "Removing unused variables..."
sed -i '' '/^TOOLS_DIR="/d' tools/quality/test-runner.sh
sed -i '' '/^GENERATE_COVERAGE=true$/d' tools/quality/test-runner.sh

echo ""
echo "✅ Fixed shell script issues!"
echo ""
echo "📋 Changes made:"
echo "  • Quoted all color variables in print_status calls"
echo "  • Removed unused TOOLS_DIR variable"
echo "  • Removed unused GENERATE_COVERAGE assignment"
echo "  • Installed flake8, black, pylint for Python"
echo ""
echo "🧪 Test the fixes:"
echo "  shellcheck tools/git-hooks/install-hooks.sh"
echo "  shellcheck tools/quality/test-runner.sh"
echo "  flake8 fix_panel_loading.py"
