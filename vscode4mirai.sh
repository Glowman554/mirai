#!/bin/bash
sudo rm -r /var/www/html/bins
cd ~/mirai
bash build.sh debug telnet
cd ~/mirai/debug
sudo bash ../apache2.sh
sudo rm /var/www/html/bins/mirai.x86
sudo cp ./mirai.dbg /var/www/html/bins/mirai.x86
echo vscode4mirai is done.