# Fix Build Script for NeurospLIT (Windows PowerShell)
# This script copies files to where Xcode expects them

Write-Host "🔧 Fixing NeurospLIT Build Structure..." -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# File mappings (destination in NeurospLIT : source location)
$fileMappings = @(
    @{Dest="ContentView.swift"; Src="App/ContentView.swift"},
    @{Dest="ClaudeService.swift"; Src="NeurospLIT/Services/API/ClaudeService.swift"},
    @{Dest="ClaudeOnboardingView.swift"; Src="NeurospLIT/Views/Onboarding/ClaudeOnboardingView.swift"},
    @{Dest="TemplateUtilities.swift"; Src="NeurospLIT/Utilities/Helpers/TemplateUtilities.swift"},
    @{Dest="EngineHarness.swift"; Src="NeurospLIT/Engine/EngineHarness.swift"},
    @{Dest="Persistence.swift"; Src="NeurospLIT/Services/Storage/Persistence.swift"},
    @{Dest="MockURLProtocol.swift"; Src="NeurospLITTests/Mocks/MockURLProtocol.swift"},
    @{Dest="Dummy.swift"; Src="App/Dummy.swift"}
)

# Ensure NeurospLIT directory exists
if (!(Test-Path "NeurospLIT")) {
    New-Item -ItemType Directory -Path "NeurospLIT" -Force | Out-Null
}

Write-Host "📁 Copying files for Xcode..." -ForegroundColor Green
Write-Host ""

foreach ($mapping in $fileMappings) {
    $destPath = "NeurospLIT\$($mapping.Dest)"
    $srcPath = $mapping.Src
    
    if (Test-Path $srcPath) {
        Copy-Item -Path $srcPath -Destination $destPath -Force
        Write-Host "✅ Copied: $($mapping.Dest) ← $srcPath" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Source not found: $srcPath" -ForegroundColor Yellow
        # Create placeholder
        $placeholder = @"
// Placeholder for $($mapping.Dest)
import Foundation

// Original file should be at: $srcPath
"@
        Set-Content -Path $destPath -Value $placeholder
    }
}

# Verify critical files
Write-Host ""
Write-Host "🔍 Verifying critical files..." -ForegroundColor Cyan

$criticalFiles = @(
    "NeurospLIT\Application\NeurospLITApp.swift",
    "NeurospLIT\Models\Domain\Models.swift",
    "NeurospLIT\Models\Supporting\Errors.swift",
    "NeurospLIT\Engine\Engine.swift",
    "Configs\Secrets.xcconfig"
)

$allGood = $true
foreach ($file in $criticalFiles) {
    if (Test-Path $file) {
        Write-Host "✅ Found: $file" -ForegroundColor Green
    } else {
        Write-Host "❌ Missing: $file" -ForegroundColor Red
        $allGood = $false
    }
}

Write-Host ""
if ($allGood) {
    Write-Host "✅ Build structure fixed!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "1. Transfer project to Mac"
    Write-Host "2. Open NeurospLIT.xcodeproj in Xcode"
    Write-Host "3. Clean build folder (Cmd+Shift+K)"
    Write-Host "4. Build (Cmd+B)"
} else {
    Write-Host "⚠️  Some files are missing. You may need to fix file references in Xcode." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Commit and push these fixes:" -ForegroundColor Yellow
Write-Host "  git add ." -ForegroundColor White
$msg = 'git commit -m "fix: Add missing files for Xcode build"'
Write-Host "  $msg" -ForegroundColor White
Write-Host "  git push origin main" -ForegroundColor White
