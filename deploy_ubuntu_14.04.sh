#!/bin/sh
#########################
# === global config === #
#########################
WORKDIR=`dirname $(readlink -f $0)`

LOGFILE="$WORKDIR/install.log"

URL_HEAD="http://openlinux.amlogic.com:8000"

#########################
#   === function ===    #
#########################



check_root()
{
	if [ "$(id -u)" != "0" ]; then
	echo "!!!! This script must be run as root !!!" 1>&2
	echo "USAGE: please use command: sudo su - change to account root if your account is sudo user" 1>&2
	echo "or use command: su - root change to account root if it's not a sudo user" 1>&2
	echo "Script will exit, you need run it again" 1>&2
	exit 1
	else
	echo "OK.... you are running by root.. system will keep going..."
	fi
}

check_OS()
{
	OS_MACHINE=`uname -m`
	if [ "$OS_MACHINE" = "x86_64" ]; then
	echo "OK~~~your OS is 64bit... you can use this script...."
	else
	echo "Sorry, This script doesn't support your OS platform.... will exit"
	exit 1
	fi
}

change_sourcelist()
{
	echo "Going to check your OS version....."
	OS_NUMBER=`cat /etc/lsb-release  |grep RELEASE |awk -F "=" '{print $2}'`
	if [ "$OS_NUMBER" = "10.10" ]; then
		OS_VERSION="maverick"
	else if [ "$OS_NUMBER" = "11.10" ]; then
		OS_VERSION="oneiric"
	else if [ "$OS_NUMBER" = "12.04" ]; then
		OS_VERSION="precise"
	else if [ "$OS_NUMBER" = "13.10" ]; then
		OS_VERSION="saucy"
	else if [ "$OS_NUMBER" = "14.04" ]; then	
		OS_VERSION="trusty"
	else
		echo "Sorry, This script only support Ubuntu 10.10 and 11.10,12.04..... will exit!!"
		exit 1
	fi
	fi
	fi
	fi
	fi

}
	
install_software()
{
	echo "We are going to do apt-get update..... please wait......"
	apt-get update
	echo "############################################################"
	echo "#####       going to install samba,nfs,vim             #####"
	echo "############################################################"
	apt-get install -y nfs-kernel-server vim autofs automake make perl gcc g++ 
}
config_software()
{
	

	echo "############################################################"
	echo "#####       going to install gnutools, arm gcc         #####"
	echo "############################################################"
	wget $URL_HEAD/deploy/CodeSourcery.tar.gz -P /tmp
	tar -zxvf /tmp/CodeSourcery.tar.gz -C /opt
	wget $URL_HEAD/deploy/gnutools.tar.gz -P /tmp
	tar -zxvf /tmp/gnutools.tar.gz -C /opt
	wget $URL_HEAD/deploy/gcc-linaro-arm-linux-gnueabihf.tar.gz -P /tmp
	tar -zxvf /tmp/gcc-linaro-arm-linux-gnueabihf.tar.gz -C /opt
	wget $URL_HEAD/deploy/arc-4.8-amlogic-20130904-r2.tar.gz  -P /tmp
	tar -zxvf /tmp/arc-4.8-amlogic-20130904-r2.tar.gz -C /opt/gnutools


	wget $URL_HEAD/deploy/arc_gnutools.sh -P /etc/profile.d
	wget $URL_HEAD/deploy/arm_path.sh -P /etc/profile.d
	wget $URL_HEAD/deploy/repo -P /usr/bin
	wget $URL_HEAD/deploy/arm_new_gcc.sh -P /etc/profile.d
	wget $URL_HEAD/deploy/arc_new_tools.sh -P /etc/profile.d

	chmod +x /usr/bin/repo

}

