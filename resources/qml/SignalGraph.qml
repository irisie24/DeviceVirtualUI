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
        id: chart
        height: signalGraphPage.height - deviceList.height
        width: signalGraphPage.width
        anchors.top: deviceList.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 5

        theme: GraphsTheme { }

        // Configure the horizontal X axis
        axisX: ValueAxis
        {
            min: 0
            max: 5
            labelFormat: "%.1f"
        }

        // Configure the vertical Y axis
        axisY: ValueAxis
        {
            min: 0
            max: 10
            labelFormat: "%d"
        }

        // Define the data series
        LineSeries
        {
            id: lineSeries
            color: "#2196F3" // Line color
            width: 3        // Line thickness
        }
    }

    function loadDeviceTelemetry()
    {
    }

    Connections
    {
        target: applicationData
    }

    function onTelemetry(x, y)
    {
        lineSeries.append(x, y);
    }
}
