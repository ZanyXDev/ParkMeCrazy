import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import QtMultimedia 5.15

Item {
  id: root
  property bool isSoundEnable: true
  property bool isActive: root.enabled && ma.containsMouse
  property alias font: btnText.font
  property alias text: btnText.text
  property alias color: btnText.color
  property string gradientColor: "black"
  property string colorDown: "lightgreen"
  implicitHeight: btnText.height * 1.25
  implicitWidth: btnText.width * 1.25


  /**
   * @var Qt::MouseButtons acceptedButtons
   * This property holds the mouse buttons that the mouse area reacts to.
   * See <a href="https://doc.qt.io/qt-5/qml-qtquick-mousearea.html#acceptedButtons-prop">Qt documentation</a>.
   */
  property alias acceptedButtons: ma.acceptedButtons


  /**
   * @var MouseArea ara
   * Mouse area element covering the button.
   */
  property alias mouseArea: ma


  /** This property Enables accessibility of QML items.
    * See <a href="https://doc.qt.io/qt-5/qml-qtquick-accessible.html">Qt documentation</a>.
   */
  Accessible.role: Accessible.Button
  Accessible.name: btnText.text
  Accessible.onPressAction: root.clicked(null)

  enabled: true

  signal clicked
  signal hoverChanged

  state: ma.pressed ? "buttonDown" : "buttonUp"
  states: [
    State {
      name: "buttonDown"
      PropertyChanges {
        target: root
        scale: 0.7
      }
      PropertyChanges {
        target: root
        layer.enabled: false
      }
    },
    State {
      name: "buttonUp"
      PropertyChanges {
        target: root
        scale: 1.0
      }
      PropertyChanges {
        target: root
        layer.enabled: true
      }
    }
  ]

  transitions: Transition {
    NumberAnimation {
      properties: scale
      easing.type: Easing.InOutQuad
      duration: 200
    }
  }

  layer.enabled: true
  layer.effect: DropShadow {
    //anchors.fill: root
    horizontalOffset: 3
    verticalOffset: 4
    radius: 5
    samples: 11
    color: "grey"
    opacity: 0.75
  }

  Rectangle {
    id: background
    anchors.fill: parent
    border.color: "lightgrey"
    border.width: 2
    radius: 8
    smooth: true
    gradient: Gradient {
      GradientStop {
        position: 0.0
        color: !ma.pressed ? gradientColor : "black"
      }
      GradientStop {
        position: 1.0
        color: !ma.pressed ? "black" : gradientColor
      }
    }

    Text {
      id: btnText
      anchors.centerIn: parent
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      elide: Text.ElideRight
      font {
        family: "Helvetica"
        pointSize: 14
        bold: true
      }
      smooth: true
      color: "black"
    }
  }
  SoundEffect {
    id: playSound
    source: "qrc:/res/sounds/shorttick.wav"
  }
  MouseArea {
    id: ma
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: isActive ? Qt.PointingHandCursor : Qt.ArrowCursor
    onPressed: {
      if (isSoundEnable)
        playSound.play()
    }
    onClicked: {
      root.clicked()
    }
    onHoveredChanged: {
      root.hoverChanged()
    }
  }
}
