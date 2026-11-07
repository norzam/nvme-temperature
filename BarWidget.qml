import QtQuick
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "norzam.nvme-temperature"
  implicitWidth: label.implicitWidth
  implicitHeight: label.implicitHeight
  property var readings: []

  function temperature(reading) {
    return I18n.formatNumber(reading.value, 0) + "°C"
  }

  WidgetButton {
    id: label
    anchors.fill: parent
    bar: root.bar
    pressable: false
    text: root.readings.length
      ? root.readings.map(root.temperature).join(root.vertical ? "\n" : " · ")
      : "—"
    tooltipText: root.readings.length
      ? root.readings.map(reading => reading.drive + "  " + root.temperature(reading)).join("\n")
      : "NVMe temperature unavailable"
  }

  Timer {
    interval: 5000
    repeat: true
    running: true
    triggeredOnStart: true
    onTriggered: probe.running = true
  }

  Process {
    id: probe
    command: ["bash", Qt.resolvedUrl("read-temperatures.sh").toString().replace(/^file:\/\//, "")]
    stdout: StdioCollector {
      onStreamFinished: {
        root.readings = text.trim().split("\n").filter(line => /^nvme\d+ -?\d+$/.test(line)).map(line => {
          const parts = line.split(" ")
          return { drive: parts[0], value: Number(parts[1]) / 1000 }
        })
      }
    }
  }
}
