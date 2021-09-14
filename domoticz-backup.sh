#!/bin/bash
# Задаем переменные с настройками доступа к серверу Domoticz и пути к файлам
D_IP="localhost"
D_PORT="505"
D_DEST="/media/backup/Domoticz"
D_SRC="/home/pi/domoticz/"
FIND="/usr/bin/find"

# Задаем формат именования файлов для копирования
D_DATABASE="$(date '+%Y%m%d')_database.db"
D_SCRIPTS="$(date '+%Y%m%d')_scripts.tar.gz"
D_PLUGINS="$(date '+%Y%m%d')_plugins.tar.gz"

# Создаем файл и перемещаем его на примонтированный сетевой диск
/usr/bin/curl -s http://$D_IP:$D_PORT/backupdatabase.php &gt; $D_DEST/$D_DATABASE

# Архивируем данные
gzip -9 $D_DEST/$D_DATABASE --force
tar -zcvf $D_DEST/$D_SCRIPTS $D_SRC/scripts/ --ignore-failed-read
tar -zcvf $D_DEST/$D_PLUGINS $D_SRC/plugins/ --ignore-failed-read

# Удаляем файлы бэкапов старше 14 дней
$FIND $D_DEST -name '*.gz' -mtime +14 -delete
