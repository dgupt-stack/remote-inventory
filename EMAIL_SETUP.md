# Automated Email Setup for APK Distribution

## Quick Setup (SendGrid - Recommended)

### 1. Get SendGrid API Key

1. Go to [SendGrid](https://app.sendgrid.com/settings/api_keys)
2. Create new API key with "Mail Send" permissions
3. Copy the API key

### 2. Set Environment Variable

```bash
# Add to your ~/.zshrc or ~/.bash_profile
export SENDGRID_API_KEY='your-api-key-here'

# Or set temporarily
export SENDGRID_API_KEY='SG.xxxxxxxxxxxxx'
```

### 3. Install SendGrid Python Package

```bash
pip3 install sendgrid
```

### 4. Run Deployment

```bash
./deploy-apk.sh
```

The script will now automatically:
1. Build APK
2. Upload to Google Cloud Storage
3. **Send email to dgupt@360world.com and provider@360world.com** ✨

---

## Alternative: Gmail SMTP

If you prefer Gmail SMTP:

### 1. Create App Password

1. Go to Google Account → Security
2. Enable 2-Factor Authentication
3. Generate App Password
4. Copy the 16-character password

### 2. Set Environment Variables

```bash
export GMAIL_USER='dgupt@360world.com'
export GMAIL_APP_PASSWORD='your-16-char-password'
```

### 3. Run Deployment

The script will fall back to SMTP if SendGrid fails.

---

## Testing Email Alone

Test the email sender without building:

```bash
python3 send-email.py \
  "https://example.com/test.apk" \
  "20260112-test" \
  "23M"
```

---

## Troubleshooting

### SendGrid Error

```bash
# Check API key
echo $SENDGRID_API_KEY

# Verify package installed
python3 -c "import sendgrid; print('OK')"
```

### Gmail SMTP Error

```bash
# Check credentials
echo $GMAIL_USER
echo $GMAIL_APP_PASSWORD

# Test SMTP connection
python3 -c "import smtplib; s=smtplib.SMTP_SSL('smtp.gmail.com',465); print('OK')"
```

### Manual Fallback

If both methods fail, the script saves `email-notification.html` for manual sending.

---

## Full Workflow

```bash
# One-time setup
pip3 install sendgrid
export SENDGRID_API_KEY='your-key'

# Every build
./deploy-apk.sh
```

Done! Email sent automatically. 📧
