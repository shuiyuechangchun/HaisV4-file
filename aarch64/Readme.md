# HaisV4
此工具是Hais为方便修改MIUI系统所制作的一修改工具，目前是第四个大版本所以称之为V4。
PS：群内有使用教程、精简列表请前往Q群 [927251103](https://jq.qq.com/?_wv=1027&k=7SaV9nzM) 进行讨论。。
	购买工具后请添加 工具交流群 839927306 进行交流。


### 兼容和支持
0.  安装环境仅支持在 Termux(群共享有下载) 下使用。
1.  手机需为arrch64(arm64)架构,新手机基本上都是了。

### HaisV4特点
1.  便捷配置、一键出包
2.  纯净仅集成破解卡米
3.  禁用DM、AVB等。
4.  高通机型和VAB的MTK机型打出的是线刷、卡刷通用包。
5.  非VAB的MTK机型打出的为卡刷包。


### 安装教程

1.  从群共享下载安装 Termux ，需要权限申请请点同意。 
2.  安装好后输入以下命令即可全自动安装。

	bash <(curl -s http://s.hais.pw/i.sh)
	
3.  由于权限问题,手机端性能较差，推荐使用电脑进行制作。


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
