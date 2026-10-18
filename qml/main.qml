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
    title: Qt.application.name
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
        id: titleBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 54
        color: "#202526"
        z: 2

        Label {
            anchors.centerIn: parent
            text: qsTr("WOL")
            color: "#f5f2ec"
            font.bold: true
            font.pixelSize: 17
        }

        Row {
            anchors {
                right: parent.right
                rightMargin: 24
                verticalCenter: parent.verticalCenter
            }
            spacing: 8

            Rectangle {
                width: 9
                height: width
                radius: width / 2
                color: "#35c7bc"
                anchors.verticalCenter: parent.verticalCenter
            }
            Label {
                text: qsTr("LOCAL NETWORK")
                color: "#a8acab"
                font.pixelSize: 11
                font.letterSpacing: 1.1
            }
        }
    }

    Rectangle {
        id: navigationRail
        anchors {
            top: titleBar.bottom
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
    }

    StackLayout {
        anchors {
            top: titleBar.bottom
            left: navigationRail.right
            right: parent.right
            bottom: parent.bottom
        }
        currentIndex: appWin.pageIndex

        Item {
            id: devicesPage
            anchors.fill: parent

    Button {
        id: addButton
        anchors {
            top: parent.top
            topMargin: 5
            left: parent.left
            leftMargin: Style.horizontalMargin
        }
        text: qsTr("Add")
        font.pointSize: Style.textPointSize
        contentItem: Label {
            text: addButton.text
            font: addButton.font
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: Style.buttonPressedColor
            clip: true
        }
        onClicked: msgDlgProps.showEntry(qsTr("Add New Entry"), deviceList.append)
        background: Rectangle {
            radius: 5
            color: addButton.down ? "#269d96" : "#35c7bc"
        }
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
        text: qsTr("Your MAC address list is empty.\nUse the add button above to add entries in this list.\nPress an item in the list to send a WOL packet.\nIn order to edit a list item swipe right, then press edit.\nIn order to delete a list item swipe left, then press delete.")
    }
    ListView {
        id: listView
        readonly property int itemWidth: (listView.width - 2 * Style.horizontalMargin) / 2
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
                spacing: 2 * Style.horizontalMargin
                anchors {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }
                Label {
                    width: listView.itemWidth
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    text: friendlyName
                    font.pointSize: Style.textPointSize
                    clip: true
                    elide: Text.ElideRight
                    color: delegateControl.blink ? Style.buttonPressedColor : Style.buttonReleasedColor
                }
                Label {
                    width: listView.itemWidth
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
                color: SwipeDelegate.pressed ? Qt.darker(Style.swipeRemoveItemColor, 1.1) : Style.swipeRemoveItemColor
                Column {
                    SwipeDelegate.onClicked: {
                        msgDlgProps.showInfo(qsTr("Delete Entry"), qsTr("Are you sure you want to delete ") + friendlyName + qsTr(" from the list."))
                        msgDlgProps.acceptCallback = listView.model.remove
                        msgDlgProps.callbackArg = index
                        msgDlgProps.cancelCallback = delegateControl.swipe.close
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
            swipe.left: Rectangle {
                height: parent.height
                width: editLabel.width
                anchors.left: parent.left
                color: SwipeDelegate.pressed ? Qt.darker(Style.swipeEditItemColor, 1.1) : Style.swipeEditItemColor
                Column {
                    SwipeDelegate.onClicked: {
                        msgDlgProps.showEntry(qsTr("Edit Entry"), deviceList.edit)
                        msgDlgProps.callbackArg = index
                        msgDlgProps.cancelCallback = delegateControl.swipe.close
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
                        id: editLabel
                        text: qsTr("Edit")
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

        Settings { }
        About { }
    }
}
