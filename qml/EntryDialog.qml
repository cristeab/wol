import QtQuick 2.14
import QtQuick.Controls 2.14

Dialog {
    id: control
    implicitWidth: Style.dialogWidth
    implicitHeight: Style.dialogHeight
    x: (appWin.width-width)/2
    y: (appWin.height-height)/2
    z: 2
    closePolicy: Popup.NoAutoClose
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
            font.pointSize: Style.textPointSize
            placeholderText: qsTr("Friendly name")
            text: deviceList.friendlyName(msgDlgProps.callbackArg)
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
            font.pointSize: Style.textPointSize
            placeholderText: qsTr("hh:hh:hh:hh:hh:hh")
            text: deviceList.macAddress(msgDlgProps.callbackArg)
        }
    }
}
