import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Page
{
    id: availableSensingFlowsPage

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
        id: sensingFlowListView
        anchors.fill: parent
        visible: true
        spacing: 5
        clip: true
        model: applicationData.SensingFlowList

        delegate: Component
        {
            id: sensingFlowListDelegate

            Rectangle
            {
                id: availableSensingFlowsItem
                width: sensingFlowListView.width
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
                    text: sensingFlowListView.model[index].FlowId
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
                    text: sensingFlowListView.model[index].FlowTypeName
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
                    icon.source: "../images/SensingItem.png"
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
        width: availableSensingFlowsPage.width*0.5
        height: availableSensingFlowsPage.height
        x: availableSensingFlowsPage.width*0.5
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
                text: "Do you want to remove the sensing flow type " + sensingFlowListView.model[selectedIndex].FlowTypeName + " ?"
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
        width: availableSensingFlowsPage.width*0.75
        height: availableSensingFlowsPage.height
        x: (availableSensingFlowsPage.width - availableSensingFlowsPage.width*0.75)
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

                Label { text: "Device Id" }  Label { text: sensingFlowListView.model[selectedIndex].DeviceId }
                Label { text: "Flow Id" }  Label { text: sensingFlowListView.model[selectedIndex].FlowId }
                Label { text: "Flow Type" }  Label { text: sensingFlowListView.model[selectedIndex].FlowTypeName }
                Label { text: "Scale" }  Label { text: sensingFlowListView.model[selectedIndex].Scale }
                Label { text: "Duration" }  Label { text: sensingFlowListView.model[selectedIndex].Duration }
                Label { text: "Flow Start" }  Label { text: sensingFlowListView.model[selectedIndex].UnixEpochStartStr }
                Label { text: "Flow End" }  Label { text: sensingFlowListView.model[selectedIndex].UnixEpochEndStr }
                Label { text: "Simulation Maximum" }  Label { text: sensingFlowListView.model[selectedIndex].Maximum }
                Label { text: "Simulation Minimum" }  Label { text: sensingFlowListView.model[selectedIndex].Minimum }
                Label { text: "Unit of Measurement" }  Label { text: sensingFlowListView.model[selectedIndex].UnitOfMeasurement }
                Label { text: "Dataset Filename" }  Label { text: sensingFlowListView.model[selectedIndex].DatasetFilename }
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

        function onSensingFlowAction(fl)
        {
            console.log("SensingFlow update received")
            sensingFlowListView.model = applicationData.SensingFlowList
        }

        function onSensingFlowMessage(fl, str)
        {
        }
    }
}
