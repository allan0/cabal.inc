#!/bin/bash

# ================================================
# Cabal Project - Code Collector Script
# Collects all relevant source files into one file
# ================================================

PROJECT_ROOT="$(pwd)"
OUTPUT_FILE="${PROJECT_ROOT}/cabal_all_code.txt"
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')

echo "=== Cabal Project Code Collector ==="
echo "Project root: $PROJECT_ROOT"
echo "Output file: $OUTPUT_FILE"

# Clear or create output file
cat > "$OUTPUT_FILE" << EOF
# ================================================
# CABAL PROJECT - ALL RELEVANT CODE
# Generated on: $(date)
# Total files collected: <COUNT>
# ================================================

EOF

count=0

# Function to append file with separator
append_file() {
    local file="$1"
    if [ -f "$file" ]; then
        echo -e "\n\n# ================================================" >> "$OUTPUT_FILE"
        echo "# FILE: $file" >> "$OUTPUT_FILE"
        echo "# ================================================" >> "$OUTPUT_FILE"
        echo -e "\n" >> "$OUTPUT_FILE"
        cat "$file" >> "$OUTPUT_FILE"
        echo -e "\n# ================================================ END OF $file\n" >> "$OUTPUT_FILE"
        ((count++))
        echo "✓ Added: $file"
    fi
}

# 1. Core config files
echo "Adding configuration files..."
append_file "pubspec.yaml"
append_file "pubspec.lock"
append_file "README.md"
append_file "analysis_options.yaml"
append_file "firebase.json"

# 2. All Dart files (main source)
echo "Adding Dart source files..."
find lib -type f -name "*.dart" -print0 | while IFS= read -r -d '' file; do
    append_file "$file"
done

# 3. Smart Contracts
echo "Adding Solidity smart contracts..."
find smart-contracts -type f -name "*.sol" -print0 | while IFS= read -r -d '' file; do
    append_file "$file"
done

# 4. Other important files
echo "Adding other relevant files..."
append_file "web/index.html"
append_file "web/wallet.js"

# Android/iOS specific if needed
append_file "android/app/build.gradle.kts"
append_file "ios/Runner/Info.plist"

# 5. Supabase functions
find supabase -type f \( -name "*.ts" -o -name "*.toml" -o -name "*.json" \) -print0 | while IFS= read -r -d '' file; do
    append_file "$file"
done

# Final summary
sed -i "s/Total files collected: <COUNT>/Total files collected: $count/" "$OUTPUT_FILE"

echo "=================================================="
echo "✅ Done! Collected $count files."
echo "📁 Output saved to: $OUTPUT_FILE"
echo "=================================================="

# Optional: Show file size
ls -lh "$OUTPUT_FILE"
