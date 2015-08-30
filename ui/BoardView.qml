import QtQuick 2.2
import QtQuick.Layouts 1.1
import MonsterWars 1.0
import Ubuntu.Components 1.1

Item {
    id: root
    property var board
    property real nodeDistance: background.width / board.columns

    PointView {
        id: pointView
        width: root.width
        height: root.height / 25
        anchors.top: root.top
        anchors.horizontalCenter: root.horizontalCenter
        players: board.players
    }

    Rectangle {
        id: background
        width: root.width
        height: root.height - pointView.height
        anchors.top: pointView.bottom
        anchors.horizontalCenter: root.horizontalCenter
        color: "black"

        Repeater {
            id: monsterRepeater
            model: board.monsters
            delegate: MonsterItem {
                monster: model
                nodeDistance: root.nodeDistance
                pressed: boardArea.pressed
            }
        }

        MouseArea {
            id: boardArea
            anchors.fill: parent
            onPressed: board.resetSelections()
            onReleased: {
                for (var i = 0; i < board.monsterCount; i ++){
                    var monsterItem = monsterRepeater.itemAt(i)
                    var dx = (monsterItem.x + monsterItem.width / 2) - boardArea.mouseX
                    var dy = (monsterItem.y + monsterItem.width / 2) - boardArea.mouseY
                    var l = Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2)) - monsterItem.width / 2 - nodeDistance
                    if (l < nodeDistance) {
                        board.evaluateReleased(monsterItem.monster.id)
                    }
                }
                board.resetSelections()
            }

            onMouseXChanged: updateMouseLogic()
            onMouseYChanged: updateMouseLogic()

            function updateMouseLogic() {
                for (var i = 0; i < board.monsterCount; i ++){
                    var monsterItem = monsterRepeater.itemAt(i)
                    var dx = (monsterItem.x + monsterItem.width / 2) - boardArea.mouseX
                    var dy = (monsterItem.y + monsterItem.width / 2) - boardArea.mouseY
                    var l = Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2)) - monsterItem.width / 2 - nodeDistance
                    if (l < nodeDistance) {
                        board.evaluateHovered(true, monsterItem.monster.id);
                    } else {
                        board.evaluateHovered(false, monsterItem.monster.id);
                    }
                }
            }
        }

        Rectangle {
            id: pauseButton
            anchors.left: parent.left
            anchors.leftMargin: units.gu(2)
            anchors.bottom: parent.bottom
            anchors.bottomMargin: units.gu(2)
            width: units.gu(5)
            height: units.gu(5)
            color: pauseButtonMouseArea.pressed ? "steelblue" : "white"
            radius: units.gu(1)

            MouseArea {
                id: pauseButtonMouseArea
                anchors.fill: pauseButton
                onClicked: {
                    pauseMenu.visible = true
                    gameEngine.pauseGame()
                }
            }
        }

        SelectorItem {
            id: selectorItem
            nodeDistance: root.nodeDistance
            pressed: boardArea.pressed
            x: boardArea.mouseX - root.nodeDistance * 2.5
            y: boardArea.mouseY - root.nodeDistance * 2.5
            visible: boardArea.pressed

            Repeater {
                id: selectorLineRepeater
                model: board.monsters
                delegate: Canvas {

                }
            }
        }

        PauseMenu {
            id: pauseMenu
            anchors.fill: parent
        }
    }
}
