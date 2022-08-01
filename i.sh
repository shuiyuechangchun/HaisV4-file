#!/bin/sh
ARCH_NAME="$(uname -m)"
show(){ echo  -e "\r\n\033[32m【`date '+%H:%M:%S'`】${1}\033[0m" ; }	#显示打印

#Termux下安装
termuxInstallHaisV4(){
	show "正在准备Termux安装环境中... "
	linux="debian"
	linux_ver="buster"
	linux_Version="cloud"
	arch='arm64'

	rm -rf $HOME/$linux
	rm -rf $HOME/${linux}.tar.xz
	rm -rf $HOME/images.json
	rm -rf $PREFIX/bin/hais

	if [ $(which pkg) ]; then
		show '正在安装Termux依赖'
		if [ ! -d ~/storage  ]; then
			termux-setup-storage >/dev/null 2>&1
		fi
		if [ ! $(which proot) ] || [ ! $(which wget) ] || [ ! $(which tar) ]; then
			show "正在安装软件依赖 ..."
			sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-packages-24 stable main@' $PREFIX/etc/apt/sources.list
			sed -i 's@^\(deb.*games stable\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/game-packages-24 games stable@' $PREFIX/etc/apt/sources.list.d/game.list
			sed -i 's@^\(deb.*science stable\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/science-packages-24 science stable@' $PREFIX/etc/apt/sources.list.d/science.list
			apt-get update
			apt-get install -y tar proot 
			#wget
		fi
	fi
	
	if [ ! $(which proot) ]; then 
		curl "https://jihulab.com/HaisV4/file/-/raw/main/aarch64/proot" -O ${PREFIX}/bin/proot && chmod +x ${PREFIX}/bin/proot
	fi
	
	if [ ! $(which proot) ]; then show "缺少 proot ,请手动安装!";exit 1;fi;
	if [ ! $(which curl) ]; then show "缺少 wget ,请手动安装!";exit 1;fi;
	if [ ! $(which tar) ]; then show "缺少 tar ,请手动安装!";exit 1;fi;
	

	#show '正在获取Debian最新版本'
	#wget -q "https://mirrors.tuna.tsinghua.edu.cn/lxc-images/streams/v1/images.json" -O $HOME/images.json
	#rootfs_url=`cat $HOME/images.json | awk -F '[,"}]' '{for(i=1;i<=NF;i++){print $i}}' | grep "images/${linux}/" | grep "${linux_ver}" | grep "/${arch}/${linux_Version}/" | grep "rootfs.tar.xz" | awk 'END {print}'` && rm $HOME/images.json

	
	#if [ ! $rootfs_url ]; then show "未找到 ${linux} ${linux_ver} ${linux_Version} !";exit 1;fi;
	
	show '开始下载：'$rootfs_url
	#wget -q -c  --show-progress --user-agent="Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/534.16 (KHTML, like Gecko) Chrome/10.0.648.204 Safari/534.16" -O $HOME/${linux}.tar.xz "https://mirrors.tuna.tsinghua.edu.cn/lxc-images/${rootfs_url}"
	curl "https://jihulab.com/HaisV4/file/-/raw/main/all/rootfs.tar.xz" -o $HOME/${linux}.tar.xz
	
	
	if [ ! -f $HOME/${linux}.tar.xz ]; then show "下载失败 ${linux} ${linux_ver} ${linux_Version} !";exit 1;fi;

	show "正在安装 ${linux}"
	mkdir -p "$HOME/$linux"
	mv $HOME/${linux}.tar.xz $HOME/${linux}/${linux}.tar.xz
	cd "$HOME/$linux"
	xz -d ${linux}.tar.xz
	tar -xf ${linux}.tar
	rm -rf ${linux}.tar
	
	show "正在修改${linux}的DNS、软件源、登录脚本 ..."
	echo "127.0.0.1 localhost" > $HOME/${linux}/etc/hosts
	rm -rf etc/resolv.conf
	echo "nameserver 114.114.114.114" > $HOME/${linux}/etc/resolv.conf
	echo "nameserver 8.8.4.4" >> $HOME/${linux}/etc/resolv.conf
	echo "export  TZ='Asia/Shanghai'" >> $HOME/${linux}/root/.bashrc
	sed -i 's#http://deb.debian.org#https://mirrors.tuna.tsinghua.edu.cn#g' $HOME/${linux}/etc/apt/sources.list
	sed -i 's#http://security.debian.org#https://mirrors.tuna.tsinghua.edu.cn#g' $HOME/${linux}/etc/apt/sources.list
	sed -i 's#http://ftp.debian.org#https://mirrors.tuna.tsinghua.edu.cn#g' $HOME/${linux}/etc/apt/sources.list
	#touch "$HOME/${linux}/root/.hushlogin"
	
	HaisStart=$PREFIX/bin/hais

	DEBIAN_TMP_DIR=$HOME/tmp
	mkdir -p $DEBIAN_TMP_DIR
	chmod 0777 $DEBIAN_TMP_DIR

	cat > $HaisStart <<- EOM

	cd $HOME

	export PROOT_TMP_DIR=$DEBIAN_TMP_DIR

	unset LD_PRELOAD
	command="proot"
	command+=" --link2symlink"
	command+=" -0"
	command+=" -r $linux"
	command+=" -b /dev"
	command+=" -b /proc"
	command+=" -b $linux/root:/dev/shm"
	command+=" -b /sdcard"
	command+=" -b /sys"
	command+=" -w /root"
	command+=" /usr/bin/env -i"
	command+=" HOME=/root"
	command+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games"
	command+=" TERM=\$TERM"
	command+=" LANG=C.UTF-8"
	command+=" /bin/bash --login"
	com="\$@"
	if [ -z "\$1" ];then
		exec \$command
	else
		\$command -c "\$com"
	fi
	EOM

	chmod +x $HaisStart

	termux-fix-shebang ${HaisStart} >/dev/null 2>&1
	curl "https://jihulab.com/HaisV4/file/-/raw/main/aarch64/curl" -o $HOME/${linux}/bin/curl && chmod +x $HOME/${linux}/bin/curl
	curl "https://jihulab.com/HaisV4/aarch64/-/raw/master/HaisAuto.sh" -o $HOME/${linux}/bin/hais && chmod +x $HOME/${linux}/bin/hais
	echo -e 'if [ $(command -v "hais") ]; then\n\thais\nfi' > $HOME/${linux}/root/.bashrc

	show '-------------------'
	show '安装完成'
	show '👇👇工具位置👇👇'
	show " ${HOME}/root "
	show '输入 `hais` 即可打开 Hais做包工具 开始做包'
	show ''
	
	read -p $'\n\n往后自动进入(默认N)？[是(Y)/否(N)]：' CHOICE
	if [ "$CHOICE" = 'Y' ] || [ "$CHOICE" = 'y' ] ; then
		echo -e "if [ -d $HOME/${linux} ] && [ $(command -v 'hais') ]; then\n\thais\nfi" > $HOME/.bashrc
		read -p $'已设置打开APK自动进入工具，按任意键继续安装' xxx
		hais
	else
		show '往后您需要手动输入 `hais` 打开 Hais做包工具'
	fi
}


