import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1 as Plat
import QtQuick.Dialogs 1.3 as Dialog

ApplicationWindow {
    id:root
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")
    //菜单栏
    menuBar: MenuBar{
        Menu{
            title: "设置"

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
            flat: true
            text:"下载安装包"
            //点击
            onClicked: {

                msgDlgDownload.open();
                msgDlgDownload.visible=true;
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
        }
        Button{
            id:btnChoosePath
            text: "选择路径"
            flat:true
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
            flat: true
            text:"安装子系统"
            //点击
            onClicked: {
                progBarInstall.indeterminate=true
                proc.installSubSystem();
            }

            ToolTip{
                text: "安装子系统到系统"
                visible: btnInstall.hovered
            }
        }

    }
    //给系统安装package行
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
            flat: true
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
            flat: true
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
            flat: true
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

    //打开安装包选择安装包路径
    Plat.FileDialog{
        id:dlgPath
        fileMode: Plat.FileDialog.OpenFiles
        nameFilters: ["apk应用(*.Msixbundle)","所有文件(*.*)"]
        onAccepted: {

            var pathUrl = dlgPath.file;
            txtInputPath.text=pathUrl.toString()


        }

    }
    //提示下载
    Dialog.MessageDialog{
        id:msgDlgDownload
        visible:false
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
        visible:false
        text: "下载完成"
        standardButtons: Dialog.StandardButton.Ok
        width: 480
        height:320
        onAccepted: {

        }
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
        onDownloadFinished:{
            console.log("下载完成")
            progBarInstall.indeterminate = false;
            msgDlgFinished.open()
            msgDlgFinished.text="下载完成"
            msgDlgFinished.visible=true;
        }
    }
    //命令执行槽
    Connections{
        target: proc
        onExeSuccess:{
            console.log("命令执行成功")
            msgDlgFinished.open();
            msgDlgFinished.text="执行命令成功"
            msgDlgFinished.visible=true;
        }
        onExeFailed:{

            console.log("命令执行失败")
            msgDlgFinished.open();
            msgDlgFinished.text="执行命令失败"
            msgDlgFinished.visible=true;
        }
    }







}
