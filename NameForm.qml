import QtQuick 2.13
import QtQuick.Controls 2.14
import QtQuick.Window 2.13
import Qt.labs.platform 1.1

Item{
    id: nameField
    property string params

    function getParams(){
        return textField.text;
    }

    Column{
        anchors.fill: nameField
        spacing: 10
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - 20
        x: 23

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            id: names
            padding: 10
            text:
"Введите символы\\слова\\словосочетания с
символом '%' в качестве разделителя.
Файлы с введёнными параметрами в названии
будут структуризированны."
        }

        TextField{
            anchors.horizontalCenter: parent.horizontalCenter
            id: textField
        }
    }
}
