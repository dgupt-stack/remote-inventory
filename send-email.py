#!/usr/bin/env python3
"""
Email notification sender for APK distribution
Requires: pip install sendgrid
Set environment variable: SENDGRID_API_KEY
"""

import os
import sys
from datetime import datetime

def send_email_sendgrid(download_url, version, size):
    """Send email via SendGrid API"""
    try:
        from sendgrid import SendGridAPIClient
        from sendgrid.helpers.mail import Mail, Email, To, Content
    except ImportError:
        print("⚠️  SendGrid not installed. Install with: pip install sendgrid")
        return False

    api_key = os.environ.get('SENDGRID_API_KEY')
    if not api_key:
        print("⚠️  SENDGRID_API_KEY environment variable not set")
        print("   Get your API key from: https://app.sendgrid.com/settings/api_keys")
        print("   Then set it with: export SENDGRID_API_KEY='your-key-here'")
        return False

    # Email content
    subject = f"JARVIS Remote Inventory - New Build Available ({version})"
    
    from_email = Email("noreply@360world.com", "JARVIS CI/CD")
    to_emails = [
        To("dgupt@360world.com"),
        To("provider@360world.com")
    ]

    html_content = f"""
<!DOCTYPE html>
<html>
<head>
    <style>
        body {{ font-family: Arial, sans-serif; line-height: 1.6; color: #333; }}
        .container {{ max-width: 600px; margin: 0 auto; padding: 20px; }}
        .header {{ background: linear-gradient(135deg, #0A0E27 0%, #1a1f3a 100%); color: #00D9FF; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }}
        .content {{ background: #f4f4f4; padding: 30px; border-radius: 0 0 10px 10px; }}
        .button {{ display: inline-block; background: #00D9FF; color: #0A0E27; padding: 12px 30px; text-decoration: none; border-radius: 5px; font-weight: bold; margin: 20px 0; }}
        .button:hover {{ background: #00b8d4; }}
        .details {{ background: white; padding: 15px; border-left: 4px solid #00D9FF; margin: 20px 0; }}
        .footer {{ text-align: center; color: #666; font-size: 12px; margin-top: 20px; }}
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>⭐ J.A.R.V.I.S ⭐</h1>
            <h2>Remote Inventory - New Build Available</h2>
        </div>
        <div class="content">
            <p>Hello!</p>
            <p>A new build of the JARVIS Remote Inventory app is ready for testing.</p>
            
            <div class="details">
                <strong>Build Details:</strong><br>
                📱 Version: {version}<br>
                📅 Build Date: {datetime.now().strftime('%B %d, %Y %I:%M %p %Z')}<br>
                📦 Size: {size}<br>
                🔧 Type: Release Build<br>
                🎯 Features: Unified Provider + Consumer App
            </div>

            <center>
                <a href="{download_url}" class="button">📥 Download APK</a>
            </center>

            <p><strong>What's New:</strong></p>
            <ul>
                <li>✅ Merged provider and consumer into single unified app</li>
                <li>✅ Cleaned up code structure (removed 134 redundant files)</li>
                <li>✅ Complete Lovable REST API integration</li>
                <li>✅ WebRTC signaling (OFFER/ANSWER/ICE)</li>
                <li>✅ JARVIS-themed Material Design 3 UI</li>
            </ul>

            <p><strong>Installation Instructions:</strong></p>
            <ol>
                <li>Download the APK from the link above</li>
                <li>Enable "Install from Unknown Sources" in your Android settings</li>
                <li>Open the downloaded APK file to install</li>
                <li>Launch "JARVIS Remote Inventory" and start testing!</li>
            </ol>

            <p><strong>Direct Download URL:</strong><br>
            <a href="{download_url}">{download_url}</a></p>

            <div class="footer">
                <p>This is an automated build notification from the Remote Inventory CI/CD pipeline.</p>
                <p>Built on {datetime.now().strftime('%B %d, %Y at %I:%M %p %Z')}</p>
                <p>Questions? Contact dgupt@360world.com</p>
            </div>
        </div>
    </div>
</body>
</html>
    """

    try:
        message = Mail(
            from_email=from_email,
            to_emails=to_emails,
            subject=subject,
            html_content=Content("text/html", html_content)
        )
        
        sg = SendGridAPIClient(api_key)
        response = sg.send(message)
        
        if response.status_code == 202:
            print("✅ Email sent successfully!")
            print(f"   To: dgupt@360world.com, provider@360world.com")
            return True
        else:
            print(f"⚠️  Unexpected status code: {response.status_code}")
            return False
            
    except Exception as e:
        print(f"❌ Failed to send email: {str(e)}")
        return False


def send_email_smtp(download_url, version, size):
    """Fallback: Send email via SMTP (requires Gmail app password)"""
    import smtplib
    from email.mime.multipart import MIMEMultipart
    from email.mime.text import MIMEText
    
    gmail_user = os.environ.get('GMAIL_USER', 'dgupt@360world.com')
    gmail_password = os.environ.get('GMAIL_APP_PASSWORD')
    
    if not gmail_password:
        print("⚠️  GMAIL_APP_PASSWORD not set for SMTP fallback")
        return False
    
    # Create message
    msg = MIMEMultipart('alternative')
    msg['Subject'] = f"JARVIS Remote Inventory - New Build ({version})"
    msg['From'] = gmail_user
    msg['To'] = "dgupt@360world.com, provider@360world.com"
    
    # Similar HTML content as SendGrid
    html = f"""<html><body><h2>New APK Build Available</h2>
    <p>Download: <a href="{download_url}">APK v{version}</a></p>
    <p>Size: {size}</p></body></html>"""
    
    part = MIMEText(html, 'html')
    msg.attach(part)
    
    try:
        server = smtplib.SMTP_SSL('smtp.gmail.com', 465)
        server.login(gmail_user, gmail_password)
        server.sendmail(gmail_user, ["dgupt@360world.com", "provider@360world.com"], msg.as_string())
        server.quit()
        print("✅ Email sent via SMTP!")
        return True
    except Exception as e:
        print(f"❌ SMTP failed: {str(e)}")
        return False


if __name__ == "__main__":
    if len(sys.argv) < 4:
        print("Usage: python3 send-email.py <download_url> <version> <size>")
        sys.exit(1)
    
    download_url = sys.argv[1]
    version = sys.argv[2]
    size = sys.argv[3]
    
    # Try SendGrid first, fall back to SMTP
    if not send_email_sendgrid(download_url, version, size):
        print("\nTrying SMTP fallback...")
        if not send_email_smtp(download_url, version, size):
            print("\n❌ All email methods failed")
            print("\nManual option:")
            print(f"  Download URL: {download_url}")
            print(f"  Email to: dgupt@360world.com, provider@360world.com")
            sys.exit(1)
