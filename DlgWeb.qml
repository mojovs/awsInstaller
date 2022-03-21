import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtWebEngine 1.10
import QtQuick.Dialogs 1.3

Dialog{
    id:root
    title:"爬取子系统安装包下载地址"
    width: 640
    height: 480
    property var productKey:"9p3395vx91nr";
    property var url: ""
    signal sendUrl(string url)
    //工具栏
    RowLayout{
        id:rowControl
        anchors.left:parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        //前进
        Button{
            id:btnBack
            text:"后退"
            Layout.leftMargin: 8
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft
            onClicked: {
                if(webView.canGoBack)
                {
                    webView.goBack()
                }
            }

        }
        //前进
        Button{
            id:btnForward
            text:"前进"
            Layout.leftMargin: 8
            Layout.rightMargin: 8
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft
            onClicked: {
                if(webView.canGoForward)
                {
                    webView.goForward()
                }
            }

        }
        Button{
             id:btnReload
            text:"刷新"
            Layout.leftMargin: 8
            Layout.rightMargin: 8
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft
            onClicked: {
                webView.reload();
            }
        }
        Button{
            id:btnGetUrl
            text:"获取下载地址"
            Layout.leftMargin: 8
            Layout.rightMargin: 8
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft

            //自定义按钮
            background: Rectangle{
                anchors.fill: parent
                border.width: 3
                border.color:"firebrick"
                color:parent.pressed?"gray":"white"
                //设置边缘闪烁
                ColorAnimation {
                    id:animBtn
                    loops: Animation.Infinite
                    target: parent.border.color
                    from: "white"
                    to: "firebrick"
                    duration: 200
                }
            }
            onClicked: {
                getUrl();

            }
        }
    }

    WebEngineView{
        id:webView
        anchors.top: rowControl.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        url:"https://store.rg-adguard.net/"
        onLoadProgressChanged: {
            if(webView.loadProgress == 100){
                console.log("Load Completed !");
                //构造javascript语句
               var js1= "document.getElementById(\"type\").selectedIndex=1;";
               var js2="document.getElementById(\"url\").value=\""+productKey+"\";";
               var js3= "document.getElementById(\"ring\").selectedIndex=0;";

               var jsClick="document.querySelector(\"input[title=\"Generate temporary links\"]\").click();";
                //开始执行js,设置初始化任务
               webView.runJavaScript(js1+js2+js3,function(result){console.log("JSRES:"+result);});
                //开始提交获取下载地址
               var jsClick="document.querySelector('input[title^=Generate]').click()";
               webView.runJavaScript(jsClick,function(result){console.log("JSRES:"+result);});
             }
        }

        onJavaScriptConsoleMessage: {
            console.log(message)
        }


    }

    function getUrl()
    {
        //执行不成功
        if(webView.loadProgress != 100)
        {
            console.log("没有加载成功")
            return null;
        }
        //获取地址
        var js1="var a =document.querySelectorAll('a');
            var length=a.length;
            a[length-1].href;
"
        //运行程序，并且把这个url地址给传递出去
        webView.runJavaScript(js1,function(result){
            console.log("JSRES:"+result);

            url=result;	//传递出地址
            sendUrl(url);	//发送信号出去

        });
    }






}
