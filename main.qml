import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1 as Plat
import QtQuick.Dialogs 1.3 as Dialog

Window {
    id:root
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")
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
            implicitWidth: 250
            selectByMouse: true
            //anchors.left: labChoosePath.right;
            text: "选择"
        }
        Button{
            id:btnChoosePath
            text: "选择路径"
            onClicked: {
                dlgPath.open();
            }
        }
    }


    Plat.FileDialog{
        id:dlgPath
        fileMode: Plat.FileDialog.OpenFiles
        nameFilters: ["apk应用(*.apk)","所有文件(*.*)"]
        onAccepted: {

            var pathUrl = dlgPath.file;
            txtInputPath.text=pathUrl.toString()

        }

    }
    //提示下载
    Dialog.MessageDialog{
        id:msgDlgDownload
        visible: false
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
        visible: false
        text: "下载完成"
        standardButtons: Dialog.StandardButton.Ok
        onAccepted: {

        }
    }

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
            msgDlgDownload.open();
        }
    }






}
