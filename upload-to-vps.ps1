# Upload fixed files to VPS from Windows
# Run this from PowerShell in the backend directory

$VPS_IP = "149.50.132.34"
$VPS_USER = "root"
$VPS_PATH = "~/gb-constructora-backend"

Write-Host "📤 Uploading fixed files to VPS..." -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Target: $VPS_USER@$VPS_IP`:$VPS_PATH"
Write-Host ""

# Check if files exist
$Files = @("Dockerfile.backend", "docker-compose.yml", ".dockerignore", "quick-fix.sh")
$AllFilesExist = $true

foreach ($file in $Files) {
    if (-not (Test-Path $file)) {
        Write-Host "❌ Error: $file not found" -ForegroundColor Red
        $AllFilesExist = $false
    }
}

if (-not $AllFilesExist) {
    Write-Host ""
    Write-Host "Please run this script from the backend directory" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ All files found locally" -ForegroundColor Green
Write-Host ""

# Check if scp is available
$ScpExists = Get-Command scp -ErrorAction SilentlyContinue
if (-not $ScpExists) {
    Write-Host "❌ Error: scp command not found" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install OpenSSH client:" -ForegroundColor Yellow
    Write-Host "  Settings > Apps > Optional Features > Add OpenSSH Client" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Or use WinSCP or another SFTP client to upload files manually" -ForegroundColor Yellow
    exit 1
}

# Upload files
Write-Host "📤 Uploading files..." -ForegroundColor Cyan
Write-Host ""

$Target = "$VPS_USER@$VPS_IP`:$VPS_PATH/"

try {
    scp Dockerfile.backend $Target
    Write-Host "  ✅ Dockerfile.backend" -ForegroundColor Green
    
    scp docker-compose.yml $Target
    Write-Host "  ✅ docker-compose.yml" -ForegroundColor Green
    
    scp .dockerignore $Target
    Write-Host "  ✅ .dockerignore" -ForegroundColor Green
    
    scp quick-fix.sh $Target
    Write-Host "  ✅ quick-fix.sh" -ForegroundColor Green
    
    # Upload documentation (optional)
    Write-Host ""
    Write-Host "📚 Uploading documentation..." -ForegroundColor Cyan
    
    if (Test-Path "DEPLOYMENT_GUIDE.md") {
        scp DEPLOYMENT_GUIDE.md $Target 2>$null
        Write-Host "  ✅ DEPLOYMENT_GUIDE.md" -ForegroundColor Green
    }
    
    if (Test-Path "DEPLOYMENT_CHECKLIST.md") {
        scp DEPLOYMENT_CHECKLIST.md $Target 2>$null
        Write-Host "  ✅ DEPLOYMENT_CHECKLIST.md" -ForegroundColor Green
    }
    
    if (Test-Path "URGENT_FIX.md") {
        scp URGENT_FIX.md $Target 2>$null
        Write-Host "  ✅ URGENT_FIX.md" -ForegroundColor Green
    }
    
    if (Test-Path "CHANGES_SUMMARY.md") {
        scp CHANGES_SUMMARY.md $Target 2>$null
        Write-Host "  ✅ CHANGES_SUMMARY.md" -ForegroundColor Green
    }
    
    Write-Host ""
    Write-Host "==================================" -ForegroundColor Cyan
    Write-Host "✅ Upload complete!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🚀 Next steps:" -ForegroundColor Yellow
    Write-Host "   1. Connect to VPS: ssh $VPS_USER@$VPS_IP"
    Write-Host "   2. Navigate: cd $VPS_PATH"
    Write-Host "   3. Run fix: chmod +x quick-fix.sh && ./quick-fix.sh"
    Write-Host ""
}
catch {
    Write-Host ""
    Write-Host "❌ Upload failed: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Troubleshooting:" -ForegroundColor Yellow
    Write-Host "  1. Verify SSH key is set up: ssh $VPS_USER@$VPS_IP"
    Write-Host "  2. Check VPS IP address is correct: $VPS_IP"
    Write-Host "  3. Ensure OpenSSH client is installed"
    Write-Host ""
    exit 1
}
