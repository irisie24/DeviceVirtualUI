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
            width: addActuationRulePage.width
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: applicationData.Theme.BarHeight/2
            anchors.leftMargin: 10
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
            anchors.leftMargin: 10
            spacing: 10

            Label { text: "Device Id" }  ComboBox { width: 250; model: applicationData.DeviceNames } Label {width: 200} Label {width: 200}
            Label { text: "Condition" }  ComboBox { width: 200; height:applicationData.Theme.BarHeight/2; model: ["Equals", "Equals Or Lesser", "Equals Or Greater", "Lesser", "Greater"] }
            Label {width: 200} Label {width: 200}

            Label { text: "Activation Threshold" }  TextField { width: 200; height:applicationData.Theme.BarHeight/2 }
            Label { text: "Target Type" }  ComboBox { width: 200; height:applicationData.Theme.BarHeight/2; model: ["UART", "I2C", "SPI", "GPIO", "BLE"] }

            Label { text: "Target I/O Device" }  TextField { width: 200; height:applicationData.Theme.BarHeight/2 }
            Label { text: "Target Activation Value" }  TextField { width: 200; height:applicationData.Theme.BarHeight/2 }

            CheckBox { text: "Is Chained" }
            // Dummy spacing
            Label {width: 200} Label {width: 200} Label {width: 200}

            Label { text: "Rule if condition fails" }  ComboBox { width: 200; height:applicationData.Theme.BarHeight/2; model: applicationData.RuleNames }
            Label { text: "Rule if condition suceeds" }  ComboBox { width: 200; height:applicationData.Theme.BarHeight/2; model: applicationData.RuleNames }
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
                id:btnEntityDetailsSave
                width: 105
                height: applicationData.Theme.BarHeight
                text: "Save"
                isDefault: true
                accentColor: applicationData.Theme.AccentBaseColor
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: applicationData.Theme.BarHeight/2
                onClicked:
                {
                    applicationData.invokeChangePage("ActuationRules.qml");
                }
            }

            Rectangle
            {
                id: filler
                color: "transparent"
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: btnEntityDetailsSave.left
            }

            CustomButton
            {
                id:btnEntityDetailsCancel
                width: 105
                height: applicationData.Theme.BarHeight
                text: "Cancel"
                isDefault: false
                accentColor: applicationData.Theme.AccentBaseColor
                anchors.right: filler.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: applicationData.Theme.BarHeight/2
                onClicked:
                {
                    applicationData.invokeChangePage("ActuationRules.qml");
                }
            }
        }
    }


    Connections
    {
        target: applicationData
    }
}
