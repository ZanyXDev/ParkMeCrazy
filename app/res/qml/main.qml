import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15 as QQC2

import common 1.0
import ui 1.0

import io.github.zanyxdev.parkmecrazy 1.0
import io.github.zanyxdev.parkmecrazy.hal 1.0

QQC2.ApplicationWindow {
  id: appWnd

  // Required properties should be at the top.
  readonly property int screenOrientation: Qt.PortraitOrientation
  readonly property bool appInForeground: Qt.application.state === Qt.ApplicationActive

  property bool appInitialized: false

  property var screenWidth: Screen.width
  property var screenHeight: Screen.height
  property var screenAvailableWidth: Screen.desktopAvailableWidth
  property var screenAvailableHeight: Screen.desktopAvailableHeight

  // ----- Signal declarations
  signal screenOrientationUpdated(int screenOrientation)


  /**
  * @brief
  * При работе с Android системами обычно выбирается базовый фрейм 360×640,
  * для адаптации под удлиненные экраны 18:9 можно использовать размер фрейма 360×720.
  * Размер фрейма для приложения на системе IOS чаще всего используется 375×812.
*/
  width: 360
  height: 640

  maximumHeight: height
  maximumWidth: width

  minimumHeight: height
  minimumWidth: width
  // ----- Then comes the other properties. There's no predefined order to these.
  visible: true
  visibility: (isMobile) ? Window.FullScreen : Window.Windowed
  flags: Qt.Dialog
  title: qsTr(" ")
  Screen.orientationUpdateMask: Qt.PortraitOrientation | Qt.LandscapeOrientation | Qt.InvertedPortraitOrientation
                                | Qt.InvertedLandscapeOrientation

  // ----- Then attached properties and attached signal handlers.

  // ----- States and transitions.
  // ----- Signal handlers
  Component.onCompleted: {

    let infoMsg = `Screen.height[${Screen.height}], Screen.width[${Screen.width}]
    Screen [height ${height},width ${width}]
    Build with [${HAL.getAppBuildInfo()}]
    Available physical screens [${Qt.application.screens.length}]
    Available Resolution width: ${Screen.desktopAvailableWidth} height ${Screen.desktopAvailableHeight}
    `
    AppSingleton.toLog(infoMsg)

    if (!isMobile) {
      appWnd.moveToCenter()
    }
  }

  onAppInForegroundChanged: {
    if (appInForeground) {
      if (!appInitialized) {
        appInitialized = true
        //appCore.initialize()
      }
    } else {
      if (isDebugMode)
        console.log(
              "onAppInForegroundChanged-> [appInForeground:" + appInForeground + ", appInitialized:" + appInitialized + "]")
    }
  }

  // ----- Visual children
  ColumnLayout {
    id: mainLayout
    spacing: 2
    anchors {
      margins: 2
      fill: parent
    }
    component ProportionalItem: Item {
      Layout.fillWidth: true
      Layout.fillHeight: true
      Layout.preferredWidth: 1
      Layout.preferredHeight: 1
    }
    ProportionalItem {
      id: titleItem
      Layout.preferredHeight: 72
      Rectangle {
        id: bgrTitleRect
        color: "black"
        anchors.fill: parent
        radius: 4

        RowLayout {
          id: titleRow
          anchors.fill: parent
          spacing: 4
          component InfoText: Text {
            Layout.fillWidth: true
            Layout.fillHeight: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            font.family: AppSingleton.astraFont.name
            font.pixelSize: AppSingleton.extraLargeFontSize
          }
          Item {
            Layout.fillWidth: true
          }
          InfoText {
            text: qsTr("Park")
            color: "orange"
          }
          InfoText {
            text: qsTr("Mee")
            color: "steelblue"
            font.bold: true
          }
          InfoText {
            text: "Crazy!"
            color: "darkred"
          }
          Item {
            Layout.fillWidth: true
          }
        }
        Component.onCompleted: {
          if (isDebugMode) {
            let debugMsg = `bgrTitleRect: ${bgrTitleRect.height}h, ${bgrTitleRect.width}w`
            AppSingleton.toLog(debugMsg)
          }
        }
      }
    }
    ProportionalItem {
      id: gameItem
      Layout.preferredHeight: 280
      Rectangle {
        id: testRect2
        anchors.fill: parent
        color: "yellow"
      }
    }
    ProportionalItem {
      id: toolBoxItem
      Layout.preferredHeight: 40
      Rectangle {
        id: bgrtoolBoxRect
        anchors.fill: parent
        color: "black"
        radius: 4
        RowLayout {
          id: toolBoxRow
          anchors.fill: parent
          spacing: 4
          component LevelsMovesText: Text {
            Layout.fillWidth: true
            Layout.fillHeight: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            font.family: AppSingleton.astraFont.name
            font.pixelSize: AppSingleton.largeFontSize
            color: "grey"
          }
          Item {
            Layout.fillWidth: true
          }
          LevelsMovesText {
            id: levelTxt
            text: qsTr(" Level: ") + 99 //+ board.levelIndex
          }
          Item {
            Layout.fillWidth: true
          }
          LevelsMovesText {
            id: movesTxt
            text: qsTr("Moves: ") + 99 //+ board.boardMoves + " "
          }
          Item {
            Layout.preferredWidth: 20
            Layout.fillWidth: true
          }
        }
      }
    }
    ProportionalItem {
      id: buttonsItem
      Layout.preferredHeight: 40
      Rectangle {
        id: bgrButtonsRect
        anchors.fill: parent
        radius: 4
        color: "black"
        RowLayout {
          id: buttonsRow
          anchors.fill: parent
          spacing: 16
          Item {
            Layout.fillWidth: true
          }
          PButton {
            id: btnNext
            isSoundEnable: false
            Layout.preferredWidth: 64
            Layout.preferredHeight: 48
            text: "Next"
            color: "yellow"
            font.family: AppSingleton.astraFont.name
            font.pixelSize: AppSingleton.averageFontSize
            gradientColor: "green"
            onClicked: {

              // if (boardUtils.loadLevel(board.levelIndex + 1)) {
              //   board.refreshBoardData()
              // }
            }
          }

          PButton {
            id: btnRestart
            isSoundEnable: false
            Layout.preferredWidth: 64
            Layout.preferredHeight: 48
            text: "Restart"
            color: "yellow"
            font.family: AppSingleton.astraFont.name
            font.pixelSize: AppSingleton.averageFontSize
            gradientColor: "green"
            onClicked: {
              AppSingleton.toLog("called restart level, current level: ") //+ board.levelIndex)
              //boardUtils.restartLevel()
              //board.refreshBoardData()
            }
          }
          PButton {
            id: btnJump
            isSoundEnable: false
            Layout.preferredWidth: 64
            Layout.preferredHeight: 48
            text: "Jump to"
            color: "yellow"
            font.family: AppSingleton.astraFont.name
            font.pixelSize: AppSingleton.averageFontSize
            gradientColor: "green"
            onClicked: {
              AppSingleton.toLog("called JumpTo level, current level: ") //+ board.levelIndex)
              // box.doChooseLevel()
            }
          }
          PButton {
            id: btnAbout
            isSoundEnable: false
            Layout.preferredWidth: 64
            Layout.preferredHeight: 48
            text: "About"
            color: "yellow"
            font.family: AppSingleton.astraFont.name
            font.pixelSize: AppSingleton.averageFontSize
            gradientColor: "green"
            onClicked: {
              AppSingleton.toLog("About")
              //   box.doAbout()
            }
          }
          Item {
            Layout.fillWidth: true
          }
        }
      }
    }
  }

  // ----- Qt provided non-visual children

  //CarModel {
  //  id: carModel
  //}

  // ----- Custom non-visual children

  // ----- JavaScript functions
  function moveToCenter() {
    appWnd.y = (screenAvailableHeight / 2) - (height / 2)
    appWnd.x = (screenAvailableWidth / 2) - (width / 2)
  }
}
