#!/bin/bash

# Fix Build Script for NeurospLIT
# This script creates symlinks to files where Xcode expects them

echo "🔧 Fixing NeurospLIT Build Structure..."
echo "===================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Create symlinks in NeurospLIT folder for files Xcode expects
echo ""
echo "📁 Creating file links for Xcode..."

# These files are expected in NeurospLIT/ folder by the project
declare -a files=(
    "ContentView.swift:App/ContentView.swift"
    "ClaudeService.swift:NeurospLIT/Services/API/ClaudeService.swift"
    "ClaudeOnboardingView.swift:NeurospLIT/Views/Onboarding/ClaudeOnboardingView.swift"
    "TemplateUtilities.swift:NeurospLIT/Utilities/Helpers/TemplateUtilities.swift"
    "EngineHarness.swift:NeurospLIT/Engine/EngineHarness.swift"
    "Persistence.swift:NeurospLIT/Services/Storage/Persistence.swift"
    "MockURLProtocol.swift:NeurospLITTests/Mocks/MockURLProtocol.swift"
    "Dummy.swift:App/Dummy.swift"
)

# Ensure NeurospLIT directory exists
mkdir -p NeurospLIT

# Create symlinks
for file_mapping in "${files[@]}"; do
    IFS=':' read -r dest src <<< "$file_mapping"
    
    # Remove existing symlink if it exists
    if [ -L "NeurospLIT/$dest" ]; then
        rm "NeurospLIT/$dest"
    fi
    
    # Check if source file exists
    if [ -f "$src" ]; then
        # On macOS, create symlink
        if [[ "$OSTYPE" == "darwin"* ]]; then
            ln -s "../$src" "NeurospLIT/$dest"
            echo -e "${GREEN}✅ Linked: $dest → $src${NC}"
        else
            # On other systems, copy the file
            cp "$src" "NeurospLIT/$dest"
            echo -e "${GREEN}✅ Copied: $dest ← $src${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  Source not found: $src${NC}"
        # Create a placeholder file
        echo "// Placeholder for $dest" > "NeurospLIT/$dest"
        echo "import Foundation" >> "NeurospLIT/$dest"
        echo "" >> "NeurospLIT/$dest"
        echo "// Original file should be at: $src" >> "NeurospLIT/$dest"
    fi
done

# Verify critical files exist
echo ""
echo "🔍 Verifying critical files..."

critical_files=(
    "NeurospLIT/Application/NeurospLITApp.swift"
    "NeurospLIT/Models/Domain/Models.swift"
    "NeurospLIT/Models/Supporting/Errors.swift"
    "NeurospLIT/Engine/Engine.swift"
    "Configs/Secrets.xcconfig"
)

all_good=true
for file in "${critical_files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✅ Found: $file${NC}"
    else
        echo -e "${RED}❌ Missing: $file${NC}"
        all_good=false
    fi
done

echo ""
if [ "$all_good" = true ]; then
    echo -e "${GREEN}✅ Build structure fixed!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Open NeurospLIT.xcodeproj in Xcode"
    echo "2. Clean build folder (⌘⇧K)"
    echo "3. Build (⌘B)"
else
    echo -e "${YELLOW}⚠️  Some files are missing. You may need to fix file references in Xcode.${NC}"
fi

echo ""
echo "To open in Xcode:"
echo "  open NeurospLIT.xcodeproj"
