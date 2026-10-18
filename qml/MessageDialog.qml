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
        msgDlgProps.text = ""
        if (null !== msgDlgProps.acceptCallback) {
            msgDlgProps.acceptCallback(msgDlgProps.callbackArg)
            msgDlgProps.acceptCallback = null
            msgDlgProps.callbackArg = -1
        }
    }
    onRejected: {
        if (null !== msgDlgProps.cancelCallback) {
            msgDlgProps.cancelCallback()
            msgDlgProps.cancelCallback = null
        }
        msgDlgProps.title = ""
        msgDlgProps.text = ""
        msgDlgProps.acceptCallback = null
        msgDlgProps.callbackArg = -1
    }
    title: msgDlgProps.title
    modal: true
    standardButtons: Dialog.Ok | Dialog.Cancel
    Label {
        id: controlLabel
        text: msgDlgProps.text
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
        elide: Text.ElideRight
        clip: true
        font.pointSize: Style.textPointSize
    }
}
