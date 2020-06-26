import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12

Item {
    id: formatField
    property string params

    function getParams(){
        return textField.text;
    }

    Column{
        id: comboBoxColumn
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 15
        width: parent.width - 10

        Row{
            height: formatField.height / 2
            width: formatField.width
            spacing: 5

            Text{
                padding: 10
                id: comboBoxText
                anchors.verticalCenter: comboBox.verticalCenter
                text: "Выбрать расширение"
            }

            ComboBox{
                padding: 10
                id: comboBox
                displayText: currentIndex != 0 ? model[currentIndex].text : "расширение"
                onCurrentIndexChanged: {
                    if (currentIndex != 0)
                        textField.text += model[currentIndex].text + " "
                }

                background: Rectangle{
                    anchors.fill: comboBox
                    implicitWidth: comboBoxColumn.width / 2
                    radius: 4
                    border.color: "black"
                    color: "white"
                }

                model: [
                    { text: "choose file format", enabled: false },
                    { text: "txt", enabled: true },
                    { text: "docx", enabled: true },
                    { text: "pdf", enabled: true },
                    { text: "png", enabled: true },
                    { text: "jpg", enabled: true },
                    { text: "jpeg", enabled: true },
                    { text: "mp3", enabled: true },
                    { text: "mp4", enabled: true }
                ]


                delegate: ItemDelegate {
                    width: parent.width
                    text: modelData.text
                    font.weight: parent.currentIndex === index ? Font.DemiBold : Font.Normal
                    highlighted: ListView.isCurrentItem
                    enabled: modelData.enabled
                }
            }
        }


        Row{
            id: textFieldColumn
            x: parent.x + comboBoxColumn.width + 5
            spacing: 5
            width: formatField.width
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                id: textFieldLabel
                padding: 10
                text: "Вы также можете напечатать"
            }

            TextField{
                id: textField
                padding: 10
                rightPadding: 0
                text: formatField.params
                width: parent.width - textFieldLabel.width - 25

                background: Rectangle{
                    implicitWidth: textField.width
                    radius: 4
                    border.color: "black"
                    color: "white"
                }
            }
        }
    }
}
