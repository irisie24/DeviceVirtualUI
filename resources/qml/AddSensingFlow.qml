import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page
{
    id: addSensingFLowPage

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
            width: addSensingFLowPage.width*0.9
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: applicationData.Theme.BarHeight/2
        }

        Grid
        {
            id: entityDetailsGridDlg
            rows: 8
            columns: 4
            width: addSensingFLowPage.width*0.9
            anchors.right: parent.right
            anchors.top: entityDetailsText.bottom
            anchors.topMargin: applicationData.Theme.BarHeight/2
            spacing: 10

            Label { text: "Device Id" }  TextEdit { text: "" }
            Label { text: "Flow Id" }  TextEdit { text: "" }
            Label { text: "Flow Type" }  TextEdit { text: "" }
            Label { text: "Scale" }  TextEdit { text: "" }
            Label { text: "Duration" }  TextEdit { text: "" }
            Label { text: "Flow Start" }  ToolButton { text: "" }
            Label { text: "Flow End" }  ToolButton { text: "" }
            Label { text: "Simulation Maximum" }  TextEdit { text: "" }
            Label { text: "Simulation Minimum" }  TextEdit { text: "" }
            Label { text: "Unit of Measurement" } TextEdit { text: "" }
            Label { text: "Dataset Filename" }  TextEdit { text: "" }

        }

        Rectangle
        {
            width: addSensingFLowPage.width
            height: applicationData.Theme.BarHeight*2
            anchors.bottom: frame.bottom
            color: applicationData.Theme.PanelUpperColor
            anchors.topMargin: applicationData.Theme.BarHeight/2

            CustomButton
            {
                id:btnEntityDetailsYes
                width: addSensingFLowPage.width*0.33
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
