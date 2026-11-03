import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtGraphs

Page
{
    id: signalGraphPage

    Component.onCompleted:
    {
    }

    Rectangle
    {
        id: background
        width: parent.width
        height: parent.height
        anchors.top: parent.top
    }

    ComboBox
    {
        id: deviceList
        width: signalGraphPage.width*0.9
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top:parent.top

        onCurrentIndexChanged:
        {
            //loadDeviceTelemetry();
        }

        model: applicationData.DeviceNames
    }

    GraphsView
    {
        id: temperatureGraph

        anchors.fill: parent

        axisX: DateTimeAxis
        {
            id: timeAxis

            labelFormat: "hh:mm:ss"
            timeZone: timeAxis.timeZoneFromString("Asia/Kolkata")
            min: new Date(Date.now() - 60000)
            max: new Date(Date.now())
            titleText: "Time"
        }

        axisY: ValueAxis
        {
            id: temperatureAxis

            min: 0
            max: 50
            labelFormat: "%.1f"
            titleText: "Temperature (°C)"
        }

        LineSeries
        {
            id: temperatureSeries

            color: "#29B6F6"
            width: 2

            function addReading(timestamp, temperature)
            {
                append(timestamp, temperature)

                if (count > 25)
                    remove(0)
            }
        }
    }

    Connections
    {
        target: applicationData
    }

    function onTelemetry(x, y)
    {
        temperatureSeries.addReading(x.getTime(), y);
    }
}
