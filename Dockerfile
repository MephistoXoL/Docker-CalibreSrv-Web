FROM linuxserver/calibre-web

LABEL maintainer="XoL <MephistoXoL@gmail.com>" description="Calibre-Server UI with Calibre and auto-upload for books" version="armv7"

EXPOSE 8083

## INSTALL CALIBRE PACKAGES
RUN apt-get update && \
    apt-get install --no-install-recommends -y calibre cron python-pip python-setuptools python-wheel

## INSTALL APPRISE FOR NOTIFICATIONS
RUN pip install apprise

## CLEAN PACKAGES
RUN apt-get -y purge python-pip python-setuptools python-wheel&& \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY entrypoint.sh /usr/bin/entrypoint.sh

RUN chmod +x /usr/bin/entrypoint.sh

COPY Auto_Books_Calibre.sh /app/Auto_Books_Calibre.sh

RUN chmod +x /app/Auto_Books_Calibre.sh

VOLUME [/books /config]

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
