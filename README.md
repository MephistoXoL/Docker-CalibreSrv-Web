![Docker-Gitea](https://raw.githubusercontent.com/MephistoXoL/Docker-CalibreSrv-Web/master/Docker-Calibre.png)

# Docker-CalibreSrv-Web
Docker image for calibre-server UI &amp; Script to auto-upload Books (epub format) with notifications by Telegram

This image is based on ```inuxserver/calibre-web``` with Calibre minimal install. Include a Script to auto-upload all books located in the folder ```/Books_Calibre```.

Ports exports:
- 8083 for webUI

Volumes exports:
- Data is located in ```/config```
- Calibre library located in ```/books``` 
- Books to upload in ```/Books_Calibre``` --- Mandatory to run Auto-Upload
- Books Backup in ```/Books_Calibre_Backup``` --- Mandatory to run Auto-Upload
- Library Backup in ```/Backup_Library``` --- Mandatory to work run-Upload 

## Auto-Upload Script
Follow volumes are mandatory to properly work:
``` 
- /Books_Calibre (.epub format)
- /Books_Calibre_Backup
- /Backup_Library
```
#### Books_Calibre
All books to upload must be located in this folder, only .epub format.

#### Books_Calibre_Backup
The Script copy all .epub files in this folder as backup.

#### Backup_Library
After add and copy the books the script copy the library in this folder as a incremental backup.

### Notifications by Telegram
Notifications powered by ```caronc/apprise```.
To enable it you must to add the below environment variables:
- NOTIFICATIONS = enabled
- TOKEN = Your Telegram Bot token
- CHATID = Your Telegram Chat ID

You can create the Telegram Bot from here

## Install
Command line:
```
docker run -d -p 8083:8083 -v /your/path/for/data:/config -v /your/path/for/Library:/books -v /your/path/for/Backup_Library:/Backup_Library -v /your/path/for/Books_Calibre:/Books_Calibre -v /your/path/for/Backup_Library:/Backup_Library  -e NOTIFICATIONS=enabled -e TOKEN="xxxxxxxxxxxxxxxxxxxxxxxxxxxx" -e CHATID="xxxxxxxxx" mephistoxol/calibresrv_web
```


## Donate
[![Paypal](https://raw.githubusercontent.com/MephistoXoL/Things/master/paypal.png)](https://www.paypal.me/mephistoxol)
