# WeChatPlugin - 浏览朋友圈&消息防撤回&多开微信&自动回复

Plugin For Mac WeChat.
 

![](http://ofg6kncyv.bkt.clouddn.com/WeChat_logo_icon.png)

## 说明
*  直接运行 WeChatPlugin.xcworkspace


## 功能
* 浏览朋友圈
* 自动登录




## 新增功能WeChatPlugin- 小助手功能

![](https://img.shields.io/badge/platform-osx-lightgrey.svg) ![](https://img.shields.io/badge/support-wechat%202.2.8-green.svg)
    

![微信小助手.png](http://upload-images.jianshu.io/upload_images/965383-31708af611b55ca4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
  
---

### 功能
* 消息自动回复
* 消息防撤回
* 远程控制
* 微信多开
* 第二次登录免认证
* 聊天置底功能(~~类似置顶~~)
* 微信窗口置顶
* 会话多选删除

远程控制：

>远程控制新增指令发送成功回调、发送`获取指令`获得当前所有远程控制信息。

- [x] 屏幕保护
- [x] 清空废纸篓
- [x] 锁屏、休眠、关机、重启
- [x] 退出QQ、WeChat、Chrome、Safari、所有程序
- [x] 网易云音乐(播放、暂停、下一首、上一首、喜欢、取消喜欢)

**若想使用远程控制网易云音乐，请在“系统偏好设置 ==> 安全性与隐私 ==> 隐私 ==> 辅助功能”中添加微信**

---


### Demo 演示

* 消息防撤回   
![消息防撤回.gif](http://upload-images.jianshu.io/upload_images/965383-30cbea645661e627.gif?imageMogr2/auto-orient/strip)

* 自动回复
![自动回复.gif](http://upload-images.jianshu.io/upload_images/965383-d488dce3696ba1b3.gif?imageMogr2/auto-orient/strip)

* 微信多开
![微信多开.gif](http://upload-images.jianshu.io/upload_images/965383-51d8eae02d48fda9.gif?imageMogr2/auto-orient/strip)

* 远程控制 (测试关闭Chrome、QQ、开启屏幕保护)
![远程控制.gif](http://upload-images.jianshu.io/upload_images/965383-0cf50d9b22b02f2f.gif?imageMogr2/auto-orient/strip)

* 免认证 & 置底 & 多选删除
![免认证&置底&多选删除](http://upload-images.jianshu.io/upload_images/965383-170592b03781cbf4.gif?imageMogr2/auto-orient/strip)


--- 

**3. 安装完成**

* 登录微信，在**菜单栏**中看到**微信小助手**即安装成功。 
![微信小助手.png](http://upload-images.jianshu.io/upload_images/965383-31708af611b55ca4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

--- 

### 使用

* 消息防撤回：点击`开启消息防撤回`或者快捷键`command + t`,即可开启、关闭。
* 自动回复：点击`开启自动回复`或者快捷键`conmand + k`，将弹出自动回复设置的窗口，点击红色箭头的按钮设置开关。    

>若关键字为 `*`，则任何信息都回复；
>若关键字为`x|y`,则 x 和 y 都回复；
>若关键字**或者**自动回复为空，则不开启该条自动回复。
>若开启正则，请确认正则表达式书写正确，[在线正则表达式测试](http://tool.oschina.net/regex/)

![自动回复设置.png](http://upload-images.jianshu.io/upload_images/965383-5aa2fd8fadc545c4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


* 微信多开：点击`登录新微信`或者快捷键`command + shift + n`,即可多开微信。

* 远程控制：点击`远程控制 Mac OS`或者快捷键`command + shift + c`,即可打开控制窗口。

![.png](http://upload-images.jianshu.io/upload_images/965383-9c67894ee7092600.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

①为选择是否开启远程控制此功能。   

②为能够触发远程控制的消息内容(仅向自己发送账号有效)。


* 远程控制：发送`获取指令`，手机端可查看所有指令信息。

![远程控制.png](http://upload-images.jianshu.io/upload_images/965383-7c2a4b17e5a6867f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

---
  
### 依赖

* [XMLReader](https://github.com/amarcadet/XMLReader)
* [insert_dylib](https://github.com/Tyilo/insert_dylib)

---
### Other

若有其他好的想法欢迎 Issue me

---
 
![](https://mp.weixin.qq.com/mp/qrcode?scene=10000004&size=102&__biz=MzA3ODQyNDM0Mg==&mid=2650847033&idx=1&sn=f2bee1644c748973b9e632758939c9f9)

欢迎关注微信公众号👆
 


