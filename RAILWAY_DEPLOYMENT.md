# Railway Deployment Guide for Grocy

This guide will help you deploy Grocy on Railway with persistent storage and your custom configuration.

## Prerequisites

- Railway account (sign up at [railway.app](https://railway.app))
- Railway CLI (optional but recommended)
- Git repository with your Grocy code

## Configuration Changes Made

This setup includes the following customizations:
- **Dynamic week start**: Meal plan weeks start dynamically on "today" (`MEAL_PLAN_FIRST_DAY_OF_WEEK = -1`)
- **Singapore Dollar (SGD)**: Base currency set to SGD (`CURRENCY = 'SGD'`)

## Files Added/Modified

1. **`Dockerfile`** - Optimized for Railway deployment with PHP 8.3 and Apache
2. **`railway.json`** - Railway configuration with persistent volume
3. **`config-dist.php`** - Updated with SGD currency and dynamic week start

## Deployment Steps

### Method 1: Using Railway Dashboard (Recommended)

1. **Create a New Project**
   - Go to [railway.app](https://railway.app) and sign in
   - Click "New Project"
   - Select "Deploy from GitHub repo"
   - Connect your GitHub account and select your Grocy repository

2. **Configure Environment Variables**
   - In your Railway project dashboard, go to "Variables"
   - Add the following environment variables:
   ```
   GROCY_MODE=production
   GROCY_BASE_URL=https://your-app-name.railway.app
   GROCY_DEFAULT_LOCALE=en
   GROCY_DISABLE_AUTH=false
   ```

3. **Enable Persistent Storage**
   - Railway will automatically create the volume based on `railway.json`
   - The volume will be mounted at `/var/www/html/data`
   - This ensures your database and configuration persist across deployments

4. **Deploy**
   - Railway will automatically build and deploy your application
   - The build process uses the Dockerfile to create your container
   - Initial deployment may take 3-5 minutes

### Method 2: Using Railway CLI

1. **Install Railway CLI**
   ```bash
   npm install -g @railway/cli
   ```

2. **Login and Initialize**
   ```bash
   railway login
   railway init
   ```

3. **Deploy**
   ```bash
   railway up
   ```

4. **Set Environment Variables**
   ```bash
   railway variables set GROCY_MODE=production
   railway variables set GROCY_BASE_URL=https://your-app-name.railway.app
   railway variables set GROCY_DEFAULT_LOCALE=en
   railway variables set GROCY_DISABLE_AUTH=false
   ```

## Post-Deployment Setup

1. **Access Your Application**
   - Your app will be available at `https://your-app-name.railway.app`
   - Railway provides a unique URL for your deployment

2. **Initial Login**
   - Default credentials: `admin` / `admin`
   - **IMPORTANT**: Change these credentials immediately after first login
   - Go to user menu (top right) → "Manage users" → Edit admin user

3. **Verify Configuration**
   - Currency should display as SGD
   - Meal plan weeks should start dynamically on today's date
   - Check that data persists across deployments

## Volume Management

The persistent volume is automatically configured and includes:
- **Database**: SQLite database files
- **Configuration**: `config.php` file
- **Uploads**: Any user-uploaded files
- **Backups**: Automatic backups created during updates
- **Custom files**: Any custom CSS/JS files you add

## Environment Variables Reference

You can override any configuration using environment variables with the `GROCY_` prefix:

```bash
# Core settings
GROCY_MODE=production
GROCY_BASE_URL=https://your-app-name.railway.app
GROCY_DEFAULT_LOCALE=en
GROCY_CURRENCY=SGD

# Feature flags
GROCY_FEATURE_FLAG_STOCK=true
GROCY_FEATURE_FLAG_SHOPPINGLIST=true
GROCY_FEATURE_FLAG_RECIPES=true
GROCY_FEATURE_FLAG_CHORES=true

# Authentication
GROCY_DISABLE_AUTH=false
GROCY_AUTH_CLASS=Grocy\Middleware\DefaultAuthMiddleware
```

## Troubleshooting

### Common Issues

1. **Database Connection Errors**
   - Check that the volume is properly mounted
   - Restart the service in Railway dashboard

2. **Permission Errors**
   - Railway handles permissions automatically
   - If issues persist, redeploy the application

3. **Configuration Not Applying**
   - Ensure environment variables are set correctly
   - Check that `GROCY_` prefix is used for all variables

### Logs

Access logs through Railway dashboard:
- Go to your project → "Deployments" → Click on latest deployment
- View logs to diagnose any issues

### Database Reset

If you need to reset the database:
1. In Railway dashboard, go to "Volumes"
2. Delete the `grocy-data` volume
3. Redeploy the application (new volume will be created)

## Updating

To update your Grocy installation:
1. Update your repository with the latest Grocy code
2. Push changes to your connected GitHub repository
3. Railway will automatically trigger a new deployment
4. The persistent volume ensures your data is preserved

## Support

- **Railway Support**: [Railway Discord](https://discord.gg/railway)
- **Grocy Support**: [GitHub Issues](https://github.com/grocy/grocy/issues)
- **Configuration Help**: Check the `config-dist.php` file for all available options

## Security Notes

- Always change default admin credentials
- Use strong passwords
- Consider enabling additional authentication methods if needed
- Railway provides HTTPS by default for all deployments 