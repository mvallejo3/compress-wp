#!/bin/bash

NC='\033[0m' # No Color
Black='\033[0;30m'
Red='\033[0;31m'
Green='\033[0;32m'
Yellow='\033[0;33m'
Blue='\033[0;34m'
Magenta='\033[0;35m'
Cyan='\033[0;36m'
White='\033[0;37m'
BrightBlack='\033[0;90m'
BrightRed='\033[0;91m'
BrightGreen='\033[0;92m'
BrightYellow='\033[0;93m'
BrightBlue='\033[0;94m'
BrightMagenta='\033[0;95m'
BrightCyan='\033[0;96m'
BrightWhite='\033[0;97m'

if [ -z "$1" ] || [ -z "$2" ]; then
  echo -e "${Red}ERROR: You are missing arguments. Follow the example below:"
  echo -e "${NC} -- "
  echo -e "$    ./wp_compress.sh filename /home/photon-wpstg/htdocs/wpstg.photon.software"
  exit 0
fi

# Build Archive File
FILE_NAME=$1
TAR_FILE="${FILE_NAME}.tar.gz"
TEMP_DIR="${FILE_NAME}_temp"
# Surmise WP
WP_ROOT=$2
SITE_USER=$(echo $WP_ROOT | cut -d '/' -f 3)
SITE_ROOT=$(echo $WP_ROOT | cut -d '/' -f 5)
WP_CONTENT="${WP_ROOT}/wp-content"
WP_CONFIG="${WP_ROOT}/wp-config.php"
# Get DB pw
DB_PW=$(cat $WP_CONFIG | grep DB_PASSWORD | cut -d \' -f 4)
# IP for machine
IP=$(hostname -I | grep -o '^[^ ]*')
# Temp warning
if [ -d "$TEMP_DIR" ]; then
  echo -e "${Yellow}WARNING: ${BrightYellow}$TEMP_DIR directory already exists. It will be deleted and recreated."
  rm -r $TEMP_DIR
fi

mkdir $TEMP_DIR

echo -e "${White}PROCESS: Moving into '$TEMP_DIR'."

cd $TEMP_DIR

echo -e "${White}PROCESS: Creating a backup of the database..."

mysqldump -u $SITE_USER --password=$DB_PW --no-tablespaces $SITE_USER > ~/$TEMP_DIR/$FILE_NAME.sql

echo -e "${Green}SUCCESS: Database backup is complete. Saved here: ${NC}'~/$TEMP_DIR/$FILE_NAME.sql'."

echo -e "${White}PROCESS: Moving to 'wp-content' directory."

cd $WP_CONTENT

echo -e "${White}PROCESS: Copying 'themes', 'plugins', 'uploads', and 'mu-plugins' directories into '$TEMP_DIR'."

cp -r themes/ plugins/ uploads/ mu-plugins/ ~/$TEMP_DIR/ > /dev/null 2>&1

echo -e "${White}PROCESS: Moving into '$TEMP_DIR'."

cd ~/$TEMP_DIR

echo -e "${White}PROCESS: Starting compression of '$TEMP_DIR' into '$TAR_FILE'."
echo -e "${Magenta}The following files will be included in your compressed archive:"

ls -lh

echo -e "${White}PROCESS: Compressing files... This may take a few minutes."

tar czf ~/$TAR_FILE ./*

echo -e "${Green}SUCCESS: Done Compressing."

echo -e "${White}PROCESS: Moving back to root directory..."

cd ~/

echo -e "${White}PROCESS: Discarding the temp archive."

rm -r $TEMP_DIR

echo -e "${Green}SUCCESS: Compression complete."

echo -e "${White}Removing 'wp_compress.sh' for security purposes."
rm wp_compress.sh

echo -e "${Cyan}Your archive file is ready at ${NC}'~/$TAR_FILE'."
echo -e "${Cyan}Use the following command to download it to your desktop."
echo -e "${NC}    scp root@$IP:$TAR_FILE ~/Desktop/"

exit
