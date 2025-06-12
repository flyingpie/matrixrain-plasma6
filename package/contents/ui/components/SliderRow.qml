import org.kde.plasma.core 2.0 as PlasmaCore
import QtQuick 2.15
import QtQuick.Controls 2.15 as QtControls
import QtQuick.Layouts 1.15

Item {
    property alias value: slider.value
    property string settingKey
    property string label
    property int minimumValue
    property int maximumValue
    property int defaultValue
    property string suffix

    ColumnLayout {
        spacing: PlasmaCore.units.smallSpacing; anchors.fill: parent
        QtControls.Label {
            text: label; Layout.alignment: Qt.AlignLeft
        }
        RowLayout {
            spacing: PlasmaCore.units.smallSpacing
            QtControls.Slider {
                id: slider
                from: minimumValue; to: maximumValue; stepSize: 1
                Component.onCompleted: {
                    var fs = configuration[settingKey]
                    slider.value = (fs !== undefined && fs !== null) ? fs : defaultValue
                }
                onValueChanged: configuration[settingKey] = slider.value
            }
            QtControls.Label {
                text: slider.value + " " + suffix
                Layout.alignment: Qt.AlignRight
            }
        }
    }
}
