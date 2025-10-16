# 🎯 VPS Deployment Checklist

## Pre-Deployment Verification

- [ ] `.env` file exists in `/root/gb-constructora-backend/`
- [ ] All environment variables are set in `.env`:
  - [ ] `HOST=0.0.0.0`
  - [ ] `PORT=1337`
  - [ ] `NODE_ENV=production`
  - [ ] `DB_PASSWORD` (set)
  - [ ] `APP_KEYS` (set)
  - [ ] `API_TOKEN_SALT` (set)
  - [ ] `ADMIN_JWT_SECRET` (set)
  - [ ] `TRANSFER_TOKEN_SALT` (set)
  - [ ] `JWT_SECRET` (set)
  - [ ] `CLIENT_URL` (set)
- [ ] Docker is installed and running: `docker --version`
- [ ] Docker Compose is installed: `docker-compose --version`

## Deployment Steps

### Quick Method (Recommended)
```bash
cd /root/gb-constructora-backend
chmod +x quick-fix.sh
./quick-fix.sh
```

### Manual Method
```bash
cd /root/gb-constructora-backend

# 1. Stop and clean
docker-compose down --remove-orphans
docker rmi gb-constructora-backend_strapi 2>/dev/null || true

# 2. Rebuild (no cache)
docker-compose build --no-cache

# 3. Start
docker-compose up -d

# 4. Monitor
docker-compose logs -f strapi
```

## Post-Deployment Verification

- [ ] Containers are running: `docker-compose ps`
- [ ] Both containers show "Up" status
- [ ] Strapi logs show: "Server started on: http://0.0.0.0:1337"
- [ ] No errors in logs: `docker-compose logs strapi | grep -i error`
- [ ] Health endpoint responds: `curl http://localhost:1337/_health`
- [ ] Admin panel accessible: `http://YOUR_IP:1337/admin`
- [ ] API responds: `curl http://localhost:1337/api`

## Common Issues and Solutions

### ❌ Issue: "Failed to load native binding" error
**Solution:** Fixed in new Dockerfile with multi-stage build

### ❌ Issue: Environment variables not set warnings
**Solution:** 
```bash
# Verify .env file
cat .env

# Ensure no extra spaces or quotes
# Format should be: KEY=value (no spaces around =)
```

### ❌ Issue: Port 1337 not accessible
**Solution:**
```bash
# Check if port is in use
netstat -tuln | grep 1337

# Check firewall
iptables -L -n | grep 1337
# or
ufw status | grep 1337

# Allow port if blocked
ufw allow 1337
```

### ❌ Issue: Database connection failed
**Solution:**
```bash
# Check PostgreSQL container
docker-compose logs postgres

# Restart database
docker-compose restart postgres

# Wait 30 seconds, then restart Strapi
sleep 30
docker-compose restart strapi
```

### ❌ Issue: Out of disk space
**Solution:**
```bash
# Check disk space
df -h

# Clean Docker
docker system prune -a --volumes

# Remove old images
docker image prune -a
```

## Monitoring Commands

```bash
# Real-time logs
docker-compose logs -f strapi

# Last 50 lines
docker-compose logs --tail=50 strapi

# Container stats
docker stats

# Container health
docker-compose ps

# Restart specific service
docker-compose restart strapi
```

## Success Indicators

✅ You should see these messages in logs:
- "Building your admin UI with development configuration"
- "Admin UI built successfully"
- "Server started on: http://0.0.0.0:1337"
- "Loading environment variables from .env"
- "Database connection established"

## Emergency Rollback

If deployment completely fails:

```bash
# Stop everything
docker-compose down -v

# Clean all Docker resources
docker system prune -a --volumes -f

# Start fresh
docker-compose up -d
```

⚠️ **WARNING:** The rollback command with `-v` flag will delete database data!

## Support Information

- Documentation: `/root/gb-constructora-backend/DEPLOYMENT_GUIDE.md`
- Logs location: Check with `docker-compose logs`
- Configuration: `/root/gb-constructora-backend/docker-compose.yml`
- Environment: `/root/gb-constructora-backend/.env`

## Final Verification Test

Run this complete test:

```bash
# 1. Check services
docker-compose ps

# 2. Check health
curl http://localhost:1337/_health

# 3. Check API
curl http://localhost:1337/api

# 4. Check admin (in browser)
# Visit: http://YOUR_SERVER_IP:1337/admin
```

If all tests pass: ✅ **Deployment Successful!**
