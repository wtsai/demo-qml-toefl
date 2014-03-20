import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import "plugins"
import "plugins/quizlist.js" as JS


Rectangle {
    id: container
    width: 500; height: 400;
    color: "#212126";
    property string status: 'correct';

    Component.onCompleted: {
        JS.load();
    }

    // The model:
    ListModel {
        id: quizModel
    }

    // The delegate for each fruit in the model:
    Component {
        id: listDelegate
        Item {
            id: delegateItem
            width: listView.width; height: listView.height
            clip: true

            Column {
                id: question
                anchors {
                    left: parent.left
                    horizontalCenter: parent.horizontalCenter
                }
                Text {
                    text: English
                    width: parent.width
                    wrapMode: Text.WordWrap
                    font.pixelSize: 60
                    color: "white"
                }
            }

            Column {
                id: choiceA
                anchors {
                    top: question.bottom
                    topMargin: 80
                    horizontalCenter: parent.horizontalCenter
                }
                states:[
                    State {
                        name: "correct"
                        PropertyChanges { target: correctA; visible: true; anchors.margins: -4; }
                    },
                    State {
                        name: "error"
                        PropertyChanges { target: errorA; visible: true; anchors.margins: -4;}
                    }
                ]
                Button {
                    Rectangle {
                        anchors.fill: parent
                        color: "#11ffffff"
                        visible: mouseA.pressed
                    }
                    BorderImage {
                        id: correctA
                        anchors.fill: parent
                        source:  "../images/button_pressed.png"
                        border.bottom: 8
                        border.top: 8
                        border.left: 8
                        border.right: 8
                        anchors.margins: 0
                        visible: false
                    }
                    BorderImage {
                        id: errorA
                        anchors.fill: parent
                        source:  "../images/button_error.png"
                        border.bottom: 8
                        border.top: 8
                        border.left: 8
                        border.right: 8
                        anchors.margins: 0
                        visible: false
                    }

                    style: ButtonStyle {
                        background: Item {
                            implicitWidth: listView.width
                            implicitHeight: 75

                            BorderImage {
                                id: imgA
                                width: listView.width
                                height: 80
                                smooth: true // need antialising
                                source:  "../images/button_default.png"
                            }
                        }
                    }
                    Text {
                        text: OptionA
                        anchors.left: parent.left
                        color: "white"
                        font.pixelSize: 60
                        renderType: Text.NativeRendering
                        wrapMode: Text.WordWrap
                    }
                    MouseArea {
                        id: mouseA
                        anchors.fill: parent
                        onClicked: {
                            if (Answer == "OptionA")
                            {
                                console.log("choiceA Correct.")
                                choiceA.state = 'correct';
                                status = 'correct';
                                seconds = delay_interval+5+1;
                            }
                            else
                            {
                                console.log("choiceA Wrong.")
                                choiceA.state = 'error';
                                status = 'error';
                                seconds = delay_interval+5+1;
                            }
                        }
                    }
                }
            }

            Column {
                id: choiceB
                anchors {
                    top: choiceA.bottom
                    topMargin: 80
                    horizontalCenter: parent.horizontalCenter
                }
                states:[
                    State {
                        name: "correct"
                        PropertyChanges { target: correctB; visible: true; anchors.margins: -4;}
                    },
                    State {
                        name: "error"
                        PropertyChanges { target: errorB; visible: true; anchors.margins: -4;}
                    }
                ]
                Button {
                    Rectangle {
                        anchors.fill: parent
                        color: "#11ffffff"
                        visible: mouseB.pressed
                    }
                    BorderImage {
                        id: correctB
                        anchors.fill: parent
                        source:  "../images/button_pressed.png"
                        border.bottom: 8
                        border.top: 8
                        border.left: 8
                        border.right: 8
                        anchors.margins: 0
                        visible: false
                    }
                    BorderImage {
                        id: errorB
                        anchors.fill: parent
                        source:  "../images/button_error.png"
                        border.bottom: 8
                        border.top: 8
                        border.left: 8
                        border.right: 8
                        anchors.margins: 0
                        visible: false
                    }

                    style: ButtonStyle {
                        background: Item {
                            implicitWidth: listView.width
                            implicitHeight: 75

                            BorderImage {
                                id: imgB
                                width: listView.width
                                height: 80
                                smooth: true // need antialising
                                border.bottom: 8
                                border.top: 8
                                border.left: 8
                                border.right: 8
                                anchors.margins: control.pressed ? -4 : 0
                                source: control.pressed ? "../images/button_pressed.png" : "../images/button_default.png"
                            }
                        }
                    }
                    Text {
                        text: OptionB
                        anchors.left: parent.left
                        color: "white"
                        font.pixelSize: 60
                        renderType: Text.NativeRendering
                        wrapMode: Text.WordWrap
                    }
                    MouseArea {
                        id: mouseB
                        anchors.fill: parent
                        onClicked: {
                            if (Answer == "OptionB")
                            {
                                console.log("choiceB Correct.")
                                choiceB.state = 'correct';
                                status = 'correct';
                                seconds = delay_interval+5+1;
                            }
                            else
                            {
                                console.log("choiceB Wrong.")
                                choiceB.state = 'error';
                                status = 'error';
                                seconds = delay_interval+5+1;
                            }
                        }
                    }
                }
            }

            // Animate adding and removing of items:
            //ListView.onAdd: SequentialAnimation {
                //PropertyAction { target: delegateItem; property: "height"; value: 0 }
                //NumberAnimation { target: delegateItem; property: "height"; to: 80; duration: 250; easing.type: Easing.InOutQuad }
            //}

            ListView.onRemove: SequentialAnimation {
                PropertyAction { target: delegateItem; property: "ListView.delayRemove"; value: true }
                NumberAnimation { target: delegateItem; property: "height"; from: 0; to: 0; duration: 200;  }

                // Make sure delayRemove is set back to false so that the item can be destroyed
                PropertyAction { target: delegateItem; property: "ListView.delayRemove"; value: false }
            }
        }
    }

    Timer {
        interval: 100; running: true; repeat: true;
        onTriggered: {
            if ((seconds == delay_interval+5+5) && (booting == 1))
            {
                quizModel.clear();
                JS.loaded(status);
            }
        }
    }

    // The view:
    ListView {
        id: listView
        anchors {
            left: parent.left; top: parent.top;
            right: parent.right; bottom: buttons.top;
            margins: 20
        }
        model: quizModel
        delegate: listDelegate
    }

    Row {
        id: buttons
        anchors { left: parent.left; bottom: parent.bottom; margins: 20 }
        spacing: 10
    }
}
