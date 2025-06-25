pragma ComponentBehavior: Bound
import QtQuick 2.15
import QtQuick.Controls 2.15 as QC
import QtQuick.Layouts 1.15
import org.kde.kirigami.layouts 2.0 as KirigamiLayouts

KirigamiLayouts.FormLayout {
    anchors.fill: parent

    property alias cfg_fps: fpsSpin.value
    property alias cfg_columnCount: columnCountSpin.value
    property alias cfg_dropSpeedMax: dropSpeedMaxSpin.value
    property alias cfg_dropSpeedMin: dropSpeedMinSpin.value
    property alias cfg_glitchChance: glitchSpin.value
    property alias cfg_singleColor: colorField.text

    // Column count
    QC.SpinBox {
        id: columnCountSpin; from:8; to:512; stepSize:1; value:configuration.columnCount
        onValueChanged: configuration.columnCount = value
        KirigamiLayouts.FormData.label: qsTr("Column Count")
    }

    // Drop Speed
    QC.SpinBox {
        id: dropSpeedMinSpin; from:1; to:100; stepSize:1; value:configuration.dropSpeedMin
        onValueChanged: configuration.dropSpeedMin = value
        KirigamiLayouts.FormData.label: qsTr("Drop Speed (Min)")
    }
    QC.SpinBox {
        id: dropSpeedMaxSpin; from:1; to:100; stepSize:1; value:configuration.dropSpeedMax
        onValueChanged: configuration.dropSpeedMax = value
        KirigamiLayouts.FormData.label: qsTr("Drop Speed (Max)")
    }


    QC.SpinBox {
        id: fpsSpin; from:1; to:100; stepSize:1; value:configuration.fps
        onValueChanged: configuration.fps = value
        KirigamiLayouts.FormData.label: qsTr("FPS")
    }

    QC.TextField {
        id: colorField; text:configuration.singleColor
        onTextChanged: configuration.singleColor = text
        visible: modeCombo.currentIndex === 0
        KirigamiLayouts.FormData.label: qsTr("Single Color")
    }

    QC.SpinBox {
        id: glitchSpin; from:0; to:100; stepSize:1; value:configuration.glitchChance
        onValueChanged: configuration.glitchChance = value
        KirigamiLayouts.FormData.label: qsTr("Glitch Chance (%)")
    }
}
