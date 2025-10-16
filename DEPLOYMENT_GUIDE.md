# 🚀 Deployment Instructions for VPS Server

## Prerequisites
- Docker and Docker Compose installed on VPS
- `.env` file with all required environment variables

## Quick Deploy

### Option 1: Using the Deploy Script (Recommended)

```bash
# Make the script executable
chmod +x deploy.sh

# Run deployment
./deploy.sh
```

### Option 2: Manual Deployment

```bash
# 1. Stop existing containers
docker-compose down

# 2. Remove old images (force clean build)
docker rmi gb-constructora-backend_strapi || true

# 3. Build with no cache
docker-compose build --no-cache

# 4. Start services
docker-compose up -d

# 5. Check logs
docker-compose logs -f strapi
```

## Troubleshooting

### Issue: Native binding errors with @swc/core

This has been fixed in the updated Dockerfile by:
- Using multi-stage build
- Installing dependencies with correct NODE_ENV
- Using `--legacy-peer-deps` flag
- Separating build and runtime stages

### Issue: Environment variables not loading

Ensure your `.env` file is in the same directory as `docker-compose.yml` and contains:

```env
# Server Configuration
HOST=0.0.0.0
PORT=1337
NODE_ENV=production

# Database Configuration
DB_PASSWORD=your_secure_password

# Strapi Secrets
APP_KEYS=your_app_keys
API_TOKEN_SALT=your_api_token_salt
ADMIN_JWT_SECRET=your_admin_jwt_secret
TRANSFER_TOKEN_SALT=your_transfer_token_salt
JWT_SECRET=your_jwt_secret

# Client Configuration
CLIENT_URL=http://your-frontend-url:3000
```

### Issue: Port 1337 not accessible

Check if the port is exposed correctly:

```bash
# Check if container is running
docker-compose ps

# Check if port is listening
netstat -tuln | grep 1337

# Check container logs
docker-compose logs strapi
```

### Issue: Database connection failed

```bash
# Check if PostgreSQL is running
docker-compose ps postgres

# Check PostgreSQL logs
docker-compose logs postgres

# Verify database credentials in .env
```

## Health Check

```bash
# Check if Strapi is responding
curl http://localhost:1337/_health

# Or from outside the server
curl http://YOUR_SERVER_IP:1337/_health
```

## Useful Commands

```bash
# View all logs
docker-compose logs -f

# View only Strapi logs
docker-compose logs -f strapi

# View only PostgreSQL logs
docker-compose logs -f postgres

# Restart only Strapi (without rebuilding)
docker-compose restart strapi

# Stop all services
docker-compose down

# Stop and remove volumes (CAUTION: deletes database)
docker-compose down -v

# Check container status
docker-compose ps

# Execute command inside Strapi container
docker-compose exec strapi sh

# Check database connection
docker-compose exec postgres psql -U strapi -d strapi
```

## Post-Deployment Steps

1. **Access Admin Panel**: Navigate to `http://YOUR_SERVER_IP:1337/admin`
2. **Create Admin User**: Follow the setup wizard to create your first admin user
3. **Configure CORS**: Update CORS settings in Strapi admin if needed
4. **Test API Endpoints**: Verify API is accessible from your frontend

## Security Recommendations

1. Use strong passwords in `.env` file
2. Configure firewall to only allow necessary ports
3. Enable HTTPS with reverse proxy (nginx/caddy)
4. Regularly update Docker images
5. Keep `.env` file secure (never commit to git)

## Performance Tips

1. **Monitor Resources**: Use `docker stats` to monitor resource usage
2. **Database Backups**: Set up regular PostgreSQL backups
3. **Log Rotation**: Configure Docker log rotation to prevent disk space issues

## Rollback

If deployment fails and you need to rollback:

```bash
# 1. Stop current containers
docker-compose down

# 2. Pull previous image or rebuild from last working commit
git checkout <previous-commit>

# 3. Rebuild and restart
docker-compose build --no-cache
docker-compose up -d
```

## Support

If issues persist:
1. Check logs: `docker-compose logs -f`
2. Verify `.env` file has all required variables
3. Ensure Docker and Docker Compose are up to date
4. Check system resources (disk space, memory)
