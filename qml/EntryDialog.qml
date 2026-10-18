import QtQuick 2.14
import QtQuick.Controls 2.14

Dialog {
    id: control
    implicitWidth: 520
    implicitHeight: 280
    x: (appWin.width-width)/2
    y: (appWin.height-height)/2
    z: 2
    closePolicy: Popup.NoAutoClose
    function updateAcceptButton() {
        const okButton = standardButton(Dialog.Ok)
        if (okButton && macEdit)
            okButton.enabled = nameEdit.text.trim().length > 0 && macEdit.acceptableInput
    }
    onOpened: updateAcceptButton()
    onAccepted: {
        msgDlgProps.title = ""
        if (null !== msgDlgProps.acceptCallback) {
            if (-1 === msgDlgProps.callbackArg) {
                msgDlgProps.acceptCallback(nameEdit.text, macEdit.text)
            } else {
                msgDlgProps.acceptCallback(msgDlgProps.callbackArg, nameEdit.text, macEdit.text)
                msgDlgProps.callbackArg = -1
            }
            msgDlgProps.acceptCallback = null
        }
    }
    onRejected: {
        if (null !== msgDlgProps.cancelCallback) {
            msgDlgProps.cancelCallback()
            msgDlgProps.cancelCallback = null
        }
        msgDlgProps.title = ""
        msgDlgProps.acceptCallback = null
        msgDlgProps.callbackArg = -1
    }
    title: msgDlgProps.title
    modal: true
    standardButtons: Dialog.Ok | Dialog.Cancel
    Grid {
        id: dlgGrid
        readonly property int itemWidth: (dlgGrid.width - dlgGrid.columnSpacing) / dlgGrid.columns
        columns: 2
        rows: 2
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            rightMargin: 60
        }
        columnSpacing: Style.horizontalMargin
        rowSpacing: Style.verticalMargin / 2
        Label {
            text: qsTr("Name")
            width: dlgGrid.itemWidth
            height: nameEdit.height
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
            clip: true
            font.pointSize: Style.textPointSize
        }
        TextField {
            id: nameEdit
            width: dlgGrid.itemWidth
            font.pointSize: Style.textPointSize + 2
            horizontalAlignment: Text.AlignHCenter
            placeholderText: qsTr("Friendly name")
            text: deviceList.friendlyName(msgDlgProps.callbackArg)
            maximumLength: 128
            onTextChanged: control.updateAcceptButton()
        }
        Label {
            text: qsTr("MAC Address")
            width: dlgGrid.itemWidth
            height: macEdit.height
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
            clip: true
            font.pointSize: Style.textPointSize
        }
        TextField {
            id: macEdit
            width: dlgGrid.itemWidth
            font.pointSize: Style.textPointSize + 2
            horizontalAlignment: Text.AlignHCenter
            placeholderText: qsTr("hh:hh:hh:hh:hh:hh")
            text: deviceList.macAddress(msgDlgProps.callbackArg)
            maximumLength: 17
            validator: RegularExpressionValidator {
                regularExpression: /^[0-9A-Fa-f]{2}([:-]?[0-9A-Fa-f]{2}){5}$/
            }
            onTextChanged: control.updateAcceptButton()
        }
    }
}
