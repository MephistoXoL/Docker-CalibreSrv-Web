#!/bin/bash
# -*- ENCODING: UTF-8 -*-

if [ "$(ls /Books_Calibre)" ]; then
    echo "-------------------------------------------------------------"
    echo "| Found Books to upload to Calibre                          |"
    echo "-------------------------------------------------------------"
    MsgTelegram="|---------------------------------------------------------|"
	MsgTelegram=$MsgTelegram"%0A| Found Books to upload to Calibre |"
	MsgTelegram=$MsgTelegram"%0A| "$(date)" |"
	Telegram_input "$MsgTelegram"
	date
	echo "- Books to Add "
	MsgTelegram=" - Books to Add %0A"
	Books=/Books_Calibre/*.epub
	for i in $Books
	do
		Book=$(echo $i | sed 's/á/a/g' | sed 's/Á/A/g' | sed 's/é/e/g' | sed 's/É/E/g' | sed 's/í/i/g' | sed 's/Í/I/g' | sed 's/ó/o/g' | sed 's/Ó/O/g' | sed 's/ú/u/g' | sed 's/Ú/U/g' | sed 's/ñ/n/g' | sed 's/Ñ/N/g' | sed 's/ü/u/g' | sed 's/Ü/U/g')
		mv "$i" "$Book" 2>/dev/null
		BookName=$(echo $Book | rev | awk -v FS='/' '{print $1}' | rev)
		echo $BookName
		MsgTelegram=$MsgTelegram" · "$BookName"%0A "
	done
	Telegram_input "$MsgTelegram"
	echo ""
        echo "-------------------------------------------------------------"
        echo " Adding Books to Calibre"
        echo "-------------------------------------------------------------"
        calibredb add /Books_Calibre/* --with-library=/books --recurse
        echo " Books Added to Calibre Library"
        echo ""
        echo "-------------------------------------------------------------"
        echo " Backing up books .epub"
        echo "-------------------------------------------------------------"
        Books=/Books_Calibre/*.epub
        for i in $Books
        do
		BookName=$(echo $i | rev | awk -v FS='/' '{print $1}' | rev)
            	echo "Copying... " "$BookName" " a /Books_Calibre_Backup"
          	CopyBook=$(cp -v "$i" /Books_Calibre_Backup)
		echo $CopyBook
        done

        echo ""
        echo " Backup Complete"
        echo ""
        echo "-------------------------------------------------------------"
        echo " Cleaning Books Folder"
        echo "-------------------------------------------------------------"
        echo $(rm -rv /Books_Calibre/*)

        echo " Complete"
        echo ""
        echo "-------------------------------------------------------------"
        echo " Backing up Calibre Library"
        echo "-------------------------------------------------------------"
        echo ""
        cp -Ruv /books/* /Backup_Library
        echo ""
        echo "-------------------------------------------------------------"
        echo " Library Backup Complete"
        echo "-------------------------------------------------------------"
        echo "####################################################################"
        echo ""
	MsgTelegram="| Process Complete "
	MsgTelegram=$MsgTelegram"%0A| "$(date)" |"
	MsgTelegram=$MsgTelegram"---------------------------------------------------------|"
	Telegram_input "$MsgTelegram" 2>/dev/null
fi
