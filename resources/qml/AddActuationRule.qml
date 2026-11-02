import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page
{
    id: addActuationRulePage

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
            width: addActuationRulePage.width*0.9
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: applicationData.Theme.BarHeight/2
        }

        Grid
        {
            id: entityDetailsGridDlg
            rows: 8
            columns: 4
            width: addActuationRulePage.width
            anchors.right: parent.right
            anchors.top: entityDetailsText.bottom
            anchors.topMargin: applicationData.Theme.BarHeight/2
            spacing: 10

            Label { text: "Device Id" }  ComboBox { model: applicationData.DeviceNames }
            Label { text: "Rule Id" }  TextEdit { text: "" }
            Label { text: "Condition" }  ComboBox { }
            Label { text: "Activation Threshold" }  TextEdit { text: "" }
            Label { text: "Scale" }  TextEdit { text: "" }
            Label { text: "Target Type" }  ComboBox { }
            Label { text: "Target I/O Device" }  TextEdit { text: "" }
            Label { text: "Target Activation Value" }  TextEdit { text: "" }
            Label { text: "Is Chained" }  CheckBox { text: "" }
            Label { text: "Rule if condition fails" }  TextEdit { text: "" }
            Label { text: "Rule if condition suceeds" }  TextEdit { text: "" }


        }

        Rectangle
        {
            width: addActuationRulePage.width
            height: applicationData.Theme.BarHeight*2
            anchors.bottom: frame.bottom
            color: applicationData.Theme.PanelUpperColor
            anchors.topMargin: applicationData.Theme.BarHeight/2

            CustomButton
            {
                id:btnEntityDetailsYes
                width: addActuationRulePage.width*0.33
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
