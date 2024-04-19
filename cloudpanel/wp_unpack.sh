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

if [ -z "$1" ]; then
  echo -e "${Red}ERROR: You must provide one parameter to use as the file name for the archive."
  echo -e "${NC} For example:"
  echo -e "$    ./wp_unpack.sh filename site_user site_root"
  exit 0
fi

if [ -z "$2" ]; then
  echo -e "${Red}ERROR: You must provide a second parameter to use as the site user."
  echo -e "${NC} For example:"
  echo -e "$    ./wp_unpack.sh filename site_user site_root"
  exit 0
fi

if [ -z "$3" ]; then
  echo -e "${Red}ERROR: You must provide a third parameter to use as the site root directory."
  echo -e "${NC} For example:"
  echo -e "$    ./wp_unpack.sh filename site_user site_root"
  exit 0
fi

IP=$(hostname -I | grep -o '^[^ ]*')

FILE_NAME=$1
TAR_FILE="${FILE_NAME}.tar.gz"
TEMP_DIR="${FILE_NAME}_temp"
SITE_USER=$2
SITE_ROOT=$3
WP_ROOT="/home/$SITE_USER/htdocs/$SITE_ROOT"
WP_CONTENT="${WP_ROOT}/wp-content"
WP_CONFIG="${WP_ROOT}/wp-config.php"
# Grab the PW from wp-config
DB_PW=$(cat $WP_CONFIG | grep DB_PASSWORD | cut -d \' -f 4)

if [ -d "$TEMP_DIR" ]; then
  echo -e "${Yellow}WARNING: ${BrightYellow}$TEMP_DIR directory already exists. It will be deleted and recreated."
  rm -r $TEMP_DIR
fi

mkdir $TEMP_DIR

echo -e "${White}PROCESS: Moving into '$TEMP_DIR'."

cd $TEMP_DIR

echo -e "${White}PROCESS: Extracting files from '$TAR_FILE' into '$TEMP_DIR'."
echo -e "${White}PROCESS: Extracting files... This may take a few minutes."

tar xf ~/$TAR_FILE

echo -e "${Green}SUCCESS: Extraction complete."

echo -e "${Magenta}The following files were extracted."

ls -lh 

echo -e "${White}PROCESS: Importing database."

mysql -u $SITE_USER -p$DB_PW $SITE_USER < "$FILE_NAME.sql"

echo -e "${Green}SUCCESS: Database import complete."

echo $WP_CONTENT

echo -e "${White}PROCESS: Copying 'themes', 'plugins', 'uploads', and 'mu-plugins' directories into '$WP_CONTENT'."

cp -r themes/ plugins/ uploads/ mu-plugins/ $WP_CONTENT

echo -e "${Green}SUCCESS: Files copied successfully."

echo -e "${White}PROCESS: Moving back to root."

cd ~/

echo -e "${White}PROCESS: Removing $TEMP_DIR and $TAR_FILE."

rm -r $TEMP_DIR

echo -e "${Cyan}Your site migration is complete."
echo -e "${Cyan}Visit the cloudpanel to configure SSL certificate."
echo -e "${NC}  ---  "
echo -e "${Cyan}Make sure to remove the archive file."
echo -e "${NC}    rm $TAR_FILE"
echo -e "${Cyan}Run the following command to remove this script from your machine."
echo -e "${NC}    rm ./wp_unpack.sh"

exit