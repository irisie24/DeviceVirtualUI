import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Page
{
    id: availableActuationRulesPage

    property variant activationRulesModel :  []

    Component.onCompleted:
    {
        errorLabel.text = ""
        activationRulesModel = applicationData.ActiveAlarms
    }

    Rectangle
    {
        id: background
        width: parent.width
        height: parent.height
        anchors.top: parent.top
        color: applicationData.Theme.BackgroundColor
    }

    ListView
    {
        id: activationRulesListView
        width: parent.width*0.90
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.bottom: errorLabel.top
        anchors.horizontalCenter: parent.horizontalCenter
        visible: true
        spacing: 10
        clip: true
        model: activationRulesModel
        delegate: activationRulesListDelegate
    }

    Component
    {
        id: activationRulesListDelegate

        Rectangle
        {
            id: activationRuleItem
            width: activationRulesListView.width
            height: availableActuationRulesPage.width*0.1
            radius: 5
            color: applicationData.Theme.BackgroundColor

            Image
            {
                id: activeAlarmImgID
                source: "../images/Warning.png"
                width: activationRuleItem.height*0.75
                height: activationRuleItem.height*0.75
                anchors.verticalCenter: parent.verticalCenter
                anchors
                {
                    left: parent.left
                    leftMargin:  30
                }
            }

            Label
            {
                id:activeAlarmNamelbl
                font.pointSize: headerPanel.fontSizeSmall
                color: applicationData.Theme.FontColor
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors
                {
                    left: activeAlarmImgID.right
                    leftMargin: 30
                }
                text: activationRulesModel[index].AlarmName
            }
        }
    }

    Label
    {
        id: errorLabel
        anchors.bottom: alarmCommandRect.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.bold: true
        text: "Error"
        color: "red"
        wrapMode: "Wrap"
        anchors.topMargin: 5
        anchors.bottomMargin: 5
    }

    Rectangle
    {
        id: alarmCommandRect
        width: availableActuationRulesPage.width
        height: availableActuationRulesPage.width*0.2
        radius: 5
        color: applicationData.Theme.NavigationBarColor

        anchors
        {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }

        ToolButton
        {
            id: name
            height: alarmCommandRect.height*0.75
            width: alarmCommandRect.height*0.75
            icon.source: "../images/Filter.png"
            icon.color: "transparent"
            icon.height: alarmCommandRect.height*0.5
            icon.width: alarmCommandRect.height*0.5
            anchors.horizontalCenter:alarmCommandRect.horizontalCenter

            background: Rectangle
            {
                color: applicationData.Theme.NavigationBarColor
            }
        }

        Label
        {
            text: "Configure Filters"
            color: applicationData.Theme.TextPrimaryColor
            height: alarmCommandRect.height*0.5
            elide: Label.ElideRight
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
            anchors.bottom: alarmCommandRect.bottom
            anchors.horizontalCenter:alarmCommandRect.horizontalCenter
        }
    }

    Connections
    {
        target: applicationData

        function onAlarmAction()
        {
            activationRulesModel = applicationData.ActiveAlarms
        }

        function onAlarmError(str)
        {
            errorLabel.text = str
        }
    }
}

