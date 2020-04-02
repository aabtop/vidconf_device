#!/bin/sh

BASEDIR=$(dirname "$0")
cd ${BASEDIR}

HTML_FILE=vidconf_wallpaper.html

# Compute the HTML we want to set as a background based on system queries
# and external parameters.
python update_vidconf_wallpaper.py \
  "`hostname -I`" \
  {{guac_login_password}} \
  ${HTML_FILE}

# Make a screenshot of the output using headless Chromium.
chromium-browser \
  --headless \
  --disable-gpu \
  --screenshot \
  --window-size=1920,1080 \
  file://`pwd`/${HTML_FILE}

# Set the screenshot as the desktop wallpaper.
gsettings set org.gnome.desktop.background picture-uri file://`pwd`/screenshot.png
