#!/bin/bash
# Upload fixed files to VPS
# Run this from your LOCAL machine, inside the backend directory

VPS_IP="149.50.132.34"
VPS_USER="root"
VPS_PATH="~/gb-constructora-backend"

echo "📤 Uploading fixed files to VPS..."
echo "=================================="
echo "Target: $VPS_USER@$VPS_IP:$VPS_PATH"
echo ""

# Check if files exist
FILES=("Dockerfile.backend" "docker-compose.yml" ".dockerignore" "quick-fix.sh")
for file in "${FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "❌ Error: $file not found"
        exit 1
    fi
done

echo "✅ All files found locally"
echo ""

# Upload files
echo "📤 Uploading files..."
scp Dockerfile.backend "$VPS_USER@$VPS_IP:$VPS_PATH/" && echo "  ✅ Dockerfile.backend"
scp docker-compose.yml "$VPS_USER@$VPS_IP:$VPS_PATH/" && echo "  ✅ docker-compose.yml"
scp .dockerignore "$VPS_USER@$VPS_IP:$VPS_PATH/" && echo "  ✅ .dockerignore"
scp quick-fix.sh "$VPS_USER@$VPS_IP:$VPS_PATH/" && echo "  ✅ quick-fix.sh"

# Upload documentation (optional)
echo ""
echo "📚 Uploading documentation..."
scp DEPLOYMENT_GUIDE.md "$VPS_USER@$VPS_IP:$VPS_PATH/" 2>/dev/null && echo "  ✅ DEPLOYMENT_GUIDE.md" || echo "  ⏭️  Skipped"
scp DEPLOYMENT_CHECKLIST.md "$VPS_USER@$VPS_IP:$VPS_PATH/" 2>/dev/null && echo "  ✅ DEPLOYMENT_CHECKLIST.md" || echo "  ⏭️  Skipped"
scp URGENT_FIX.md "$VPS_USER@$VPS_IP:$VPS_PATH/" 2>/dev/null && echo "  ✅ URGENT_FIX.md" || echo "  ⏭️  Skipped"
scp CHANGES_SUMMARY.md "$VPS_USER@$VPS_IP:$VPS_PATH/" 2>/dev/null && echo "  ✅ CHANGES_SUMMARY.md" || echo "  ⏭️  Skipped"

echo ""
echo "=================================="
echo "✅ Upload complete!"
echo ""
echo "🚀 Next steps:"
echo "   1. Connect to VPS: ssh $VPS_USER@$VPS_IP"
echo "   2. Navigate: cd $VPS_PATH"
echo "   3. Run fix: chmod +x quick-fix.sh && ./quick-fix.sh"
echo ""
