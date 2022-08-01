# HaisV4
此工具是Hais为方便修改MIUI系统所制作的一修改工具，目前是第四个大版本所以称之为V4。
PS：群内有使用教程、精简列表请前往Q群 [927251103](https://jq.qq.com/?_wv=1027&k=7SaV9nzM) 进行讨论。。
	购买工具后请添加 工具交流群 839927306 进行交流。


### 兼容和支持
0.  安装环境仅支持x64、arm64的Debian10或以上、Ubuntu20.4或以上、windowsWsl
1.  做包仅支持MIUI的安卓10、11、12


### HaisV4特点
1.  便捷配置、一键出包
2.  纯净仅集成破解卡米
3.  禁用DM、AVB等。
4.  高通机型和VAB的MTK机型打出的是线刷、卡刷通用包。
5.  非VAB的MTK机型打出的为卡刷包。


### 安装教程

#### 在Linux环境(Ubuntu、Debian)下中可直接输入命令安装使用。
bash <(curl -s http://s.hais.pw/i.sh)


#### 在支持 WSL 的 Windows10、11上使用。

1、使用【Powershell管理员身份】运行下面命令启用WSL后重启电脑。
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

2、下载 http://u.hais.pw/x86/down 打开 Hais做包.exe 即可开始按照提示做包。
Ps:不使用的话在命令行输入 `wslconfig /u Debian` 卸载依赖，然后删除文件夹即可
Ps:如果闪退,请打开debian.exe按照提示解决.
Ps:推荐使用Wsl1+固态硬盘10分钟可出1个包,如果是Wsl2估计要半个小时起步


### 工具内文件说明

1.0   工具启动脚本					HaisAuto.sh

2.0   使用说明						Readme.md

3.0   存放核心						Bin

3.1   工具依赖						Bin\Lib

3.2   配置文件(这文件夹重点理解)	Bin\Config

3.2.1 设置作者、压缩、包类型等      Bin\Config\BuildConfig.ini

3.2.2 精简列表(群共享有参考)		Bin\Config\DeleteFileConfig.ini

3.2.3 刷机脚本描述和修改			Bin\Config\FlashScriptConfig.ini

3.2.4 制作ROM需要添加的文件			Bin\Config\AddReplaceFile

3.2.5 制作线添加的线刷工具			Bin\Config\FlashImageTools

3.2.6 往某文件中追加的文字			Bin\Config\MergeFile

3.2.7 插桩修改的配置项				Bin\Config\SmallPatchFile
