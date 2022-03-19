import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1 as Plat
import QtQuick.Dialogs 1.3 as Dialog
import QtMultimedia 5.15

ApplicationWindow {
    id:root
    width: 640
    height: 480
    visible: true
    title: qsTr("windows安卓子系统工具1.0-mojovs")
    property var urlStr ;	//网址
    //菜单栏
    menuBar: MenuBar{
        Menu{
            title: "设置"
            Action{
                text: "打开设置窗口"
                onTriggered: {
                    //打开设置窗口
                    dlgSet.open();
                }
            }
        }
    }
    //状态栏
    footer:ToolBar{
        RowLayout{
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 100
            Text {
                id:labConnectStatus
                text: qsTr("adb连接状态")
            }
            //用来指示是否连接了adb
            Rectangle{
                id:indicatorConnect
                width:16
                height: width
                radius: width/2
                border.width: 2
                border.color: "black"
                property var isConnect:false
                color: isConnect?"lightgreen":"gray"
            }
        }
    }


    //下载
    RowLayout{
        id:rowDownload
        anchors.top:parent.top
        anchors.left: parent.left;
        anchors.right: parent.right;
        implicitHeight: 120
        spacing: 8
        Text{
            id:labSpeed
            text:"下载速度():"
        }

        ProgressBar{
            id:progressBarDownload
            RowLayout.preferredWidth: 360
        }
        //下载
        Button{
            id:btnDownload
            flat:false
            text:"下载安装包"
            //点击
            onClicked: {

                msgDlgDownload.open();
            }

            ToolTip{
                text: "下载子系统安装包到本地路径"
                visible: btnDownload.hovered
            }
        }
    }

    //路径行
    RowLayout{
        id:rowChoosePath
        anchors.top: rowDownload.bottom
        anchors.left:parent.left;
        anchors.right: parent.right;
        implicitHeight: 120
        spacing: 8

        //label
        Text {
            id:labChoosePath
            text: qsTr("选择安装包路径")
        }
        //TextInput
        TextField{
            id:txtInputPath
            implicitWidth: 300
            selectByMouse: true
            //anchors.left: labChoosePath.right;
            text: ""
            background: Rectangle{
                radius: 4
                border.width: 1
                border.color:"gray"
            }
        }
        Button{
            id:btnChoosePath
            text: "选择路径"
            flat:false
            onClicked: {
                dlgPath.open();
            }
        }
    }

    //给系统安装package行
    RowLayout{
        id:rowInstall
        anchors.top:rowChoosePath.bottom
        anchors.left:parent.left;
        anchors.right: parent.right;
        implicitHeight: 120
        spacing: 8

         Text{
            id:labInstall
            text:"安装进度:"
        }

        ProgressBar{
            id:progBarInstall
            RowLayout.preferredWidth: 360
            indeterminate:false
        }
        //安装
        Button{
            id:btnInstall
            flat:false
            text:"安装子系统"
            //点击
            onClicked: {
                progBarInstall.indeterminate=true
                proc.path=txtInputPath.text;
                proc.installSubSystem();
            }

            ToolTip{
                text: "安装子系统到系统"
                visible: btnInstall.hovered
            }
        }

    }
    //给系统设置可选功能
    RowLayout{
        id:rowSysFunc
        anchors.top:rowInstall.bottom
        anchors.left:parent.left;
        anchors.right: parent.right;
        implicitHeight: 120
        spacing: 8

        //显示
        Button{
            id:btnList
            flat:false
            text:"显示系统功能列表"
            //点击
            onClicked: {
                listModel.listAllFunc();	//列出所有列表
                dlgFunc.open()
                listView.update()
            }

            ToolTip{
                text: "显示"
                visible: btnInstall.hovered
            }
        }
        Button{
            id:btnEnHyper
            flat:false
            text:"激活所需功能"
            //点击
            onClicked: {
                proc.enHyper();
            }

            ToolTip{
                text: "执行命令后请重启"
                visible: btnInstall.hovered
            }
        }
        Button{
            id:btnDisHyper
            flat:false
            text:"取消HyperV功能"
            //点击
            onClicked: {
                proc.disHyper();
            }

            ToolTip{
                text: "执行命令后请重启"
                visible: btnInstall.hovered
            }
        }


    }
    //adb连接相关命令
    RowLayout{
        id:rowAdb
        anchors.top:rowSysFunc.bottom
        anchors.left:parent.left;
        anchors.right: parent.right;
        spacing: 8
        Text{
            text:"adb连接地址"
            Layout.preferredWidth: 70
        }

        //选择adb地址
        TextField{
            id:txtConnect
            text: "127.0.0.1:58526"
            Layout.preferredWidth: 120
            selectByMouse: true
            background:Rectangle {
                radius:4
                border.width:1
                border.color:"darkgreen"
            }
        }
        Button{
            id:btnConnectAdb
            Layout.minimumWidth: 35
            Layout.maximumWidth: 50
            flat:false
            text: "连接"
            //点击进行连接
            onClicked: {
                proc.subIP = txtConnect.text
                proc.adbConnect()		//开始连接
            }

        }
        Text{
            text:"选择apk装包"
        }
        //选择adb地址
        TextField{
            id:txtInstallApk
            text: ""
            Layout.preferredWidth:  120
            selectByMouse: true
            background:Rectangle {
                radius:4
                border.width:1
                border.color:"darkred"
            }
        }
        Button{
            id:btnApkPath
            text:"选择apk装包"
            onClicked: {
                dlgApkPath.open();
            }

        }
    }
    //安装apk
    RowLayout{
        id:rowInstallApk
        anchors.top:rowAdb.bottom
        anchors.left:parent.left;
        width: 300
        spacing: 8
        //安装应用汇
        Button{
            id:btnInstallYingyonghui
            width: 150
            text: "安装应用汇"
            Layout.alignment: Qt.AlignLeft
            onClicked:{
                proc.apkPath=curDirPath+"/apk/yingyonghui.apk"
                proc.adbInstallApk();

            }
            background: Rectangle{
                width: parent.width
                height: parent.height
                radius: 8
                border.width: 2
                border.color: "firebrick"
                color: parent.pressed?"silver":"white"
            }

        }
        //安装自定义apk
        Button{
            id:btnInstallApk
            width:150
            Layout.alignment: btnInstallYingyonghui.right
            text: "安装app"
            onClicked:{
                proc.apkPath=txtInstallApk.text
                proc.adbInstallApk();

            }

            background: Rectangle{
                radius: 8

                width: parent.width
                height: parent.height
                border.width: 2
                border.color: "firebrick"
                color: parent.pressed?"silver":"white"
            }

        }

    }
    //显示列表弹出对话框
    Dialog.Dialog{
        id:dlgFunc
        visible: false
        modality:Qt.WindowModal
        title: "windows 可选功能"
        width: 640
        height:480
        //按钮行
        RowLayout
        {
            id:rowManuFunc
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right:parent.right
            height: 40
            Button{
                id:btnEnableFunc
                text:"激活功能"
            }
            Button{
                id:btnDisableFunc
                text:"取消功能"
            }
        }
        //listView代理
        Component{
            id:listDelegate
            Item{
                id:wrapper
                width: listView.width
                height:30
                //鼠标点击选中当前
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        wrapper.ListView.view.currentIndex=index
                        console.log("点击"+index)
                    }
                }

                RowLayout{
                    anchors.left: parent.left
                    spacing: 4
                    //序号框
                        //序号
                     Text{
                         id:txtIndex
                         text: index
                         //选中变色及变大
                         font.pixelSize:wrapper.ListView.isCurrentItem?22:18
                         color:wrapper.ListView.isCurrentItem?"red":"black"
                         //设置大小
                         Layout.preferredWidth:  30
                     }


                     Text{
                         text:FuncName;
                         wrapMode: Text.WrapAnywhere
                         //选中变色及变大
                         font.pixelSize:wrapper.ListView.isCurrentItem?22:18
                         color:wrapper.ListView.isCurrentItem?"red":"black"
                         Layout.preferredWidth: 450
                     }
                     //是否完成打包
                     Text {
                         text:FuncEnable;
                         //选中变色及变大
                         font.pixelSize:wrapper.ListView.isCurrentItem?22:18;
                         color:wrapper.ListView.isCurrentItem?"red":"black";
                         Layout.preferredWidth: 50;

                     }
                }
            }

        }
        //list表头
        Component{
            id:headerDelegate
            Item{
                id:wrapper
                width:parent.width
                height: 30
                RowLayout{
                    anchors.left: parent.left
                    spacing: 4
                    Text{
                        text:"序号"
                        font.bold: true
                        Layout.preferredWidth:30
                    }
                    Text{
                        text:"系统功能名"
                        font.bold: true
                        Layout.preferredWidth:450
                    }
                    Text{

                        text:"激活"
                        font.bold: true
                        Layout.preferredWidth:50
                    }
                }
            }
        }

        ListView{
            id:listView
            visible: true
            anchors.left:parent.left
            anchors.right:parent.right
            anchors.top: rowManuFunc.bottom
            anchors.bottom: parent.bottom
            header: headerDelegate
            delegate: listDelegate
            model: listModel
            //高量
            highlight: Rectangle{
                color: "yellow"
            }
            //动画效果
            add: Transition{
                ParallelAnimation{
                    //变化透明度
                    NumberAnimation{
                        property: "opacity"
                        from:0
                        to:1
                        duration:500

                    }
                    SpringAnimation{
                        property: "y"
                        spring: 3
                        from:0
                        damping: 0.1
                        epsilon: 0.25

                    }

                }

            }


        }

    }

    //设置窗口
    DlgSetting{
        id:dlgSet
        visible: false
        modality: Qt.WindowModal //模态化
        onAccepted: {
            urlStr=dlgSet.urlStr;	//给网络地址赋值
            //然后传递url给c++
            downloader.urlStr=urlStr;
            console.log(urlStr)
        }
        onRejected: {
            dlgSet.visible=false;
        }
    }

    //选择子系统包
    Plat.FileDialog{
        id:dlgPath
        fileMode: Plat.FileDialog.OpenFiles
        nameFilters: ["子系统包(*.Msixbundle)","所有文件(*.*)"]
        onAccepted: {
            var pathUrl = dlgPath.file;
            txtInputPath.text= getFilePathFromUrl(pathUrl);



        }

    }
    //打开安装包选择安装包路径
    Plat.FileDialog{
        id:dlgApkPath
        fileMode: Plat.FileDialog.OpenFiles
        nameFilters: ["子系统包(*.apk)","所有文件(*.*)"]
        onAccepted: {
            var pathUrl =file;
            txtInstallApk.text=getFilePathFromUrl(pathUrl);

        }

    }
    //提示下载
    Dialog.MessageDialog{
        id:msgDlgDownload
        title: "消息窗口"
        text:"是否要下载aws文件，这个文件有1.2g"
        modality:Qt.WindowModal
        standardButtons: Dialog.StandardButton.Ok | Dialog.StandardButton.Cancel | Dialog.StandardButton.Apply
        onAccepted: {
            console.log("开始下载")
            downloader.start();	//开始下载
            text="好吧"
        }

        onApply:  {
            console.log("确定")
        }
        onRejected: {
            console.log("取消")
            text="好吧"
        }
    }
    //提示完成
    Dialog.MessageDialog{
        id:msgDlgFinished
        text: "下载完成"
        standardButtons: Dialog.StandardButton.Ok
        width: 480
        height:320
        onAccepted: {

        }
    }

    //播放铃声
    SoundEffect{
        id:player
        //source:"res/bird.mp3"
        source:"res/bird.wav"

        volume: 1

    }

    //下载槽
    Connections{
        target:downloader
        onDownloadProgress:{
            console.log("正在下载"+speed)
            //设置网速
            var m_speed = Number(speed).toFixed(2)
            labSpeed.text="下载速度("+m_speed +"Mb/s):";

            progressBarDownload.from=0
            progressBarDownload.to=bytesTotal;
            progressBarDownload.value=bytesRecved;
        }
        //下载完成
        onDownloadFinished:{
            console.log("下载完成")
            msgDlgFinished.open()
            msgDlgFinished.text="下载完成"
            //响铃
            player.play()
        }
        //下载失败
        onDownloadError:{
            console.log("下载失败")
            msgDlgFinished.open()
            msgDlgFinished.text="下载失败"
        }
    }
    //命令执行槽
    Connections{
        target: proc

        onExeSuccess:{
            console.log("命令执行成功")
        }
        onExeFailed:{
            console.log("命令执行失败")
            //发送信号
            msgDlgFinished.open();
            msgDlgFinished.text="执行命令失败,请检测是否以管理员身份运行该程序"
            //关闭进度条的循环滚动
            progBarInstall.indeterminate=false
        }
        //adb连接成功
        onAdbConnectSuccess:{
            msgDlgFinished.open();
            msgDlgFinished.text="adb连接成功"
            indicatorConnect.isConnect=true

        }

        //adb连接成功
        onAdbConnectFailed:{
            msgDlgFinished.open();
            msgDlgFinished.text="adb连接失败，请检查是否开启了子系统"

        }
        onAdbApkInstallF:{
            msgDlgFinished.open();
            msgDlgFinished.text="安装apk失败"
        }
        onAdbApkInstallS:{
            //响铃
            player.play()
            msgDlgFinished.open();
            msgDlgFinished.text="安装apk成功"


        }
        onAdbSubSysInstallS:{

            msgDlgFinished.open();
            msgDlgFinished.text="安装子系统成功"
            //响铃
            player.play()
        }
    }
    //函数 ，url转路径
    function getFilePathFromUrl(iUrl){
        var str =iUrl.toString();
        str=str.replace(/^(file:\/{3})/,"")
        var cleanPath = decodeURIComponent(str);
        console.log(cleanPath)
        return cleanPath;

    }

}
