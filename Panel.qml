import QtQuick
import Quickshell
import qs.Commons
import qs.Ui
import "Model.js" as Model

// Grit's popup: one motivation line, big and centred, a row of category
// chips to choose the mood, and an "Another" button. Modelled on the clock's
// Panel (Panel hosting a KeyboardPanel). Colours and fonts come from the bar,
// so it matches the user's theme.
Panel {
  id: root
  moduleName: "brooklynkray.grit"
  ipcTarget: "brooklynkray.grit"
  manageIpc: false

  property var anchorItem: null
  property var hostWidget: null
  readonly property var barIdentity: hostWidget || root

  property string activeCategoryId: "all"
  property string currentLine: ""
  property string lastLine: ""

  // Popout-switch handshake, mirrored from the bar-widget contract.
  property bool popoutSwitchClosing: false
  function closeForPopoutSwitch() { root.close() }

  // Guarded so the panel renders before the bar is injected.
  readonly property color contentForeground: bar ? bar.foreground : Color.foreground
  readonly property string contentFontFamily: bar ? bar.fontFamily : Style.font.family

  // "Surprise me" (all lines) first, then one chip per category.
  readonly property var chipModel: buildChips()
  function buildChips() {
    var m = [{ id: "all", name: "Surprise me" }]
    for (var i = 0; i < Model.CATEGORIES.length; i++)
      m.push({ id: Model.CATEGORIES[i].id, name: Model.CATEGORIES[i].name })
    return m
  }

  function poolForActive() {
    return root.activeCategoryId === "all" ? Model.allLines() : Model.linesFor(root.activeCategoryId)
  }

  function newLine() {
    var next = Model.pick(poolForActive(), root.lastLine)
    root.lastLine = next
    root.currentLine = next
  }

  function setCategory(id) {
    root.activeCategoryId = id
    newLine()
  }

  function open() {
    if (root.currentLine === "") newLine()
    root.controller.show()
  }
  function close() { root.controller.hide() }
  function toggle() { if (root.opened) root.close(); else root.open() }

  function switchPanel(direction) {
    if (root.bar && typeof root.bar.switchPanelFrom === "function")
      return root.bar.switchPanelFrom(root.barIdentity, direction)
    return false
  }

  KeyboardPanel {
    id: kpanel
    anchorItem: root.anchorItem
    owner: root.barIdentity
    bar: root.bar
    open: root.opened
    centerOnBar: true
    focusTarget: keyCatcher
    contentWidth: kpanel.fittedContentWidth(Style.space(480))
    contentHeight: kpanel.fittedContentHeight(body.implicitHeight + Style.space(48))

    PanelKeyCatcher {
      id: keyCatcher
      anchors.fill: parent
      onCloseRequested: root.close()
      onTabRequested: function(direction) { root.switchPanel(direction) }
      // Space or N gives you another line without reaching for the mouse.
      onTextKey: function(t) { if (t === " " || t === "n" || t === "N") root.newLine() }

      Column {
        id: body
        anchors.centerIn: parent
        width: Style.space(440)
        spacing: Style.space(22)

        Text {
          width: parent.width
          wrapMode: Text.WordWrap
          horizontalAlignment: Text.AlignHCenter
          text: root.currentLine
          color: root.contentForeground
          font.family: root.contentFontFamily
          font.pixelSize: 22
          font.bold: true
          lineHeight: 1.15
        }

        // ---- Category chips. Wraps to as many rows as it needs.
        Flow {
          width: parent.width
          spacing: Style.space(8)

          Repeater {
            model: root.chipModel

            Rectangle {
              required property var modelData
              readonly property bool active: modelData.id === root.activeCategoryId

              height: chipLabel.implicitHeight + Style.space(10)
              width: chipLabel.implicitWidth + Style.space(20)
              radius: Style.cornerRadius
              border.width: active ? Style.spacing.hairline : 0
              border.color: Color.accent
              color: active
                ? Style.hoverFillFor(root.contentForeground, Color.accent)
                : (chipMouse.containsMouse
                    ? Qt.rgba(root.contentForeground.r, root.contentForeground.g, root.contentForeground.b, 0.14)
                    : Qt.rgba(root.contentForeground.r, root.contentForeground.g, root.contentForeground.b, 0.07))

              Text {
                id: chipLabel
                anchors.centerIn: parent
                text: modelData.name
                color: active
                  ? Style.hoverStateColor(root.contentForeground, Color.accent)
                  : Qt.darker(root.contentForeground, 1.2)
                font.family: root.contentFontFamily
                font.pixelSize: 12
              }

              MouseArea {
                id: chipMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.setCategory(modelData.id)
              }
            }
          }
        }

        // ---- Another
        Rectangle {
          anchors.horizontalCenter: parent.horizontalCenter
          width: againText.implicitWidth + Style.space(30)
          height: againText.implicitHeight + Style.space(16)
          radius: Style.cornerRadius
          color: againMouse.containsMouse
            ? Style.hoverFillFor(root.contentForeground, Color.accent)
            : Qt.rgba(root.contentForeground.r, root.contentForeground.g, root.contentForeground.b, 0.08)

          Text {
            id: againText
            anchors.centerIn: parent
            text: "Another"
            color: againMouse.containsMouse
              ? Style.hoverStateColor(root.contentForeground, Color.accent)
              : root.contentForeground
            font.family: root.contentFontFamily
            font.pixelSize: 14
            font.bold: true
          }

          MouseArea {
            id: againMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.newLine()
          }
        }
      }
    }
  }
}