install_library()
{
	echo "############################################################"
	echo "#####       going to install library     #####"
	echo "############################################################"
	apt-get install -y python-software-properties
	add-apt-repository ppa:sun-java-community-team/sun-java6
	apt-get update

	### install the library
	if [ "$OS_NUMBER" = "12.04"  || "$OS_NUMBER" = "13.10"]; then
	   apt-get install -y git-core gnupg flex bison gperf build-essential \
  	   zip curl libc6-dev libncurses5-dev:i386 x11proto-core-dev \
  	   libx11-dev:i386 libreadline6-dev:i386 libgl1-mesa-dev:i386 \
  	   g++-multilib mingw32 tofrodos python-markdown libxml2-utils xsltproc zlib1g-dev:i386
  	else if [ "$OS_NUMBER" = "14.04" ]; then
  	   apt-get install -y git-core gnupg flex bison gperf build-essential \
  	   zip curl zlib1g-dev libc6-dev lib32ncurses5-dev lib32z1\
  	   x11proto-core-dev libx11-dev lib32readline-gplv2-dev lib32z-dev \
  	   libxext-doc:i386  libx11-dev:i386 libreadline6-dev:i386  libncurses5-dev:i386 zlib1g-dev:i386 \
  	   mesa-common-dev libgl1-mesa-dev g++-multilib mingw32 tofrodos python-markdown libxml2-utils xsltproc
	else
	   apt-get install -y git-core gnupg flex bison gperf build-essential \
  	   zip curl zlib1g-dev libc6-dev lib32ncurses5-dev ia32-libs \
  	   x11proto-core-dev libx11-dev lib32readline5-dev lib32z-dev \
  	   libgl1-mesa-dev g++-multilib mingw32 tofrodos python-markdown libxml2-utils xsltproc
	fi
	fi

	
	if [ "$OS_NUMBER" = "10.10" ]; then
	  ln -s /usr/lib32/mesa/libGL.so.1 /usr/lib32/mesa/libGL.so
	else if [ "$OS_NUMBER" = "11.10" ]; then
	   apt-get install -y libx11-dev:i386
	else if [ "$OS_NUMBER" = "12.04" || "$OS_NUMBER" = "13.10" || "$OS_NUMBER" = "14.04" ]; then
	   apt-get install -y gcc-4.4 g++-4.4
	   ln -s /usr/lib/i386-linux-gnu/mesa/libGL.so.1 /usr/lib/i386-linux-gnu/libGL.so
	   rm /usr/bin/gcc
	   rm /usr/bin/g++
	   ln -s /usr/bin/gcc-4.4 /usr/bin/gcc
	   ln -s /usr/bin/g++-4.4 /usr/bin/g++
	fi
	fi
	fi

}

install_java_in_new_way(){

	echo "############################################################"
	echo "#####       going to install java in new way           #####"
	echo "############################################################"
	apt-get purge openjdk*
	add-apt-repository ppa:webupd8team/java	
	apt-get update 
	apt-get install oracle-java6-installe
}

install_x_desktop()
{
	echo "############################################################"
	echo "#####       going to install ubuntu desktop software   #####"
	echo "############################################################"

	apt-get install -y ubuntu-desktop

}

timing()
{
	echo  "\a Just please wait for 30 seconds....\r"

	for i in $(seq 60|tac);do
           echo -n "${i}."
           sleep 1
	done

}

###TODO####
### NOT START BY NOW ####
check_software()
{
	if [ ! -f /tmp/software.list ]
	then
	wget $URL_HEAD/deploy/software.list -P /tmp
	fi

	SOFTLIST=/tmp/software.list
	SOFT=`cat $SOFTLIST`
	for soft in $SOFT
	do
	apt-get install -y $soft 
	done
}

reboot_machine()
{
	echo "############################################################"
	echo "#####       going to reboot machine		     #####"
	echo "############################################################"

	echo "I will reboot machine after 60s... you can type ctrl+c to cancel it..."
	timing
	shutdown -r now
}

echo "This is the script help config ubuntu android build server conveniently...
this script only support ubuntu 10.10 and 11.10 version.. by now, I only 
add 64bit software in it.. so please dont try on 32bit OS..
I will keep update this script if we need...
Nothing need you do, just use sh auto_install_ubuntu.sh, script will help
you install all we need." 


echo "Step 1:	check root..."
check_root
echo "Step 3:	check OS version..."
check_OS

echo "Step 4:	Begin to install and config software..."
change_sourcelist
install_software
config_software
#install_x_desktop
install_library
#install_java_in_new_way
check_software
reboot_machine
