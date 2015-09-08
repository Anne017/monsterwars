import QtQuick 2.2
import MonsterWars 1.0
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.1

Item {
    id: root
    property real nodeDistance: (background.width - units.gu(3)) / gameEngine.board.columns

    Row {
        id: topBar
        width: root.width
        height: units.gu(3)
        anchors.top: root.top
        anchors.horizontalCenter: root.horizontalCenter

        Rectangle {
            height: parent.height
            width: units.gu(10)
            color: "black"
            Text {
                id: gameTime
                anchors.fill: parent
                anchors.centerIn: parent
                text: gameEngine.displayGameTime
                color: "white"
                font.bold: true
                font.pixelSize: parent.height
            }

        }


        PointView {
            id: pointView
            width: parent.width - gameTime.width
            height: parent.height
            players: gameEngine.board.players
        }
    }

    Rectangle {
        id: background
        width: root.width
        height: root.height - topBar.height
        anchors.top: topBar.bottom
        anchors.horizontalCenter: root.horizontalCenter
        color: "black"

        Repeater {
            id: monsterRepeater
            model: gameEngine.board.monsters
            delegate: MonsterItem {
                monster: model
                nodeDistance: root.nodeDistance
                pressed: boardArea.pressed
            }
        }

        MouseArea {
            id: boardArea
            anchors.fill: parent
            onPressed: gameEngine.board.resetSelections()
            onReleased: {
                for (var i = 0; i < gameEngine.board.monsterCount; i ++){
                    var monsterItem = monsterRepeater.itemAt(i)
                    var dx = (monsterItem.x + monsterItem.width / 2) - boardArea.mouseX
                    var dy = (monsterItem.y + monsterItem.width / 2) - boardArea.mouseY
                    var l = Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2)) - monsterItem.width / 2 - nodeDistance
                    if (l < nodeDistance) {
                        gameEngine.board.evaluateReleased(monsterItem.monster.id)
                    }
                }
                gameEngine.board.resetSelections()
            }

            onMouseXChanged: updateMouseLogic()
            onMouseYChanged: updateMouseLogic()

            function updateMouseLogic() {
                for (var i = 0; i < gameEngine.board.monsterCount; i ++){
                    var monsterItem = monsterRepeater.itemAt(i)
                    var dx = (monsterItem.x + monsterItem.width / 2) - boardArea.mouseX
                    var dy = (monsterItem.y + monsterItem.width / 2) - boardArea.mouseY
                    var l = Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2)) - monsterItem.width / 2 - nodeDistance
                    if (l < nodeDistance) {
                        gameEngine.board.evaluateHovered(true, monsterItem.monster.id);
                    } else {
                        gameEngine.board.evaluateHovered(false, monsterItem.monster.id);
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
            visible: boardArea.pressed && gameEngine.running

            Repeater {
                id: selectorLineRepeater
                model: gameEngine.board.monsters
                delegate: Canvas {

                }
            }
        }

        Repeater {
            id: attackPillows
            model: gameEngine.pillows
            delegate: AttackPillowItem {
                nodeDistance: root.nodeDistance
                speed: model.speed
                value: model.value
                pillowId: model.id
                colorString: model.colorString
                sourceX: model.sourceX
                sourceY: model.sourceY
                destinationX: model.destinationX
                destinationY: model.destinationY
            }
        }

        GameOverView {
            id: pauseMenu
            anchors.fill: parent
        }
    }
}
