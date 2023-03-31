sudo apt install gcc-arm-linux-gnueabihf

sudo mkdir /etc/xcompile
sudo cd /etc/xcompile

sudo wget https://www.uclibc.org/downloads/binaries/0.9.30.1/cross-compiler-armv4l.tar.bz2
sudo wget https://www.uclibc.org/downloads/binaries/0.9.30.1/cross-compiler-armv5l.tar.bz2
sudo wget http://distro.ibiblio.org/slitaz/sources/packages/c/cross-compiler-armv6l.tar.bz2
sudo wget https://www.uclibc.org/downloads/binaries/0.9.30.1/cross-compiler-i586.tar.bz2
sudo wget https://www.uclibc.org/downloads/binaries/0.9.30.1/cross-compiler-i686.tar.bz2
sudo wget https://www.uclibc.org/downloads/binaries/0.9.30.1/cross-compiler-m68k.tar.bz2
sudo wget https://www.uclibc.org/downloads/binaries/0.9.30.1/cross-compiler-mips.tar.bz2
sudo wget https://www.uclibc.org/downloads/binaries/0.9.30.1/cross-compiler-mipsel.tar.bz2
sudo wget https://www.uclibc.org/downloads/binaries/0.9.30.1/cross-compiler-powerpc.tar.bz2
sudo wget https://www.uclibc.org/downloads/binaries/0.9.30.1/cross-compiler-sh4.tar.bz2
sudo wget https://www.uclibc.org/downloads/binaries/0.9.30.1/cross-compiler-sparc.tar.bz2
sudo wget https://www.uclibc.org/downloads/binaries/0.9.30.1/cross-compiler-x86_64.tar.bz2

sudo tar -jxf cross-compiler-armv4l.tar.bz2
sudo tar -jxf cross-compiler-armv5l.tar.bz2
sudo tar -jxf cross-compiler-armv6l.tar.bz2
sudo tar -jxf cross-compiler-i586.tar.bz2
sudo tar -jxf cross-compiler-i686.tar.bz2
sudo tar -jxf cross-compiler-m68k.tar.bz2
sudo tar -jxf cross-compiler-mips.tar.bz2
sudo tar -jxf cross-compiler-mipsel.tar.bz2
sudo tar -jxf cross-compiler-powerpc.tar.bz2
sudo tar -jxf cross-compiler-sh4.tar.bz2
sudo tar -jxf cross-compiler-sparc.tar.bz2
sudo tar -jxf cross-compiler-x86_64.tar.bz2

sudo rm *.tar.bz2
sudo mv cross-compiler-armv4l armv4l
sudo mv cross-compiler-armv5l armv5l
sudo mv cross-compiler-armv6l armv6l
sudo mv cross-compiler-i586 i586
sudo mv cross-compiler-i686 i686
sudo mv cross-compiler-m68k m68k
sudo mv cross-compiler-mips mips
sudo mv cross-compiler-mipsel mipsel
sudo mv cross-compiler-powerpc powerpc
sudo mv cross-compiler-sh4 sh4
sudo mv cross-compiler-sparc sparc
sudo mv cross-compiler-x86_64 x86_64

echo "Adding path variables in ~/.bashrc"
echo " " >> ~/.bashrc
echo "export PATH=\$PATH:/etc/xcompile/armv4l/bin" >> ~/.bashrc
echo "export PATH=\$PATH:/etc/xcompile/armv5l/bin" >> ~/.bashrc
echo "export PATH=\$PATH:/etc/xcompile/armv6l/bin" >> ~/.bashrc
echo "export PATH=\$PATH:/etc/xcompile/i586/bin" >> ~/.bashrc
echo "export PATH=\$PATH:/etc/xcompile/i686/bin" >> ~/.bashrc
echo "export PATH=\$PATH:/etc/xcompile/m68k/bin" >> ~/.bashrc
echo "export PATH=\$PATH:/etc/xcompile/mips/bin" >> ~/.bashrc
echo "export PATH=\$PATH:/etc/xcompile/mipsel/bin" >> ~/.bashrc
echo "export PATH=\$PATH:/etc/xcompile/powerpc/bin" >> ~/.bashrc
echo "export PATH=\$PATH:/etc/xcompile/powerpc-440fp/bin" >> ~/.bashrc
echo "export PATH=\$PATH:/etc/xcompile/sh4/bin" >> ~/.bashrc
echo "export PATH=\$PATH:/etc/xcompile/sparc/bin" >> ~/.bashrc
echo "export PATH=\$PATH:/etc/xcompile/armv6l/bin" >> ~/.bashrc
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bashrc
#echo "export GOPATH=\$HOME/Documents/go" >> ~/.bashrc

#echo "Setting go path for dependecie install"
#export PATH=$PATH:/usr/local/go/bin
#export GOPATH=$HOME/Documents/go

#go get github.com/go-sql-driver/mysql
#go get github.com/mattn/go-shellwords

echo "Done! please restart shell!"