#在Linux下安装HaisV4
linuxInstallHaisV4(){
	show '正在获取Linux安装脚本'
	ToolsPath="${PWD}/HaisV4"
	rm -rf $ToolsPath
	rm -rf '/bin/hais'
	
	echo -e "if [ -d $ToolsPath ] ; then\n\t cd $ToolsPath\n\t./HaisAuto.sh\nfi" > /bin/hais
	chmod +x /bin/hais
	wget -q -c --show-progress "https://jihulab.com/HaisV4/${ARCH_NAME}/-/raw/master/HaisAuto.sh" -O ./Install.sh
	chmod +x ./Install.sh
	./Install.sh
	rm -rf ./Install.sh
	exit
}

linuxInstallCloudHaisV4(){
	show '正在获取Task安装脚本'
	ToolsPath="${PWD}/HaisV4Task"
	rm -rf ${ToolsPath}
	
	apt update && apt install -y git wget
	git clone --depth 1 https://jihulab.com/HaisV4/${ARCH_NAME}_task.git $ToolsPath
	exit
}


#安装类型选择
selectInstallType(){ 
	clear
	
	if [ "$1" = '1' ]; then 
		if [ "$ARCH_NAME" != 'aarch64' ] ;then message='此方式目前仅支持aarch64(arm)的手机使用';
		elif [ `grep -c 'termux' "$PREFIX/etc/apt/sources.list"` -eq 0 ] ;then message='此方式目前仅支持在Termux中使用'; fi ;
		
		if [ -d $HOME/debian ] && [ $(command -v 'hais') ] ; then
			read -p $"\n工具已存在。 [R]重装(需重新激活)/[Q]取消(默认)\n" reType
			if [ "$reType" != 'R' ] ;then rm -rf $HOME/debian;rm -rf $PREFIX/bin/hais;
			else message='按任意键重新选择';fi;
		fi
		
		if [ "$message" != '' ] ;then 
			read -p $"\n安装失败,$message\n"
			selectInstallType
		else 
			termuxInstallHaisV4
		fi
		
	elif [ "$1" = '2' ]; then
		if [ "$ARCH_NAME" != 'aarch64' ] && [ "$ARCH_NAME" != 'x86_64' ] ;then message='此方式目前仅支持aarch64、x86_64';
		elif [ `grep -c 'debian' "/etc/apt/sources.list"` -eq 0 ] && [ `grep -c 'ubuntu' "/etc/apt/sources.list"` -eq 0 ] ;then message='此方式仅支持在Debian、Ubuntu中使用'; fi ;
		
		if [ "$message" != '' ] ;then 
			read -p $"\n安装失败,$message\n"
			selectInstallType
		else 
			linuxInstallHaisV4
		fi		
	elif [ "$1" = '3' ]; then
		linuxInstallCloudHaisV4
	fi
	
	exit
}

if [ "$1" = '' ] ; then
	if [ `grep -c 'termux' "$PREFIX/etc/apt/sources.list"` -eq 0 ] ;then
		selectInstallType 2
	else
		selectInstallType 1
	fi
else
	selectInstallType $1
fi
