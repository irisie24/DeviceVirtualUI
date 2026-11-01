import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Page
{
    id: availableDevicesPage

    property int selectedIndex : 0

    Component.onCompleted:
    {
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
                    onClicked:
                    {
                        selectedIndex = index
                        entityDetails.open()
                    }
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

                    onClicked:
                    {
                        selectedIndex = index
                        confirm.open()
                    }
                }
            }
        }
    }

    Popup
    {
        id: confirm
        visible: false
        width: availableDevicesPage.width*0.5
        height: availableDevicesPage.height
        x: availableDevicesPage.width*0.5
        y: 0
        padding: 0
        modal: true
        property int itemIndex: 0
        property string itemValue: ""

        contentItem: Rectangle
        {
            color: applicationData.Theme.PanelUpperColor
            anchors.fill: parent
            border.color: applicationData.Theme.LineColor

            Text
            {
                id: confirmText
                text: "Do you want to remove the device " + deviceListView.model[selectedIndex].DeviceName + " ?"
                color: applicationData.Theme.TextPrimaryColor
                wrapMode: "Wrap"
                width: confirm.width*0.9
                anchors.centerIn: parent
            }

            Grid
            {
                id: gridDlg
                rows: 1
                columns: 2
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                anchors.rightMargin: 10
                anchors.right: parent.right
                spacing: 10

                CustomButton
                {
                    id:btnNo
                    width: confirm.width*0.33
                    height: applicationData.Theme.BarHeight
                    text: "No"
                    isDefault: false
                    accentColor: applicationData.Theme.AccentBaseColor
                    onClicked:
                    {
                        confirm.close();
                    }
                }

                CustomButton
                {
                    id:btnYes
                    width: confirm.width*0.33
                    height: applicationData.Theme.BarHeight
                    text: "Yes"
                    isDefault: true
                    accentColor: applicationData.Theme.AccentBaseColor
                    onClicked:
                    {
                        confirm.close()
                    }
                }
            }
        }
    }

    Popup
    {
        id: entityDetails
        visible: false
        width: availableDevicesPage.width*0.75
        height: availableDevicesPage.height
        x: (availableDevicesPage.width - availableDevicesPage.width*0.75)
        y: 0
        padding: 0
        modal: true
        property int itemIndex: 0
        property string itemValue: ""

        contentItem: Rectangle
        {
            id: frame
            color: applicationData.Theme.PanelUpperColor
            anchors.fill: parent
            border.color: applicationData.Theme.LineColor

            Text
            {
                id: entityDetailsText
                text: "Device Details"
                font.bold: true
                color: applicationData.Theme.TextPrimaryColor
                wrapMode: "Wrap"
                width: entityDetails.width*0.9
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: applicationData.Theme.BarHeight/2
            }

            Grid
            {
                id: entityDetailsGridDlg
                rows: 8
                columns: 4
                width: entityDetails.width*0.9
                anchors.right: parent.right
                anchors.top: entityDetailsText.bottom
                anchors.topMargin: applicationData.Theme.BarHeight/2
                spacing: 10

                Label { text: "Device Id" }  Label { text: deviceListView.model[selectedIndex].DeviceId }
                Label { text: "Device Name" }  Label { text: deviceListView.model[selectedIndex].DeviceName }
                Label { text: "Make" }  Label { text: deviceListView.model[selectedIndex].Make }
                Label { text: "Model" }  Label { text: deviceListView.model[selectedIndex].Model }
                Label { text: "Simulation Flows" }  Label { text: deviceListView.model[selectedIndex].NumberOfFlows }
                Label { text: "Flows Repeatable" }  Label { text: deviceListView.model[selectedIndex].RepeatFlowSequence }
                Label { text: "Flow Sequence End" }  Label { text: deviceListView.model[selectedIndex].FlowSequenceEndStr }
                Label { text: "Simulation Mode" }  Label { text: deviceListView.model[selectedIndex].Mode }
                Label { text: "Operating Maximum" }  Label { text: deviceListView.model[selectedIndex].OperatingMax }
                Label { text: "Operating Minimum" }  Label { text: deviceListView.model[selectedIndex].OperatingMin }
                Label { text: "Latitude" }  Label { text: deviceListView.model[selectedIndex].Latitude }
                Label { text: "Longitude" }  Label { text: deviceListView.model[selectedIndex].Longitude }
                Label { text: "Altitude" }  Label { text: deviceListView.model[selectedIndex].Altitude }
                Label { text: "Generator Model" }  Label { text: deviceListView.model[selectedIndex].GenModelStr }
                Label { text: "Unit of Measurement" }  Label { text: deviceListView.model[selectedIndex].UnitOfMeasurement }
                Label { text: "Scale" }  Label { text: deviceListView.model[selectedIndex].Scale }
            }

            Rectangle
            {
                width: entityDetails.width
                height: applicationData.Theme.BarHeight*2
                anchors.bottom: frame.bottom
                color: applicationData.Theme.PanelUpperColor
                anchors.topMargin: applicationData.Theme.BarHeight/2

                CustomButton
                {
                    id:btnEntityDetailsYes
                    width: entityDetails.width*0.33
                    height: applicationData.Theme.BarHeight
                    text: "Close"
                    isDefault: true
                    accentColor: applicationData.Theme.AccentBaseColor
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: applicationData.Theme.BarHeight/2
                    onClicked:
                    {
                        entityDetails.close()
                    }
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
        }
    }
}


