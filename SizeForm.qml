import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import Qt.labs.platform 1.1

Item{
    id: sizeField
    property string params: "lK0"
    property bool secondParam: false
    property int num1
    property int num2

    function getParams(){
        let result = "";

        if (lessButton.checked)
            result += "l";
        else if (moreButton.checked)
            result += "m";

        if (unit1KB.checked)
            result += "K";
        else if (unit1MB.checked)
            result += "M"

        let num1 = parseInt(firstCondition.text);
        sizeField.num1 = num1;
        result += num1;

        if (secondParam){
            result = result.replace("l", "t");
            result = result.replace("m", "t");
            result += " ";

            let num2 = parseInt(secondCondition.text)
            sizeField.num2 = num2;
            result += num2;

            if (unit2KB.checked)
                result += "K";
            else if (unit2MB.checked)
                result += "M";
        }

        console.log(sizeField.num1, sizeField.num2);
        return result;
    }

    Column{
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
//        width: parent.width

        Row{
            width: parent.width
            spacing: 10

            ButtonGroup{
                id: lessMoreButtonGroup
                buttons: sizeButtons
            }

            Column{
                id: lessMoreButtons
                visible: !sizeField.secondParam

                RadioButton{
                    id: lessButton
                    text: "Меньше"
                    checked: true
                }
                RadioButton{
                    id: moreButton
                    text: "Больше"
                }
            }


            Text{
                text: sizeField.secondParam ? "Больше, чем " : " чем "
                padding: 10
                anchors.verticalCenter: parent.verticalCenter
            }

            TextField{
                id: firstCondition
                width: parent.width / 4
                anchors.verticalCenter: parent.verticalCenter
            }

            ButtonGroup{
                id: sizeButtonGroup
                buttons: sizeButtons
            }

            Column{
                id: sizeButtons

                RadioButton{
                    id: unit1KB
                    text: "KB"
                    checked: true
                }
                RadioButton{
                    id: unit1MB
                    text: "MB"
                }
            }
        }

        Button{
            id: secondParamButton
            x: 10
            visible: !sizeField.secondParam
            onClicked: {
                sizeField.secondParam = true
            }

            text: "Добавить второе условие"
        }

        Row{
            id: secondRow
            width: parent.width
            visible: sizeField.secondParam
            spacing: 10

            Text{
                id: secondConText
                padding: 10
                text: "Меньше, чем "
            }

            TextField{
                id: secondCondition
                width: parent.width / 4
            }

            ButtonGroup{
                id: sizeButtonGroup2
                buttons: sizeButtons
            }

            Column{
                id: sizeButtons2

                RadioButton{
                    id: unit2KB
                    checked: true
                    text: "KB"
                }

                RadioButton{
                    id: unit2MB
                    text: "MB"
                }
            }
        }
    }
}
