import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui
import "Model.js" as Model

// Grit's popup: one motivation line, category chips, an "Another" button, and
// an "add your own" field. Built-in lines come from Model.js; the user's own
// lines are read from and written to ~/.local/state/omarchy/grit-custom.json
// (the state dir, so a plugin update never clobbers them). Modelled on the
// clock's Panel and the clipboard plugin's FileView usage.
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

  // The user's own lines, loaded from disk. Private, local, survives updates.
  property var customLines: []
  property bool editingCustom: false
  readonly property string customPath: Quickshell.env("HOME") + "/.local/state/omarchy/grit-custom.json"

  property bool popoutSwitchClosing: false
  function closeForPopoutSwitch() { root.close() }

  readonly property color contentForeground: bar ? bar.foreground : Color.foreground
  readonly property string contentFontFamily: bar ? bar.fontFamily : Style.font.family

  // ---- Custom line storage ----------------------------------------------
  function loadCustom(txt) {
    try {
      var parsed = JSON.parse(txt)
      root.customLines = Array.isArray(parsed) ? parsed : []
    } catch (e) {
      root.customLines = []
    }
  }

  function saveCustom() {
    customFile.setText(JSON.stringify(root.customLines, null, 2) + "\n")
  }

  function addCustom(text) {
    var line = String(text).replace(/^\s+|\s+$/g, "")
    if (line === "") return
    var list = root.customLines.slice()
    if (list.indexOf(line) === -1) list.push(line)
    root.customLines = list
    saveCustom()
    addField.text = ""
    // Show what was just added, as confirmation.
    root.currentLine = line
    root.lastLine = line
  }

  FileView {
    id: customFile
    path: root.customPath
    watchChanges: true
    atomicWrites: true
    printErrors: false
    onLoaded: root.loadCustom(text())
    onLoadFailed: root.loadCustom("[]")
    onFileChanged: reload()
  }

  // ---- Categories --------------------------------------------------------
  readonly property var chipModel: buildChips()
  function buildChips() {
    var m = [{ id: "all", name: "Surprise me" }]
    for (var i = 0; i < Model.CATEGORIES.length; i++)
      m.push({ id: Model.CATEGORIES[i].id, name: Model.CATEGORIES[i].name })
    if (root.customLines.length > 0) m.push({ id: "yours", name: "Yours" })
    return m
  }

  function poolForActive() {
    if (root.activeCategoryId === "all") return Model.allLines().concat(root.customLines)
    if (root.activeCategoryId === "yours") return root.customLines
    return Model.linesFor(root.activeCategoryId)
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
  function close() { root.editingCustom = false; root.controller.hide() }
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
      // While typing a custom line, let the text field have the keys.
      blocked: root.editingCustom
      onCloseRequested: root.close()
      onTabRequested: function(direction) { root.switchPanel(direction) }
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

        // ---- Category chips
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

        // ---- Add your own
        Text {
          anchors.horizontalCenter: parent.horizontalCenter
          visible: !root.editingCustom
          text: "+ add your own"
          color: addMouse.containsMouse
            ? Style.hoverStateColor(root.contentForeground, Color.accent)
            : Qt.darker(root.contentForeground, 1.5)
          font.family: root.contentFontFamily
          font.pixelSize: 12

          MouseArea {
            id: addMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
              root.editingCustom = true
              Qt.callLater(function() { addField.forceActiveFocus() })
            }
          }
        }

        TextField {
          id: addField
          visible: root.editingCustom
          width: parent.width
          placeholderText: "Write your own line, then press Enter"
          foreground: root.contentForeground
          font.family: root.contentFontFamily

          Keys.onPressed: function(event) {
            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
              root.addCustom(addField.text)
              event.accepted = true
            } else if (event.key === Qt.Key_Escape) {
              addField.text = ""
              root.editingCustom = false
              event.accepted = true
            }
          }
        }
      }
    }
  }
}
