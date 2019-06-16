import QtQuick 2.12
import QtQuick.Controls 2.5

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    Column {
        id: header
        spacing: 20
        anchors {
            top: parent.top
            topMargin: 20
            horizontalCenter: parent.horizontalCenter
        }
        Label {
            id: wolLabel
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("Wake on LAN")
            font {
                bold: true
                pointSize: 18
            }
        }
        Image {
            anchors.horizontalCenter: wolLabel.horizontalCenter
            source: "qrc:/img/cloud-on-off.svg"
            fillMode: Image.PreserveAspectFit
            height: 50
            width: height
            mipmap: true
        }
    }
    ListView {
        anchors {
            top: header.bottom
            topMargin: 20
            bottom: parent.bottom
        }
        width: parent.width
        model: deviceList
        delegate: Item {
            width: parent.width
            height: 50
            Row {
                id: delegateRow
                spacing: 10
                anchors {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }
                Label {
                    width: 50
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    text: friendlyName
                    font.pointSize: 14
                }
                Label {
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    text:  macAddress
                    font {
                        italic: true
                        pointSize: 14
                    }
                }
            }
            Rectangle {
                id: contentFrame
                property alias pressed: delegateMouseArea.pressed
                color: "transparent"
                anchors {
                    left: delegateRow.left
                    leftMargin: -10
                    right: delegateRow.right
                    rightMargin: -10
                    verticalCenter: delegateRow.verticalCenter
                }
                height: delegateRow.height + 20
                z: -1
                radius: 5
                border {
                    width: 1
                    color: contentFrame.pressed ? "lightgray" : "transparent"
                }
            }
            MouseArea {
                id: delegateMouseArea
                anchors.fill: parent
                onClicked: deviceList.wol(macAddress)
            }
        }
    }
}
