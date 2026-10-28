import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Page
{
    id: availableDevicesPage

    Component.onCompleted:
    {
        console.log(applicationData.DeviceList.length + " devices in model for QML Component.onCompleted")
        console.log(deviceListView.count + " devices in view for QML onDeviceAction")
    }

    Rectangle
    {
        id: background
        anchors.fill: parent
        color: applicationData.Theme.BaseColor
    }

    ListView
    {
        id: deviceListView
        anchors.fill: parent
        visible: true
        spacing: 5
        clip: true
        model: applicationData.DeviceList

        delegate: Component
        {
            id: deviceListDelegate

            Rectangle
            {
                id: availableDevicesItem
                width: deviceListView.width
                height: 50
                radius: 0
                color: applicationData.Theme.PanelUpperColor
                border.color: applicationData.Theme.LineColor

                Rectangle
                {
                    id: spacer1
                    height: parent.height*0.95
                    width: parent.height*0.95
                    color: applicationData.Theme.PanelUpperColor
                    anchors.verticalCenter: parent.verticalCenter
                    border.width: 0
                }

                Label
                {
                    id: deviceId
                    text: deviceListView.model[index].DeviceId
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: spacer1.right
                }

                Rectangle
                {
                    id: spacer2
                    height: parent.height*0.95
                    width: parent.height*0.95
                    color: applicationData.Theme.PanelUpperColor
                    anchors.verticalCenter: parent.verticalCenter
                    border.width: 0
                    anchors.left: deviceId.right
                }

                Label
                {
                    id: deviceName
                    text: deviceListView.model[index].DeviceName
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: spacer2.right
                }

                // ----

                Rectangle
                {
                    id: spacer3
                    height: parent.height*0.95
                    width: parent.height*0.95
                    color: applicationData.Theme.PanelUpperColor
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    border.width: 0
                }

                ToolButton
                {
                    id: cmdItem
                    icon.source: "../images/DeviceItem.png"
                    icon.width:  parent.height*0.5
                    icon.height: parent.height*0.5
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: spacer3.left
                }

                Rectangle
                {
                    id: spacer4
                    height: parent.height*0.95
                    width: parent.height*0.95
                    color: applicationData.Theme.PanelUpperColor
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: cmdItem.left
                    border.width: 0
                }

                ToolButton
                {
                    id: cmdDelete
                    icon.source: "../images/Delete.png"
                    icon.width:  parent.height*0.5
                    icon.height: parent.height*0.5
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: spacer4.left
                }
            }
        }
    }

    Connections
    {
        target: applicationData

        function onDeviceAction(fl)
        {
            console.log("Device update received")
            deviceListView.model = applicationData.DeviceList
            console.log(deviceListView.count + " devices in QML onDeviceAction")
        }

        function onDeviceMessage(fl, str)
        {
            deviceListView.model = applicationData.DeviceList
        }
    }
}


