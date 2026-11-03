
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtGraphs

Page
{
    id: signalGraphPage

    background: Rectangle
    {
        color: "#20242b"
    }

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        ComboBox
        {
            id: deviceList

            Layout.fillWidth: true

            model: applicationData.DeviceNames

            onCurrentIndexChanged:
            {
                // loadDeviceTelemetry();
            }
        }

        GraphsView
        {
            id: temperatureGraph

            Layout.fillWidth: true
            Layout.fillHeight: true

            theme: GraphsTheme
            {
                colorScheme: GraphsTheme.ColorScheme.Dark
            }

            axisX: DateTimeAxis
            {
                id: timeAxis

                labelFormat: "hh:mm:ss"
                timeZone: timeZoneFromString("Asia/Kolkata")

                min: new Date(0)
                max: new Date(60000)

                titleText: "Time"
            }

            axisY: ValueAxis
            {
                id: temperatureAxis

                min: 0
                max: 50

                tickInterval: 5
                labelFormat: "%.1f"

                titleText: "Temperature (°C)"
            }

            LineSeries
            {
                id: temperatureSeries

                color: "#29B6F6"
                width: 2

                pointDelegate: Rectangle
                {
                    property color pointColor

                    width: 7
                    height: 7
                    radius: 3.5
                    color: pointColor
                }

                function addReading(timestamp, temperature)
                {
                    // Timestamp is already in milliseconds.

                    append(timestamp, temperature)

                    // Maintain a rolling window of 25 readings.

                    if (count > 25)
                        remove(0)

                    // Keep the X axis aligned with available readings.

                    if (count > 0)
                    {
                        const first = at(0).x
                        const last = at(count - 1).x

                        timeAxis.min = new Date(first - 2500)
                        timeAxis.max = new Date(last + 2500)
                    }
                }
            }
        }
    }

    Connections
    {
        target: applicationData

        function onTelemetry(x, y)
        {
            temperatureSeries.addReading(x.getTime(), y)
        }
    }
}
