#!/bin/bash
# Quick Fix Script for VPS Deployment
# Run this on your VPS server: bash quick-fix.sh

set -e  # Exit on any error

echo "🔧 GB Constructora Backend - Quick Fix"
echo "======================================"
echo ""

# Check if .env exists
if [ ! -f .env ]; then
    echo "❌ ERROR: .env file not found!"
    echo "Please create .env file with all required variables"
    exit 1
fi

# Check if docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ ERROR: Docker is not running!"
    exit 1
fi

# Step 1: Clean up
echo "🧹 Step 1: Cleaning up old containers and images..."
docker-compose down --remove-orphans 2>/dev/null || true
docker rmi gb-constructora-backend_strapi 2>/dev/null || true
docker system prune -f

# Step 2: Rebuild
echo ""
echo "🔨 Step 2: Building new image (this will take 2-5 minutes)..."
docker-compose build --no-cache --progress=plain strapi

# Step 3: Start services
echo ""
echo "🚀 Step 3: Starting services..."
docker-compose up -d

# Step 4: Wait and check
echo ""
echo "⏳ Waiting for services to initialize (30 seconds)..."
sleep 30

# Step 5: Health check
echo ""
echo "🏥 Step 5: Performing health check..."
echo ""

# Check containers
echo "📦 Container Status:"
docker-compose ps
echo ""

# Check Strapi logs
echo "📝 Recent Strapi Logs:"
docker-compose logs --tail=20 strapi
echo ""

# Try health endpoint
echo "🔍 Testing health endpoint..."
if curl -s -f http://localhost:1337/_health > /dev/null 2>&1; then
    echo "✅ Health check passed!"
else
    echo "⚠️  Health check failed or endpoint not ready yet"
    echo "    This is normal if Strapi is still initializing"
    echo "    Wait 1-2 minutes and run: curl http://localhost:1337/_health"
fi

echo ""
echo "======================================"
echo "✅ Deployment process completed!"
echo ""
echo "📋 Next Steps:"
echo "   1. Monitor logs: docker-compose logs -f strapi"
echo "   2. Wait for message: 'Server started on: http://0.0.0.0:1337'"
echo "   3. Access admin: http://YOUR_SERVER_IP:1337/admin"
echo ""
echo "🆘 If issues persist:"
echo "   - Check logs: docker-compose logs strapi"
echo "   - Verify .env: cat .env"
echo "   - Check resources: docker stats"
echo ""
