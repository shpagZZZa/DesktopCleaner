import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4



Button{
    id: deskButton
    height: 30
    width: parent.width / 2 - 10
    font.pixelSize: height / 2 - 5
    //font.family: "Helvetica"

    contentItem: Text {
        text: parent.text
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: parent.font.pixelSize
        font.family: parent.font.styleName
    }

    background: Rectangle {
        radius: 4
        border.color: "black"
        color: parent.checked ? "lightgrey" : "white";
    }
}
