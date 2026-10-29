import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Page
{
    id: availableActuationRulesPage

    property string selectedActivationRuleName : ""
    property string selectedActivationRuleId : ""

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
        id: actuationRuleListView
        anchors.fill: parent
        visible: true
        spacing: 5
        clip: true
        model: applicationData.ActuationRuleList

        delegate: Component
        {
            id: actuationRuleListDelegate

            Rectangle
            {
                id: availableActuationRulesItem
                width: actuationRuleListView.width
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
                    text: actuationRuleListView.model[index].RuleId
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
                    text: actuationRuleListView.model[index].ConditionName
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
                    icon.source: "../images/ActuationItem.png"
                    icon.width:  parent.height*0.5
                    icon.height: parent.height*0.5
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: spacer3.left
                    onClicked:
                    {
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
                        selectedActivationRuleName = actuationRuleListView.model[index].ConditionName
                        selectedActivationRuleId = actuationRuleListView.model[index].RuleId
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
        width: availableActuationRulesPage.width*0.5
        height: availableActuationRulesPage.height
        x: availableActuationRulesPage.width*0.5
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
                text: "Do you want to remove the actuation rule for " + selectedActivationRuleName + " ?"
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
        width: availableActuationRulesPage.width*0.5
        height: availableActuationRulesPage.height
        x: availableActuationRulesPage.width*0.5
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
                id: entityDetailsText
                text: "Under Development"
                color: applicationData.Theme.TextPrimaryColor
                wrapMode: "Wrap"
                width: confirm.width*0.9
                anchors.centerIn: parent
            }

            Grid
            {
                id: entityDetailsGridDlg
                rows: 1
                columns: 2
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                anchors.rightMargin: 10
                anchors.right: parent.right
                spacing: 10

                CustomButton
                {
                    id:btnEntityDetailsNo
                    width: confirm.width*0.33
                    height: applicationData.Theme.BarHeight
                    text: "No"
                    isDefault: false
                    accentColor: applicationData.Theme.AccentBaseColor
                    onClicked:
                    {
                        entityDetails.close();
                    }
                }

                CustomButton
                {
                    id:btnEntityDetailsYes
                    width: confirm.width*0.33
                    height: applicationData.Theme.BarHeight
                    text: "Yes"
                    isDefault: true
                    accentColor: applicationData.Theme.AccentBaseColor
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

        function onActuationRuleAction(fl)
        {
            console.log("ActuationRule update received")
            actuationRuleListView.model = applicationData.ActuationRuleList
        }

        function onActuationRuleMessage(fl, str)
        {
        }

        function onActuationRuleAdd()
        {
            console.log("ActuationRule add received")
            entityDetails.open()
        }

    }
}
