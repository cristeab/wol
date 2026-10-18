import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14
import QtCore as Core

Item {
    id: settingsPage

    Core.Settings {
        id: storedSettings
        category: "Application"
        property string broadcastAddress: "255.255.255.255"
        property int port: 60000
    }

    function applyNetworkSettings() {
        const valid = deviceList.configureNetwork(storedSettings.broadcastAddress,
                                                   storedSettings.port)
        networkError.text = valid ? "" : qsTr("Enter a valid IPv4 broadcast address and port.")
    }

    Rectangle {
        anchors.fill: parent
        color: "#171a1b"
    }

    ScrollView {
        anchors.fill: parent
        anchors.margins: 28
        clip: true

        Column {
            width: settingsPage.width - 56
            spacing: 24

            Label {
                text: qsTr("Settings")
                color: "#f5f2ec"
                font.bold: true
                font.pixelSize: 28
            }

            Label {
                text: qsTr("Configure how WOL broadcasts packets on your local network.")
                color: "#a8acab"
                font.pixelSize: 14
            }

            Rectangle {
                width: parent.width
                height: networkColumn.height + 40
                radius: 8
                color: "#222728"
                border.color: "#343a3b"

                ColumnLayout {
                    id: networkColumn
                    anchors {
                        left: parent.left
                        right: parent.right
                        top: parent.top
                        margins: 20
                    }
                    spacing: 14

                    Label {
                        text: qsTr("Network")
                        color: "#f5f2ec"
                        font.bold: true
                        font.pixelSize: 17
                    }

                    GridLayout {
                        columns: 2
                        columnSpacing: 20
                        rowSpacing: 10
                        Layout.fillWidth: true

                        Label {
                            text: qsTr("Broadcast address")
                            color: "#c5c8c7"
                        }
                        TextField {
                            id: broadcastField
                            Layout.fillWidth: true
                            text: storedSettings.broadcastAddress
                            placeholderText: "255.255.255.255"
                            onEditingFinished: storedSettings.broadcastAddress = text.trim()
                        }

                        Label {
                            text: qsTr("UDP port")
                            color: "#c5c8c7"
                        }
                        SpinBox {
                            id: portField
                            from: 1
                            to: 65535
                            value: storedSettings.port
                            editable: true
                            onValueModified: storedSettings.port = value
                        }
                    }

                    Label {
                        id: networkError
                        Layout.fillWidth: true
                        color: "#ff8f82"
                        wrapMode: Text.WordWrap
                    }

                    Button {
                        text: qsTr("Apply network settings")
                        Layout.alignment: Qt.AlignRight
                        onClicked: {
                            storedSettings.broadcastAddress = broadcastField.text.trim()
                            storedSettings.port = portField.value
                            applyNetworkSettings()
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: dataColumn.height + 40
                radius: 8
                color: "#222728"
                border.color: "#343a3b"

                ColumnLayout {
                    id: dataColumn
                    anchors {
                        left: parent.left
                        right: parent.right
                        top: parent.top
                        margins: 20
                    }
                    spacing: 10

                    Label {
                        text: qsTr("Device data")
                        color: "#f5f2ec"
                        font.bold: true
                        font.pixelSize: 17
                    }
                    Label {
                        Layout.fillWidth: true
                        text: qsTr("Saved devices are stored automatically on this computer. Manage device names and MAC addresses from the Devices tab.")
                        color: "#a8acab"
                        wrapMode: Text.WordWrap
                    }
                }
            }

            Label {
                text: qsTr("WOL sends a UDP broadcast packet to the configured address and port.")
                color: "#707878"
                font.pixelSize: 12
                wrapMode: Text.WordWrap
            }
        }
    }

    Component.onCompleted: applyNetworkSettings()
}
