import QtQuick 2.15

ShaderEffect{
    anchors.fill: parent
    mesh:GridMesh{
        resolution: Qt.size(50,50)
    }
    property real topWidth: open?width:20
    property real bottomWidth:topWidth
    property real amplitude:0.1 //幅度
    property bool open:true//打开
    property variant source:effectSource

    //底部是一个弹簧动画
    Behavior on bottomWidth {
        SpringAnimation{
            easing.type: Easing.OutElastic
            velocity: 250
            mass:1.5
            spring: 0.5
            damping: 0.05
        }
    }
    Behavior on topWidth {
        NumberAnimation{
            duration:1000
        }

    }
    ShaderEffectSource{
        id:effectSource
        sourceItem: effectImage
        hideSource: true
    }
    Image{
        id:effectImage
        anchors.fill: parent
        source:"res/fabric.png"
        fillMode: Image.Tile
    }
    vertexShader: "
attribute highp vec4 qt_Vertex;
attribute highp vec2 qt_MultiTexCoord0;
uniform highp mat4 qt_Matrix;
varying highp vec2 qt_TexCoord0;
varying lowp float shade;

uniform highp float topWidth;
uniform highp float bottomWidth;
uniform highp float width;
uniform highp float height;
uniform highp float amplitude;



void main(void)
{
    qt_TexCoord0 = qt_MultiTexCoord0;
    highp vec4 shift= vec4(0.0,0.0,0.0,0.0);
    highp float swing = (topWidth-bottomWidth)*(qt_Vertex.y/height);
    shift.x=qt_Vertex.x*(width-topWidth+swing)/width;

    shade = sin(21.9911486 *qt_Vertex.x/width);
    shift.y=amplitude*(width-topWidth+swing)*shade;

    gl_Position = qt_Matrix *( qt_Vertex-shift);
    shade=0.2*(2.0-shade)*((width-topWidth+swing)/width);
}

"
    fragmentShader: "
uniform sampler2D source;
varying highp vec2 qt_TexCoord0;
varying lowp float shade;

void main(void)
{
    highp vec4 color=texture2D(source,qt_TexCoord0);
    color.rgb *=1.0-shade;
    gl_FragColor = color;
}
"
}

