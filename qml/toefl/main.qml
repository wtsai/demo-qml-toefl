import QtQuick 2.1
import QtQuick.Controls 1.0
import "TOEFL"
import "TOEFL/plugins"

ApplicationWindow {
    id: app
    width: 800
    height: 800
    property int seconds : 0
    property int booting : 0
    //property int delay_interval : 20
    property int delay_interval : 3

    Rectangle {
        color: "#212126"
        anchors.fill: parent
    }

    toolBar: BorderImage {
        border.bottom: 8
        source: "images/toolbar.png"
        width: parent.width
        height: 100

        Rectangle {
            id: backButton
            width: opacity ? 60 : 0
            anchors.left: parent.left
            anchors.leftMargin: 20
            opacity: stackView.depth > 2 ? 1 : 0
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            height: 60
            radius: 4
            color: backmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: "images/navigation_previous_item.png"
            }
            MouseArea {
                id: backmouse
                anchors.fill: parent
                anchors.margins: -10
                onClicked: {
                    //console.log("stackView.depth: " + stackView.depth)
                    if (stackView.depth > 2)
                        stackView.pop()
                }
            }
        }

        Text {
            font.pixelSize: 42
            Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
            x: backButton.x + backButton.width + 20
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            text: "TOEFL quiz (unlimited questions)"
        }
        BusyIndicator {
            id: busyindicator
            scale: 1
            on: seconds <= delay_interval
            anchors { right: parent.right; rightMargin: 10; verticalCenter: parent.verticalCenter }
        }

        Timer {
            interval: 100; running: true; repeat: true;
            onTriggered: {
                seconds++;
                if (seconds == delay_interval+5)
                {
                    stackView.push(Qt.resolvedUrl("TOEFL/InitalPage.qml"));
                }
                if (seconds == delay_interval+5+6)
                {
                    booting = 1;
                }
            }
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent

        initialItem: Item {
            width: parent.width
            height: parent.height
        }
    }


    BorderImage {
        id: description
        border.bottom: 8
        source: "images/toolbar.png"
        anchors.bottom: parent.bottom
        width: parent.width
        height: 200

        Text {
            id: descriptioninner
            font.pixelSize: 42
            Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
            x: 20
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            text: "Blue color means you are correct. \nRed color means you are wrong.\nYou will play the same quiz again."
            visible: true
        }
        MouseArea {
            anchors.fill: description
            onClicked: {
                description.visible = !visible;
                showdescription.visible = true;
            }
        }
    }

    BorderImage {
        id: showdescription
        border.bottom: 8
        source: "images/toolbar.png"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: 20
        height: 200
        visible: false

        MouseArea {
            anchors.fill: showdescription
            onClicked: {
                description.visible = true;
                showdescription.visible = !visible;
            }
        }
    }
}
