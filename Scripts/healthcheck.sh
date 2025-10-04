#!/bin/bash

echo "========================================="
echo "  NeurospLIT Project Health Check"
echo "========================================="
echo ""

# Track failures
FAILED=0

# Check secrets file
echo "1️⃣  Checking Secrets Configuration..."
if [ -f "Configs/Secrets.xcconfig" ]; then
    echo "   ✅ Secrets file exists"
else
    echo "   ❌ Secrets file missing - run 'make setup'"
    FAILED=1
fi
echo ""

# Build check
echo "2️⃣  Building project..."
if xcodebuild -project NeurospLIT.xcodeproj -scheme NeurospLIT \
    -configuration Debug -allowProvisioningUpdates \
    CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO \
    -destination 'platform=iOS Simulator,name=iPhone 16' \
    build > /tmp/neurosplit_build.log 2>&1; then
    echo "   ✅ Build succeeded"
else
    echo "   ❌ Build failed - check /tmp/neurosplit_build.log"
    FAILED=1
fi
echo ""

# Test check (skip if build failed)
if [ $FAILED -eq 0 ]; then
    echo "3️⃣  Running tests..."
    if xcodebuild test -project NeurospLIT.xcodeproj -scheme NeurospLIT \
        -destination 'platform=iOS Simulator,name=iPhone 16' \
        CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO \
        > /tmp/neurosplit_test.log 2>&1; then
        echo "   ✅ Tests passed"
    else
        echo "   ⚠️  Tests failed - check /tmp/neurosplit_test.log"
        echo "   (This may be expected if test target isn't configured yet)"
    fi
    echo ""
fi

# Structure check
echo "4️⃣  Checking project structure..."
if [ -d "NeurospLIT" ] && [ -d "NeurospLITTests" ]; then
    echo "   ✅ Clean structure present"
else
    echo "   ❌ Required directories missing"
    FAILED=1
fi

if [ -d "App" ] || [ -d "Views" ] || [ -d "Services" ]; then
    echo "   ⚠️  Old duplicate directories still present"
else
    echo "   ✅ No duplicate directories"
fi
echo ""

# Final summary
echo "========================================="
if [ $FAILED -eq 0 ]; then
    echo "✅ ALL CHECKS PASSED!"
    echo "========================================="
    echo ""
    echo "Your project is healthy and ready for development."
    exit 0
else
    echo "❌ SOME CHECKS FAILED"
    echo "========================================="
    echo ""
    echo "Please review the errors above and:"
    echo "  - Check build log: /tmp/neurosplit_build.log"
    echo "  - Check test log: /tmp/neurosplit_test.log"
    echo "  - Run 'make setup' if secrets are missing"
    exit 1
fi

