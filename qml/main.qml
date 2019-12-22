import QtQuick 2.14
import QtQuick.Controls 2.14
import QtGraphicalEffects 1.12

ApplicationWindow {
    id: appWin
    visible: true
    width: 640
    height: 480

    QtObject {
        id: msgDlgProps
        property string title: ""
        property string text: ""
        property bool okCancel: false
        property var acceptCallback: null
        property var cancelCallback: null
        property int callbackArg: -1
        function showInfo(title, msg) {
            msgDlgProps.acceptCallback = null
            msgDlgProps.cancelCallback = null
            msgDlgProps.callbackArg = -1
            msgDlgProps.title = title
            msgDlgProps.text = msg
            msgDlgLoader.item.visible = true
        }
    }
    Loader {
        id: msgDlgLoader
        active: "" !== msgDlgProps.text
        source: "qrc:/qml/MessageDialog.qml"
    }

    Column {
        id: header
        spacing: Style.verticalMargin
        anchors {
            top: parent.top
            topMargin: Style.verticalMargin
            horizontalCenter: parent.horizontalCenter
        }
        Label {
            id: wolLabel
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("Wake on LAN")
            font {
                bold: true
                pointSize: Style.headerPointSize
            }
        }
        Item {
            anchors.horizontalCenter: wolLabel.horizontalCenter
            height: Style.buttonHeight
            width: height
            Image {
                id: wolImg
                anchors.fill: parent
                source: "qrc:/img/cloud-on-off.svg"
                fillMode: Image.PreserveAspectFit
                mipmap: true
            }
            ColorOverlay {
                id: wolOverlay
                visible: true
                anchors.fill: wolImg
                source: wolImg
                color: Style.buttonPressedColor
            }
        }
    }
    Label {
        visible: 0 === listView.count
        anchors {
            top: header.bottom
            topMargin: Style.verticalMargin
            left: parent.left
            leftMargin: Style.horizontalMargin
            right: parent.right
            rightMargin: Style.horizontalMargin
        }
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        font.pointSize: Style.textPointSize
        text: qsTr("Your MAC address list is empty.\nUse the add button above to add entries in this list.\nPress an item in the list to send a WOL packet.\nIn order to delete a list item swipe left, then press delete.")
    }
    ListView {
        id: listView
        anchors {
            top: header.bottom
            topMargin: Style.verticalMargin
            bottom: parent.bottom
        }
        clip: true
        boundsBehavior: ListView.StopAtBounds
        width: parent.width
        model: deviceList
        delegate: SwipeDelegate {
            id: delegateControl
            property bool blink: false
            width: parent.width
            height: Style.buttonHeight
            Row {
                id: delegateRow
                spacing: Style.horizontalMargin
                anchors {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }
                Label {
                    width: 50
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    text: friendlyName
                    font.pointSize: Style.textPointSize
                    clip: true
                    elide: Text.ElideRight
                    color: delegateControl.blink ? Style.buttonPressedColor : Style.buttonReleasedColor
                }
                Label {
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    text:  macAddress
                    font {
                        italic: true
                        pointSize: Style.textPointSize
                    }
                    clip: true
                    elide: Text.ElideRight
                    color: delegateControl.blink ? Style.buttonPressedColor : Style.buttonReleasedColor
                }
            }
            Rectangle {
                id: contentFrame
                property alias pressed: delegateControl.pressed
                color: "transparent"
                anchors {
                    left: delegateRow.left
                    leftMargin: -Style.horizontalMargin
                    right: delegateRow.right
                    rightMargin: -Style.horizontalMargin
                    verticalCenter: delegateRow.verticalCenter
                }
                height: delegateRow.height + Style.verticalMargin
                z: -1
                radius: 5
                border {
                    width: 1
                    color: contentFrame.pressed ? "lightgray" : "transparent"
                }
            }
            Timer {
                id: wolTimer
                property int count: 0
                interval: 500
                running: false
                triggeredOnStart: true
                repeat: true
                onTriggered: {
                    wolTimer.count += 1
                    if (wolTimer.count > 8) {
                        wolTimer.count = 0
                        wolTimer.running = false
                        delegateControl.blink = false
                    } else {
                        delegateControl.blink = !delegateControl.blink
                    }
                }
            }
            onClicked: {
                wolTimer.running = true
                deviceList.wol(macAddress)
            }
            //swipe gestures handling
            swipe.enabled: true
            ListView.onRemove: SequentialAnimation {
                PropertyAction {
                    target: delegateControl
                    property: "ListView.delayRemove"
                    value: true
                }
                NumberAnimation {
                    target: delegateControl
                    property: "height"
                    to: 0
                    easing.type: Easing.InOutQuad
                }
                PropertyAction {
                    target: delegateControl
                    property: "ListView.delayRemove"
                    value: false
                }
            }
            swipe.right: Rectangle {
                height: parent.height
                width: deleteLabel.width
                anchors.right: parent.right
                color: SwipeDelegate.pressed ? Qt.darker("tomato", 1.1) : "tomato"
                Column {
                    SwipeDelegate.onClicked: {
                        msgDlgProps.acceptCallback = listView.model.remove
                        msgDlgProps.callbackArg = index
                        msgDlgProps.cancelCallback = delegateControl.swipe.close
                        msgDlgProps.title = qsTr("Remove item")
                        msgDlgProps.text = qsTr("Are you sure you want to remove ") + friendlyName + qsTr(" from the list.")
                        msgDlgLoader.item.visible = true
                    }
                    anchors.fill: parent
                    spacing: 0
                    Item {
                        height: 5
                        width: parent.width
                    }
                    Image {
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: parent.height/2 - 6
                        width: height
                        source: "qrc:/img/trash-o.svg"
                        fillMode: Image.PreserveAspectFit
                        mipmap: true
                    }
                    Label {
                        id: deleteLabel
                        text: qsTr("Delete")
                        font.pointSize: Style.textPointSize
                        clip: true
                        elide: Text.ElideRight
                        verticalAlignment: Label.AlignVCenter
                        topPadding: 3
                        leftPadding: 12
                        rightPadding: 12
                    }
                }
            }
        }
    }
}
