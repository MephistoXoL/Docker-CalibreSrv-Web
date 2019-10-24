#!/bin/sh

BOOKS_SCRIPT="/app/Auto_Books_Calibre.sh"
TELEGRAM_MSG="tgram://$TOKEN/$CHATID"
NOTIFICATIONS=$(echo $NOTIFICATIONS | tr a-z A-Z)

# Checking Notifications are enabled
echo "###########################"
echo "# Checking Notifications  #"
echo "###########################"
echo ""
if [ "$NOTIFICATIONS" = "ENABLED" ]; then
        echo "Notifications enabled"
        echo "# Adding Telegram info to Script..."
        sed -i 's,'"Telegram_input"','"apprise $TELEGRAM_MSG -b"',' $BOOKS_SCRIPT
        echo "# Token = $TOKEN"
        echo "# CHATID = $CHATID"
fi
echo ""
echo "# Adding cronjob..."
echo '0,15,30,45 * * * * /app/Auto_Books_Calibre.sh >> /Books_Calibre_Backup/01-Calibre.log 2>&1' | crontab
echo ""
echo "###########################"
echo "# Config completed        #"
echo "###########################"
echo ""
echo "# Starting Calibre-Web... "
/init
