1. install Ubuntu 20.04 LTS

2. install needed packages:

sudo apt-get install libtool-bin cmake libproxy-dev uuid-dev liblzo2-dev autoconf automake bash bison \
bzip2 diffutils file flex m4 g++ gawk groff-base libncurses-dev libtool libslang2 make patch perl pkg-config shtool \
subversion tar texinfo zlib1g zlib1g-dev git-core gettext libexpat1-dev libssl-dev cvs gperf unzip \
python libxml-parser-perl gcc-multilib gconf-editor libxml2-dev g++-multilib gitk libncurses5 mtd-utils \
libncurses5-dev libvorbis-dev git autopoint autogen sed build-essential intltool libelf1:i386 libglib2.0-dev \
xutils-dev lib32z1-dev lib32stdc++6 xsltproc gtk-doc-tools

#additional for Ubuntu x64
sudo apt-get install lib32z1-dev lib32stdc++6

3. add following to your path (replace &lt;ROOTFOLDER&gt; with the root of the source folder

export PATH=$PATH:&lt;ROOTFOLDER&gt;/asuswrt/release/src-rt-6.x.4708/toolchains/hndtools-arm-linux-2.6.36-uclibc-4.5.3/bin

4. open a terminal and go to &lt;ROOTFOLDER&gt;/asuswrt/release/src-rt-6.x.4708

5. call

make clean 
make rt-ac68u
