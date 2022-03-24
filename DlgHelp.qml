import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3

Dialog{
    id:root
    width: 480
    height: 320
    modality: Qt.WindowModal
    title:"帮助"
    Flickable{
        id:flick
        anchors.fill:parent

        TextArea.flickable:TextArea{
            anchors.fill: parent
            wrapMode: Text.WrapAnywhere
            font.pixelSize: 16
            color: "black"
            textFormat: Text.MarkdownText

            text: "# 一、下载子系统安装包\n
1. 确保以管理员身份启动该软件\n
2. 下载安装包：点击菜单栏->设置->[在线获取下载地址]，打开获取界面，然后击获[取下载地址按钮],关闭该界面。\n
3. 点击主界面[下载安装包按钮]，等待进度条完成。\n
# 二、开启系统相关功能\n
1. 点击【激活所需功能按钮】，如果提示失败，很可能是因为：①没有以管理员身份启动;②系统已经在之前就激活了相关功能。\n
2. 点击【显示系统功能列表】，点击【查看功能是否已全被激活】来查看是否已经完成开启功能。\n
3. 重启，如果系统提示更新，说明正在开启相关功能。\n
4. 点击【安装子系统按钮】，会立即提示安装完成，等待
# 三、安装安卓app\n
1. 等待安装完成，打开子系统，开启开发者选项，点刷新，即可连接到系统，进行安装app操作"
            }
    }
    CurtainEffect{
        id:curtain
        anchors.fill: parent
    }
    MouseArea{
        anchors.fill: parent
        onClicked: curtain.open = !curtain.open
    }



}
