![Docker-Gitea](https://raw.githubusercontent.com/MephistoXoL/Docker-CalibreSrv-Web/master/Docker-Calibre.png)

# Docker-CalibreSrv-Web
Docker image for calibre-server UI &amp; Script to **Auto-Add Books**  :book: to the Library (epub format) and **Backup** with :phone: **Telegram notifications**.


This image is based on ```linuxserver/calibre-web``` with Calibre minimal install. Include a Script to Auto-Add all books located in the folder ```/Books_Calibre``` and make a **incremental Backup** of them and Library in ```/Books_Calibre_Backup & /Backup_Library```.

Ports exports:
- 8083 for webUI

Volumes:
- Data is located in ```/config```
- Calibre library located in ```/books``` 
- Books to Add in ```/Books_Calibre``` --- Mandatory to run Auto-Add
- Books Backup in ```/Books_Calibre_Backup``` --- Mandatory to run Auto-Add
- Library Backup in ```/Backup_Library``` --- Mandatory to work run-Add 

## Auto-Add Script
Follow volumes are **mandatory** to properly work, 
:bulb:I recommend mount them from NFS, creating as NFS_VOLUME in Docker:
``` 
- /Books_Calibre (.epub format)
- /Books_Calibre_Backup
- /Backup_Library
```
Cronjob will be created:

```0,15,30,45 * * * * /app/Auto_Books_Calibre.sh >> /Books_Calibre_Backup/01-Calibre.log 2>&1```

#### Books_Calibre
All books to Add to Calibre Library must be located in this folder, **only .epub format**. 

:bulb: Optional: this folder can be mount from Nextcloud or similar.

#### Books_Calibre_Backup
The Script copy all .epub files in this folder as backup.

#### Backup_Library
After add and copy the books the script copy the library in this folder as a incremental backup.

## Telegram Notifications
To enable it you must to add the below environment variables:
- NOTIFICATIONS = enabled
- TOKEN = Your Telegram Bot token
- CHATID = Your Telegram Chat ID

You can create a Telegram Bot and get the Token from [here](https://core.telegram.org/bots#6-botfather).

To get CHATID send a message to the BOT and go to following url ```https://api.telegram.org/bot<YourBOTToken>/getUpdates```

## Install
Command line:
```
docker run -d --restart=always --name calibresrv_web -p 8083:8083 \
                                 -v /your/path/for/data:/config \
                                 -v /your/path/for/Library:/books \
                                 -v /your/path/for/Books_Calibre:/Books_Calibre \
                                 -v /your/path/for/Books_Calibre_Backup:/Books_Calibre_Backup \
                                 -v /your/path/for/Backup_Library:/Backup_Library  \
                                 -e NOTIFICATIONS=enabled \
                                 -e TOKEN="xxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
                                 -e CHATID="xxxxxxxxx" \
                                 mephistoxol/calibresrv_web
```
Docker Compose:
```
version: '3.2'
services:
  app:
    container_name: calibresrv_web
    image: mephistoxol/calibresrv_web
    restart: always
    env:
      - NOTIFICATIONS=enabled
      - TOKEN="xxxxxxxxxxxxxxxxxxxxxxxxxxxx"
      - CHATID="xxxxxxxxx"
    # Traefik v1.7 optional
    labels:
      - traefik.frontend.rule: "Host:calibre.yourdomain.com"
      - traefik.port: "8083"
      - traefik.frontend.redirect.entryPoint: "https" 
    networks:      
      - proxy-tier
    volumes:
      - /your/path/for/data:/config
      - /your/path/for/Library:/books
      - /your/path/for/Books_Calibre:/Books_Calibre
      - /your/path/for/Books_Calibre_Backup:/Books_Calibre_Backup
      - /your/path/for/Backup_Library:/Backup_Library
```
Ansible:
```
      docker_container:
        name: calibresrv_web
        image: mephistoxol/calibresrv_web
        volumes:
          - /your/path/for/data:/config
          - /your/path/for/Library:/books
          - /your/path/for/Books_Calibre:/Books_Calibre
          - /your/path/for/Books_Calibre_Backup:/Books_Calibre_Backup
          - /your/path/for/Backup_Library:/Backup_Library
        env:
          NOTIFICATIONS: "enabled"
          TOKEN: "xxxxxxxxxxxxxxxxxxxxxxxxxxxx"
          CHATID: "xxxxxxxxx"
        restart_policy: always
        # Traefik v1.7 optional
        labels:
          traefik.frontend.rule: "Host:calibre.yourdomain.com"
          traefik.port: "8083"
          traefik.frontend.redirect.entryPoint: "https"
        networks:
          - name: proxy-tier
      register: result
```

## TIPS
- Keep clean the volume ```/your/path/for/Books_Calibre```.
- All files in ```/your/path/for/Books_Calibre``` will are delete when Script Auto_Add finish.
- Allow book conversion with the binary ```/usr/bin/ebook-convert```
- To disable Telegram Notifications remove Environment Variables from command line, Compose or Ansible code.
- You can use Environment Variables from ```linuxserver/calibre-web```
- Binary for conversion ```/usr/bin/ebook-convert```

## Changelog
```
10-11-2019
 - Only check .epub files to start the script
```
```
26-10-2019
 - Fix error with entrypoint.sh
```
```
25-10-2019
 - Initial Release
```

## Donate
[![Paypal](https://raw.githubusercontent.com/MephistoXoL/Things/master/paypal.png)](https://www.paypal.me/mephistoxol)
