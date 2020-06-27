import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.14
import DesktopCleaner 1.0
import Qt.labs.platform 1.1
import QtQuick.Dialogs 1.2
//import QtQuick.Controls 2.12

Window {
    id: window
    visible: true
    width: 340
    height: 280

    maximumHeight: height
    maximumWidth: width
    minimumHeight: height
    minimumWidth: width

    title: qsTr("Desktop cleaner")
    property string desktopPath: "C:\\Users\\User\\Desktop"
    property int modeChosen: 0

    DesktopCleaner{
        id: desktopCleaner
    }

    Rectangle{
        id: transitParamsRect
        border.color: "black"
        radius: 4
        y: parent.height * 0.3
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - 10
        height: parent.height * 0.7 - 40
    }

    Loader{
        id: loader
        anchors.fill: transitParamsRect
        source: {
            if(modeChosen == 0)
                return "FormatForm.qml";
            if(modeChosen == 1)
                return "SizeForm.qml";
            if(modeChosen == 2)
                return "NameForm.qml";
        }
    }

    MainButton{
        id: desktopPathButton
        height: 40
        x: 5
        y: 5
        font.pixelSize: height / 3
        text: "Выбрать папку"
        onClicked: folderDialog.open()
    }

    Text {
        id: desktopPathText
        anchors.top: desktopPathButton.bottom
        font.pixelSize: 13
        padding: 10
        text: "Путь до папки: " + desktopPath
    }

    MainButton{
        id: execButton
        height: 40
        x: parent.width - width - 5
        y: 5
        text: "Прибрать в папке"
        onClicked: {
            let params = loader.item.getParams();
            console.log("params: ", params);

            if(window.modeChosen == 1){
                if(isNaN(loader.item.num1) || loader.item.num1 < 0 ||
                   isNaN(loader.item.num2) || loader.item.num2 < 0)
                {
                    errorSizeDialog.open();
                    return;
                }

                if(loader.item.secondParam)
                {
                    let num1 = loader.item.num1;
                    let isKB1 = params[1] === "K";
                    let num2 = loader.item.num2;
                    let isKB2 = params[params.length - 1] === "K";

                    if(isKB1 && isKB2 && num1 > num2 ||
                       isKB1 && !isKB2 && num1 > num2 * 1024 ||
                       !isKB1 && isKB2 && num1 * 1024 > num2 ||
                       !isKB1 && !isKB2 && num1 > num2)
                    {
                        incorrectValueDialog.open();
                        return;
                    }
                }

            }

            desktopCleaner.executeTransition(params);
            console.log("fm: ", desktopCleaner.filesMoved);
            resultDialog.open();
        }
    }

    ButtonGroup{
        id: buttonGroup
        buttons: buttonRow.children
        onClicked: {
                    window.modeChosen = button.mode;
                    desktopCleaner.setMode(button.mode);
                    button.checked = true;
                }
    }

    Row{
        id: buttonRow
        padding: 5
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        spacing: 5

        DesktopButton{
            text: "Расширение"
            font.pixelSize: height / 3
            checked: true
            mode: 0
        }

        DesktopButton{
            text: "Размер"
            mode: 1
        }

        DesktopButton{
            text: "Имя"
            mode: 2
        }
    }


    FolderDialog{
        id: folderDialog
        onAccepted: desktopPathDialog.open()
    }

    Dialog{
        id: desktopPathDialog
        title: "Подтвердить"
        Text{
            text: "Вы уверены, что ваша папка  " + folderDialog.folder.toString().substring(8) + "?"
        }
        standardButtons: StandardButton.No | StandardButton.Yes

        onYes: {
            desktopPath = folderDialog.folder.toString().substring(8);
            console.log(desktopPath)
            desktopCleaner.setDesktopPath(desktopPath);
        }
    }

    Dialog{
        id: resultDialog
        title: "Результат"

        BusyIndicator{
            id: busyIndicator
            running: desktopCleaner.isProcessing
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            //text: "Перемещены " + desktopCleaner.filesMoved + " файла(-ов) в папки " + desktopCleaner.message
            text: "Файлы перемещены!"
        }
    }

    Dialog{
        id: errorSizeDialog
        title: "Ошибка"
        Text {
            text: "Введённый текст должен быть целым числом!"
        }

        //buttons: StandardButton.OK
    }

    Dialog{
        id: incorrectValueDialog
        title: "Ошибка"
        Text {
            text: "Некорректные значения!"
        }
    }
}
