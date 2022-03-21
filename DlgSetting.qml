import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs 1.3

Dialog{
    id:root
    width:480
    height:320
    title:"设置界面"
    standardButtons: StandardButton.Ok | StandardButton.Cancel
    property alias urlStr:txtUrl.text;    //设置网址行
    RowLayout{
        id:rowUrl
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top:parent.top
        //标签
        Text{
            text:"设置url"
        }
        //输入
        TextField{
            id:txtUrl
            implicitWidth: 250

            text: urlStr
            background: Rectangle{
                radius: 4
                border.width: 1
                border.color:"gray"

            }

        }

    }

}
