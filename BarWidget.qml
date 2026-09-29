import QtQuick
import Quickshell
import qs.Commons
import qs.Ui

// Grit's bar entry: a small "GRIT" label that hosts the motivation panel.
// Modelled on the built-in clock's BarWidget, which is the reference pattern
// for "a bar label that opens a popup". Left click toggles the panel.
BarWidget {
  id: root
  moduleName: "brooklynkray.grit"

  // ---- Panel routing. The bar summons/hides/toggles a widget through
  //      open/close/opened on the bar-widget root, which forward to the
  //      loaded Panel. Same contract the clock follows.
  readonly property bool opened: panelLoader.item ? panelLoader.item.opened === true : false

  function open()        { if (panelLoader.item) panelLoader.item.open() }
  function close()       { if (panelLoader.item) panelLoader.item.close() }
  function togglePanel() { if (panelLoader.item) panelLoader.item.toggle() }

  // Popout-switch handshake the bar prefers over a plain close. Guarded so a
  // panel that does not implement it simply closes instead of erroring.
  readonly property bool popoutSwitchClosing: panelLoader.item ? panelLoader.item.popoutSwitchClosing === true : false
  function closeForPopoutSwitch() {
    if (panelLoader.item && panelLoader.item.closeForPopoutSwitch) panelLoader.item.closeForPopoutSwitch()
    else if (panelLoader.item) panelLoader.item.close()
  }

  // Hand the panel everything it needs to anchor and theme itself.
  function injectPanel() {
    var t = panelLoader.item
    if (!t) return
    if ("bar" in t) t.bar = root.bar
    if ("settings" in t) t.settings = root.settings
    if ("anchorItem" in t) t.anchorItem = button
    if ("hostWidget" in t) t.hostWidget = root
  }

  // The open-panel indicator dot the bar draws under the pill.
  readonly property real openPanelIndicatorWidth: button.labelWidth
  readonly property real openPanelIndicatorHeight: Math.max(Style.space(10), Math.round(Style.bar.iconSlot * 0.55))

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  onBarChanged: injectPanel()
  onSettingsChanged: injectPanel()

  Loader {
    id: panelLoader
    active: true
    source: Qt.resolvedUrl("Panel.qml")
    visible: false
    onLoaded: {
      root.injectPanel()
      Qt.callLater(root.injectPanel)
    }
  }

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "GRIT"
    horizontalMargin: 8.75
    verticalPadding: 8.75

    onPressed: function(b) { root.togglePanel() }
  }
}
