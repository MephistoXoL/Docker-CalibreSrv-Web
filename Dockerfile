FROM linuxserver/calibre-web

LABEL maintainer="XoL <MephistoXoL@gmail.com>" description="Calibre-Server UI with Calibre and auto-upload for books" version="multi.arch"

EXPOSE 8083

## INSTALL CALIBRE PACKAGES
RUN apt-get update && \
    apt-get install --no-install-recommends -y calibre cron 

## CLEAN PACKAGES
RUN apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## COPY SCRIPTS
COPY entrypoint.sh /usr/bin/entrypoint.sh

RUN chmod +x /usr/bin/entrypoint.sh

COPY Auto_Books_Calibre.sh /app/Auto_Books_Calibre.sh

RUN chmod +x /app/Auto_Books_Calibre.sh

## CREATING STRUCTURE
RUN mkdir /Books_Calibre /Books_Calibre_Backup /Backup_Library && \
    chmod 777 /Books_Calibre /Books_Calibre_Backup /Backup_Library

VOLUME /config /books /Books_Calibre /Books_Calibre_Backup /Backup_Library

ENTRYPOINT /usr/bin/entrypoint.sh
