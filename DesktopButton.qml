import QtQuick 2.0
import QtQuick.Controls 2.14
import QtQuick.Controls.Styles 1.4



Button{
    id: deskButton
    property int mode
    height: 30
    width: 75
    font.bold: checked
    font.pixelSize: height / 2
    //font.family: "arial"

    contentItem: Text {
        text: parent.text
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.bold: parent.font.bold
        font.pixelSize: parent.font.pixelSize
        font.family: parent.font.styleName
    }

    background: Rectangle {
        radius: 4
        border.color: "black"
        color: parent.checked ? "lightgrey" : "white";
    }
}
