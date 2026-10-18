import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14

ApplicationWindow {
    id: appWin
    visible: true
    width: 960
    height: 640
    minimumWidth: 760
    minimumHeight: 520
    color: "#171a1b"
    title: Qt.application.name + " " + Qt.application.version
    property int pageIndex: 0

    Component.onCompleted: {
        if (Style.isIOs) {
            appWin.flags = Qt.MaximizeUsingFullscreenGeometryHint
        } else if (Style.isMacOs) {
            appWin.width = 960
            appWin.height = 640
        }
    }

    QtObject {
        id: msgDlgProps
        property string title: ""
        property string text: ""
        property bool okCancel: false
        property var acceptCallback: null
        property var cancelCallback: null
        property int callbackArg: -1
        function showInfo(title, msg) {
            msgDlgProps.title = title
            msgDlgProps.text = msg
            msgDlgProps.acceptCallback = null
            msgDlgProps.cancelCallback = null
            msgDlgProps.callbackArg = -1
            msgDlgLoader.item.visible = true
        }
        function showEntry(title, cbk) {
            msgDlgProps.title = title
            msgDlgProps.acceptCallback = cbk
            msgDlgProps.cancelCallback = null
            msgDlgProps.callbackArg = -1
            entryDlgLoader.active = true
            entryDlgLoader.item.visible = true
        }
    }
    Loader {
        id: msgDlgLoader
        active: "" !== msgDlgProps.text
        source: "qrc:/qml/MessageDialog.qml"
    }

    Loader {
        id: entryDlgLoader
        active: false
        source: "qrc:/qml/EntryDialog.qml"
        z: 10
    }

    Rectangle {
        id: navigationRail
        anchors {
            top: parent.top
            left: parent.left
            bottom: parent.bottom
        }
        width: 190
        color: "#202526"
        z: 1

        Column {
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 18
            }
            spacing: 8

            Label {
                text: qsTr("WAKE ON LAN")
                color: "#707878"
                font.pixelSize: 10
                font.letterSpacing: 1.2
                leftPadding: 12
                bottomPadding: 8
            }

            Button {
                id: devicesNav
                width: parent.width
                height: 44
                text: qsTr("Devices")
                onClicked: appWin.pageIndex = 0
                contentItem: Label {
                    text: devicesNav.text
                    color: appWin.pageIndex === 0 ? "#f5f2ec" : "#a8acab"
                    font.pixelSize: 14
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 18
                }
                background: Rectangle {
                    radius: 6
                    color: appWin.pageIndex === 0 ? "#343b3c" : "transparent"
                    Rectangle {
                        visible: appWin.pageIndex === 0
                        width: 3
                        radius: 2
                        anchors {
                            left: parent.left
                            top: parent.top
                            bottom: parent.bottom
                        }
                        color: "#35c7bc"
                    }
                }
            }

            Button {
                id: settingsNav
                width: parent.width
                height: 44
                text: qsTr("Settings")
                onClicked: appWin.pageIndex = 1
                contentItem: Label {
                    text: settingsNav.text
                    color: appWin.pageIndex === 1 ? "#f5f2ec" : "#a8acab"
                    font.pixelSize: 14
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 18
                }
                background: Rectangle {
                    radius: 6
                    color: appWin.pageIndex === 1 ? "#343b3c" : "transparent"
                    Rectangle {
                        visible: appWin.pageIndex === 1
                        width: 3
                        radius: 2
                        anchors {
                            left: parent.left
                            top: parent.top
                            bottom: parent.bottom
                        }
                        color: "#35c7bc"
                    }
                }
            }

            Button {
                id: aboutNav
                width: parent.width
                height: 44
                text: qsTr("About")
                onClicked: appWin.pageIndex = 2
                contentItem: Label {
                    text: aboutNav.text
                    color: appWin.pageIndex === 2 ? "#f5f2ec" : "#a8acab"
                    font.pixelSize: 14
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 18
                }
                background: Rectangle {
                    radius: 6
                    color: appWin.pageIndex === 2 ? "#343b3c" : "transparent"
                    Rectangle {
                        visible: appWin.pageIndex === 2
                        width: 3
                        radius: 2
                        anchors {
                            left: parent.left
                            top: parent.top
                            bottom: parent.bottom
                        }
                        color: "#35c7bc"
                    }
                }
            }
        }

        Rectangle {
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                leftMargin: 12
                rightMargin: 12
            }
            height: 1
            color: "#343a3b"
        }

        Row {
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                margins: 24
            }
            spacing: 9

            Rectangle {
                width: 9
                height: width
                radius: width / 2
                color: "#35c7bc"
                anchors.verticalCenter: parent.verticalCenter
            }
            Label {
                text: qsTr("Ready to broadcast")
                color: "#8d9494"
                font.pixelSize: 12
            }
        }
    }

    StackLayout {
        anchors {
            top: parent.top
            left: navigationRail.right
            right: parent.right
            bottom: parent.bottom
        }
        currentIndex: appWin.pageIndex

        Item {
            id: devicesPage
            Layout.fillWidth: true
            Layout.fillHeight: true

    Button {
        id: addButton
        anchors {
            top: parent.top
            topMargin: 24
            right: parent.right
            rightMargin: 32
        }
        width: 132
        height: 40
        text: qsTr("+  Add device")
        font.pixelSize: 14
        contentItem: Label {
            text: addButton.text
            font: addButton.font
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: "#f5f2ec"
            clip: true
        }
        onClicked: msgDlgProps.showEntry(qsTr("Add New Entry"), deviceList.append)
        background: Rectangle {
            radius: 5
            color: addButton.down ? "#2aaba2" : "transparent"
            border.width: 1
            border.color: addButton.down ? "#35c7bc" : "#4c5555"
        }
    }

    Rectangle {
        id: pageHeader
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: 118
        color: "transparent"

        Label {
            id: pageTitle
            anchors {
                left: parent.left
                leftMargin: 32
                top: parent.top
                topMargin: 28
            }
            text: qsTr("Saved devices")
            color: "#f5f2ec"
            font.bold: true
            font.pixelSize: 30
        }

        Label {
            anchors {
                left: pageTitle.left
                top: pageTitle.bottom
                topMargin: 6
            }
            text: qsTr("Select a device to send a Wake-on-LAN packet.")
            color: "#8d9494"
            font.pixelSize: 13
        }

        Rectangle {
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                leftMargin: 32
                rightMargin: 32
            }
            height: 1
            color: "#343a3b"
        }
    }
    Label {
        visible: 0 === listView.count
        anchors {
            top: pageHeader.bottom
            topMargin: 64
            left: parent.left
            leftMargin: 32
            right: parent.right
            rightMargin: 32
        }
        color: "#8d9494"
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        font.pixelSize: 14
        text: qsTr("No saved devices yet.\nUse Add device to create your first entry.")
    }
    ListView {
        id: listView
        anchors {
            top: pageHeader.bottom
            topMargin: 18
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            leftMargin: 24
            rightMargin: 24
        }
        clip: true
        boundsBehavior: ListView.StopAtBounds
        model: deviceList
        delegate: SwipeDelegate {
            id: delegateControl
            property bool blink: false
            property bool broadcasting: false
            width: listView.width
            height: 78

            function wakeDevice() {
                broadcastAnimation.restart()
                broadcasting = true
                wolTimer.running = true
                deviceList.wol(macAddress)
            }

            background: Rectangle {
                radius: 6
                color: delegateControl.pressed ? "#2c3535" : "transparent"
                border.width: delegateControl.pressed ? 1 : 0
                border.color: "#35c7bc"
            }

            Column {
                id: delegateRow
                anchors {
                    left: parent.left
                    leftMargin: 22
                    verticalCenter: parent.verticalCenter
                }
                Label {
                    text: friendlyName
                    color: delegateControl.blink ? "#35c7bc" : "#f5f2ec"
                    font.pixelSize: 16
                    clip: true
                    elide: Text.ElideRight
                    width: Math.min(420, listView.width - 150)
                }
                Label {
                    text: macAddress
                    color: "#8d9494"
                    font {
                        family: "Courier New"
                        pixelSize: 12
                    }
                    clip: true
                    elide: Text.ElideRight
                }
            }
            Rectangle {
                id: contentFrame
                property alias pressed: delegateControl.pressed
                color: "transparent"
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: delegateRow.verticalCenter
                }
                height: parent.height
                z: -1
            }

            Button {
                id: wakeButton
                anchors {
                    right: parent.right
                    rightMargin: 22
                    verticalCenter: parent.verticalCenter
                }
                width: 50
                height: 50
                onClicked: delegateControl.wakeDevice()
                background: Rectangle {
                    radius: width / 2
                    color: wakeButton.down ? "#2aaba2" : "#35c7bc"
                }
                contentItem: Item {
                    id: broadcastIconContainer
                    anchors.fill: parent
                    anchors.margins: 12

                    Image {
                        anchors.fill: parent
                        source: "qrc:/img/broadcast.svg"
                        fillMode: Image.PreserveAspectFit
                        mipmap: true
                    }
                    Image {
                        anchors.fill: parent
                        source: "qrc:/img/broadcast-active.svg"
                        fillMode: Image.PreserveAspectFit
                        mipmap: true
                        opacity: delegateControl.broadcasting ? 1 : 0
                        Behavior on opacity {
                            NumberAnimation { duration: 120 }
                        }
                    }
                }
                ToolTip.visible: hovered
                ToolTip.text: qsTr("Wake device")
            }
            SequentialAnimation {
                id: broadcastAnimation
                loops: 3
                NumberAnimation {
                    target: broadcastIconContainer
                    property: "scale"
                    to: 1.2
                    duration: 500
                    easing.type: Easing.OutCubic
                }
                NumberAnimation {
                    target: broadcastIconContainer
                    property: "scale"
                    to: 1.0
                    duration: 500
                    easing.type: Easing.InOutCubic
                }
                onStopped: delegateControl.broadcasting = false
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
                delegateControl.wakeDevice()
            }
            swipe.enabled: false

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton
                onClicked: contextMenu.popup()
            }

            Menu {
                id: contextMenu
                title: friendlyName

                MenuItem {
                    text: qsTr("Edit %1").arg(friendlyName)
                    onTriggered: {
                        msgDlgProps.showEntry(qsTr("Edit Device"), deviceList.edit)
                        msgDlgProps.callbackArg = index
                    }
                }
                MenuItem {
                    text: qsTr("Remove %1").arg(friendlyName)
                    onTriggered: {
                        msgDlgProps.showInfo(qsTr("Remove Device"),
                                             qsTr("Are you sure you want to remove ") + friendlyName + qsTr(" from the list?"))
                        msgDlgProps.acceptCallback = deviceList.remove
                        msgDlgProps.callbackArg = index
                    }
                }
            }
        }
    }
        }

        Settings { }
        About { }
    }
}
