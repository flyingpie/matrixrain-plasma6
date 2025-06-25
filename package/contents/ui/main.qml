import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import org.kde.plasma.plasmoid 2.0

WallpaperItem {
    id: main
    anchors.fill: parent

    property int fps: main.configuration.fps !== undefined ? main.configuration.fps : 60

    property int columnCount: main.configuration.columnCount !== undefined ? main.configuration.columnCount : 80

    // Drop Speed
    property real dropSpeedMin: main.configuration.dropSpeedMin !== undefined ? main.configuration.dropSpeedMin : 5
    property real dropSpeedMax: main.configuration.dropSpeedMax !== undefined ? main.configuration.dropSpeedMax : 25

    property color singleColor: main.configuration.singleColor !== undefined ? main.configuration.singleColor : "#00ff00"

    property int glitchChance: main.configuration.glitchChance !== undefined ? main.configuration.glitchChance : 1

    Canvas {
        id: canvas
        anchors.fill: parent

        property var columnWidth
        property var columnWidthHalf
        property var columnHeight
        property var rowCount
        property var ratio
        property var maxDropSize
        property var minDropSize
        property var drops: []

        function initDrops() {
            drops = []

            ratio = canvas.width / canvas.height

            columnWidth = Math.floor(canvas.width / columnCount)
            columnWidthHalf = columnWidth / 2
            columnHeight = columnWidth / ratio
            rowCount = Math.floor(canvas.height / columnHeight)

            maxDropSize = columnWidth * 1.5
            minDropSize = columnWidth * .5;

            for (var j = 0; j < columnCount; j++) {
                let drop = createDrop(j)
                drop.y = Math.floor(Math.random() * canvas.height) // Start drops across the screen
                drops.push(drop)
            }
        }

        function reset() {
            canvas.initDrops();
            canvas.requestPaint();
        }

        function randomIntBetween(min, max) {
            return Math.floor(min + Math.random() * (max - min))
        }

        function createDrop(j) {
            return {
                x:                j * columnWidth,
                y:                0,
                x_offset:        randomIntBetween(-columnWidthHalf, columnWidthHalf),
                brightness:        .5 + Math.random() * .9,
                size:            minDropSize + Math.random() * (maxDropSize - minDropSize),
                speed:            randomIntBetween(main.dropSpeedMin, main.dropSpeedMax)
            }
        }

        Timer {
            id: timer
            interval: 1000 / main.fps
            running: true
            repeat: true
            onTriggered: canvas.requestPaint()
        }

        property var init

        onPaint: {
            var ctx = getContext("2d")

            ctx.globalAlpha = 1.0

            ctx.fillStyle = "rgba(0,0,0,0.05)"
            ctx.fillRect(0,0,width,height)

            for (var i = 0; i < drops.length; i++) {
                var drop = drops[i];

                // Glitch
                if (Math.random() < main.glitchChance / 100) {
                    ctx.fillStyle = "#ffffff"
                    ctx.font = `bold ${drop.size}px monospace`
                } else {
                    ctx.fillStyle = main.singleColor
                    ctx.globalAlpha = drop.brightness
                }
                ctx.font = drop.size + "px monospace"
                ctx.fillText(String.fromCharCode(0x30A0 + Math.floor(Math.random() * 96)), drop.x + drop.x_offset, drop.y)

                drop.y += drop.speed

                // Reset drop after clearing the screen
                if (drop.y > height) {
                    drops[i] = createDrop(i)
                }
            }
        }

        Component.onCompleted: initDrops()
    }

    onColumnCountChanged: canvas.reset();
    onDropSpeedMaxChanged: canvas.reset();
    onDropSpeedMinChanged: canvas.reset();
    onFpsChanged: timer.interval = 1000 / main.fps;
    onGlitchChanceChanged: canvas.reset();
    onSingleColorChanged: canvas.reset();

    FastBlur {
        id: blur
        anchors.fill: canvas
        source: canvas
        radius: 10
    }

    Blend {
        id: blend
        anchors.fill: blur
        source: blur
        foregroundSource: canvas
        mode: "addition"
    }

    BrightnessContrast {
        anchors.fill: blend
        source: blend
        brightness: 0.15
        contrast: 0.15
    }
}
