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
  echo -e "$    ./wp_compress filename"
  exit 0
fi

archive_name=$1
archive_temp="${archive_name}-temp"
archive_tar="$archive_name.tar.gz"

IP=$(hostname -I | grep -o '^[^ ]*')

# Grab the necessary passwords from DO
. .digitalocean_password

if [ -d "$archive_temp" ]; then
  echo -e "${Yellow}WARNING: ${BrightYellow}$archive_temp directory already exists. It will be deleted and recreated."
  rm -r $archive_temp
fi

mkdir "${archive_temp}"

# get db copy
# use this password
# echo $root_mysql_pass
echo -e "${White}PROCESS: Creating a backup of the database..."

mysqldump -u root --password=$root_mysql_pass wordpress > ~/$archive_temp/$archive_name.sql

echo -e "${Green}SUCCESS: Database backup is complete. Saved here: ${NC}'~/$archive_temp/$archive_name.sql'."

echo -e "${White}PROCESS: Moving to 'wp-content' directory."

cd /var/www/html/wp-content

echo -e "${White}PROCESS: Copying 'themes', 'plugins', 'uploads', and 'mu-plugins' directories into '$archive_temp'."

cp -r themes/ plugins/ uploads/ mu-plugins/ ~/$archive_temp/ > /dev/null 2>&1

echo -e "${White}PROCESS: Moving into '$archive_temp'."

cd ~/$archive_temp

echo -e "${White}PROCESS: Starting compression of '$archive_temp' into '$archive_tar'."
echo -e "${Magenta}The following files will be included in your compressed archive:"

ls -lh

echo -e "${White}PROCESS: Compressing files... This may take a few minutes."

tar czf ~/$archive_tar ./*

echo -e "${Green}SUCCESS: Done Compressing."

echo -e "${White}PROCESS: Moving back to root directory..."

cd ~/

echo -e "${White}PROCESS: Discarding the temp archive."

rm -r $archive_temp

echo -e "${Green}SUCCESS: Compression complete."

echo -e "${White}Removing 'wp_compress.sh' for security purposes."
rm wp_compress.sh

echo -e "${Cyan}Your archive file is ready at ${NC}'~/$archive_tar'."
echo -e "${Cyan}Use the following command to download it to your desktop."
echo -e "${NC}    scp root@$IP:$archive_tar ~/Desktop/"

exit
