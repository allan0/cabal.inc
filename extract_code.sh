#!/bin/bash

# Define the output file
OUTPUT_FILE="project_code_bundle.md"

# Clear the output file if it already exists
echo "# Project Code Bundle - Generated on $(date)" > "$OUTPUT_FILE"
echo "This file contains the core logic and configuration for the Cabal project." >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Function to add files to the bundle
add_files() {
    local pattern=$1
    local description=$2

    echo "Processing $description..."
    echo "## Section: $description" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"

    # Find files matching the pattern, excluding common noise directories
    find . -type f -name "$pattern" \
        -not -path "*/.*" \
        -not -path "./build/*" \
        -not -path "./node_modules/*" \
        -not -path "./smart-contracts/node_modules/*" \
        -not -path "./android/*" \
        -not -path "./ios/*" \
        -not -path "./linux/*" \
        -not -path "./macos/*" \
        -not -path "./windows/*" \
        -not -path "./assets/*" | while read -r file; do
            
            echo "Adding: $file"
            echo "### File: $file" >> "$OUTPUT_FILE"
            echo '```'${file##*.} >> "$OUTPUT_FILE"
            cat "$file" >> "$OUTPUT_FILE"
            echo "" >> "$OUTPUT_FILE"
            echo '```' >> "$OUTPUT_FILE"
            echo "" >> "$OUTPUT_FILE"
    done
}

# 1. Configuration & Project Specs
add_files "pubspec.yaml" "Flutter Config"
add_files "config.env" "Environment Config"
add_files "firebase.json" "Firebase Config"
add_files "README.md" "Project Documentation"

# 2. Smart Contracts (Solidity)
add_files "*.sol" "Solidity Smart Contracts"

# 3. Flutter Logic (Dart)
add_files "*.dart" "Flutter/Dart Logic"

# 4. Supabase / Edge Functions (TypeScript)
add_files "*.ts" "Supabase Functions"

# 5. Web Bridge / JavaScript
add_files "*.js" "Web Bridge Logic"

echo "Done! All relevant code has been bundled into $OUTPUT_FILE"
