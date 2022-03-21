import QtQuick 2.15
import QtQuick.Dialogs 1.3

Dialog{
    id:root
    width: 480
    height: 320
    modality: Qt.WindowModal
    title:"帮助"
    Text{
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.top:parent.top
        anchors.right: parent.right
        wrapMode: Text.WrapAnywhere
        font.pixelSize: 14
        color: "black"
        text: "步骤：1、确保以管理员身份启动该软件，下载安装包.\n如果下载有误，请在设置里打开 [在线获取下载地址]并点击获取按钮\n2、开启hyperv功能，点击安装系统包按钮。\n3、等待安装完成，打开子系统，开启开发者选项，点刷新，即可连接到系统，进行安装app操作"
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
