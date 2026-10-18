import QtQuick 2.14
import QtQuick.Controls 2.14

Item {
    Rectangle {
        anchors.fill: parent
        color: "#171a1b"
    }

    Column {
        anchors.centerIn: parent
        width: Math.min(parent.width - 80, 560)
        spacing: 18

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("WOL")
            color: "#f5f2ec"
            font.bold: true
            font.pixelSize: 40
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Wake on LAN")
            color: "#35c7bc"
            font.pixelSize: 18
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 64
            height: 2
            color: "#35c7bc"
        }

        Label {
            width: parent.width
            text: qsTr("A small, focused utility for waking computers on your local network.")
            color: "#c5c8c7"
            font.pixelSize: 15
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Version 1.0")
            color: "#707878"
            font.pixelSize: 12
        }

        Label {
            width: parent.width
            topPadding: 18
            text: qsTr("Packets are sent as UDP broadcasts to the network address configured in Settings. Device entries are stored locally on this computer.")
            color: "#8d9494"
            font.pixelSize: 13
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }
    }
}
