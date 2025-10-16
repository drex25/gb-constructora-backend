# 🚨 URGENT FIX - Commands to Run on VPS

## What Was Fixed
The Dockerfile has been updated to fix the `@swc/core` native binding error using:
- Multi-stage Docker build
- Proper NODE_ENV handling during install
- Separation of build and runtime dependencies
- Legacy peer deps flag for compatibility

## 📋 EXACT COMMANDS TO RUN ON YOUR VPS

### Step 1: Upload New Files to VPS

You need to upload these updated files to your VPS:
- `Dockerfile.backend` (UPDATED - CRITICAL)
- `docker-compose.yml` (UPDATED)
- `.dockerignore` (NEW)
- `quick-fix.sh` (NEW - Automated fix script)

### Step 2: Run on VPS

```bash
# Connect to your VPS
ssh root@149.50.132.34

# Navigate to backend directory
cd ~/gb-constructora-backend

# Make quick-fix script executable
chmod +x quick-fix.sh

# Run the automated fix
./quick-fix.sh
```

That's it! The script will:
1. ✅ Clean up old containers
2. ✅ Rebuild with new Dockerfile
3. ✅ Start services
4. ✅ Run health checks
5. ✅ Show status

### Alternative: Manual Commands

If you prefer manual control:

```bash
cd ~/gb-constructora-backend

# Stop everything
docker-compose down --remove-orphans

# Remove old image
docker rmi gb-constructora-backend_strapi 2>/dev/null || true

# Clean Docker cache
docker system prune -f

# Rebuild with no cache (takes 2-5 minutes)
docker-compose build --no-cache

# Start services
docker-compose up -d

# Monitor logs
docker-compose logs -f strapi
```

## ⏱️ What to Expect

1. **Build Phase** (2-5 minutes):
   - Installing dependencies
   - Compiling TypeScript
   - Building admin panel
   - Creating production image

2. **Startup Phase** (30-60 seconds):
   - Database connection
   - Loading plugins
   - Starting server

3. **Success Messages**:
   ```
   ✔ Building build context
   ✔ Building admin panel
   Server started on: http://0.0.0.0:1337
   ```

## 🔍 Verify It's Working

```bash
# Test 1: Check health endpoint
curl http://localhost:1337/_health

# Test 2: Check if containers are running
docker-compose ps

# Test 3: View logs
docker-compose logs --tail=50 strapi

# Test 4: Check from outside (replace IP)
curl http://149.50.132.34:1337/_health
```

## 🆘 If It Still Fails

Check logs for specific errors:
```bash
docker-compose logs strapi | grep -i error
```

Common issues:
1. **Port already in use**: Check with `netstat -tuln | grep 1337`
2. **Out of memory**: Check with `free -m`
3. **Disk space**: Check with `df -h`
4. **Environment variables**: Verify with `cat .env`

## 📞 Need More Help?

Share the output of:
```bash
docker-compose logs strapi
docker-compose ps
docker --version
```

## ✅ Current .env Configuration (You already have this)

Your `.env` is correctly configured:
```env
HOST=0.0.0.0
PORT=1337
NODE_ENV=production
DATABASE_CLIENT=postgres
DATABASE_HOST=postgres
DATABASE_PORT=5432
DATABASE_NAME=strapi
DATABASE_USERNAME=strapi
DATABASE_PASSWORD=jHPW2BxD1er6fNYQb1H0vqnZ4JPFVqkl
APP_KEYS=9HftvieAXiiUDWo9Hy9bNN8+cSWY4RpulFJMdXzwHMk=,QV6NET9CewOEfSz8jLv4dgnHb4ouW6JHNLMaxbRYjPg=,Rao4z/UPd9yW5D+2j1zTQ7B+ZSqoPDxxIODf1bVd8tA=,G9VKI5+/zqt0PRiXlxUoJGWJ7heuWBh3LO5zoT23NtM=
API_TOKEN_SALT=+9Uvuvy/7L3IzIPec5B4gcwbLMM+7NAhP6Kyq1KrGXc=
ADMIN_JWT_SECRET=n6Qp0ax3ommoyZ4vkHqyIzH2yWx8KS+ReLVGxyPHuek=
TRANSFER_TOKEN_SALT=Lrl/Aoi9n3SmW5NcZSjt6GfNwMF2CuigkwAsm2mquqo=
JWT_SECRET=54nXyop2dPxoa00Rc+VDkz/YizRGs2usK+7jwZN5O7I=
CLIENT_URL=http://149.50.132.34:3000
```

✅ This is perfect - no changes needed!

## 🎯 Bottom Line

**The key fix**: New multi-stage Dockerfile that properly handles native dependencies during build.

**Action required**: Upload new `Dockerfile.backend` to VPS and rebuild.

**Estimated time**: 5-10 minutes total (upload + rebuild + startup)

## 🧩 SWC Native Binding Fallback

Para ambientes donde el binario nativo de `@swc/core` falla, se agregó:

- `@swc/wasm` como devDependency para fallback confiable durante el build del admin.
- Variables de entorno `SWC_WASM=1` en build y runtime.
- Middleware `config/middlewares.js` que asegura los flags en arranque.

Esto permite que Strapi construya el admin incluso si el binding nativo no carga correctamente dentro del contenedor.
