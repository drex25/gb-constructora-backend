#!/bin/bash

# Deploy script for GB Constructora Backend
# This script stops, rebuilds, and restarts the Docker containers

echo "🚀 Starting deployment process..."

# Stop and remove existing containers
echo "📦 Stopping existing containers..."
docker-compose down

# Remove old images to force rebuild
echo "🗑️  Removing old images..."
docker-compose rm -f
docker rmi gb-constructora-backend_strapi 2>/dev/null || true

# Rebuild with no cache
echo "🔨 Building new images (this may take a while)..."
docker-compose build --no-cache --progress=plain

# Start services
echo "🚀 Starting services..."
docker-compose up -d

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 10

# Check health
echo "🏥 Checking service health..."
docker-compose ps

echo ""
echo "✅ Deployment complete!"
echo ""
echo "📊 To view logs, run: docker-compose logs -f strapi"
echo "🔍 To check status, run: docker-compose ps"
echo "🛑 To stop, run: docker-compose down"
