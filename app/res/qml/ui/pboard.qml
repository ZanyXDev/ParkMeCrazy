import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2

Item {
  id: root
  BorderImage {
    id: brdImg
    anchors.fill: parent
    border {
      left: 30
      top: 30
      right: 30
      bottom: 30
    }
    // horizontalTileMode: BorderImage.Round
    // verticalTileMode: BorderImage.Round
    source: "qrc:/res/images/border.png"
    Rectangle {
      id: gameField

      height: 288
      width: 288
      border.color: "black"
      border.width: 2
      radius: 4
    }
    Component.onCompleted: {
      console.log(
            `inner size: ${brdImg.width - border.left - border.right}w,${brdImg.height - border.top - border.bottom}h`)
    }
  }
}
