import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page
{
    id: addDevicePage

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
            width: addDevicePage.width*0.9
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: applicationData.Theme.BarHeight/2
        }

        Grid
        {
            id: entityDetailsGridDlg
            rows: 8
            columns: 4
            width: addDevicePage.width*0.9
            anchors.right: parent.right
            anchors.top: entityDetailsText.bottom
            anchors.topMargin: applicationData.Theme.BarHeight/2
            spacing: 10

            Label { text: "Device Id" }  TextEdit { text: "" }
            Label { text: "Device Name" }  TextEdit { text: "" }
            Label { text: "Make" }  TextEdit { text: "" }
            Label { text: "Model" }  TextEdit { text: "" }
            Label { text: "Simulation Flows" }  TextEdit { text: "" }
            Label { text: "Flows Repeatable" }  CheckBox { text: "" }
            Label { text: "Flow Sequence End" }  ToolButton { icon.source: "../images/Calendar.png"; height: 32; width:32  }
            Label { text: "Simulation Mode" }  TextEdit { text: "" }
            Label { text: "Operating Maximum" }  TextEdit { text: "" }
            Label { text: "Operating Minimum" }  TextEdit { text: "" }
            Label { text: "Latitude" }  TextEdit { text: "" }
            Label { text: "Longitude" }  TextEdit { text: "" }
            Label { text: "Altitude" }  TextEdit { text: "" }
            Label { text: "Generator Model" }  ComboBox { }
            Label { text: "Unit of Measurement" }  TextEdit { text: "" }
            Label { text: "Scale" }  TextEdit { text: "" }
        }

        Rectangle
        {
            width: addDevicePage.width
            height: applicationData.Theme.BarHeight*2
            anchors.bottom: frame.bottom
            color: applicationData.Theme.PanelUpperColor
            anchors.topMargin: applicationData.Theme.BarHeight/2

            CustomButton
            {
                id:btnEntityDetailsYes
                width: addDevicePage.width*0.33
                height: applicationData.Theme.BarHeight
                text: "Save"
                isDefault: true
                accentColor: applicationData.Theme.AccentBaseColor
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: applicationData.Theme.BarHeight/2
                onClicked:
                {
                }
            }
        }
    }


    Connections
    {
        target: applicationData
    }
}
