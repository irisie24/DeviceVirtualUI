import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Page
{
    id: settingsPage

    Component.onCompleted:
    {
        if(applicationData.IsDemoMode === true)
        {
            demoSelector.checked = true;
        }
        else
        {
            demoSelector.checked = false;
        }

        if(applicationData.IsTraceEnabled === true)
        {
            traceSelector.checked = true;
        }
        else
        {
            traceSelector.checked = false;
        }

        if(applicationData.IsTraceEnabled === true)
        {
            dumpSelector.enabled = true;
        }
        else
        {
            dumpSelector.enabled = false;
        }

        if(applicationData.IsDumpRxTxEnabled === true)
        {
            dumpSelector.checked = true;
        }
        else
        {
            dumpSelector.checked = false;
        }
    }

    Rectangle
    {
        id: background
        color: applicationData.Theme.BaseColor
        anchors.fill: parent
    }

    Rectangle
    {
        id: line0
        width: settingsPage.width*0.9
        height: 2
        border.width: 1
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        border.color: applicationData.Theme.AccentBaseColor
    }

    CustomSelector
    {
        id: demoSelector
        anchors.top:  line0.bottom
        anchors.topMargin: applicationData.Theme.BarHeight/3
        anchors.left: line0.left
        selectorSize: 28
        text: "Demo Mode"
        accentColor: applicationData.Theme.AccentBaseColor
        fontColor: applicationData.Theme.TextPrimaryColor
        backgroundColor: applicationData.Theme.BaseColor

        onClicked:
        {
            applicationData.IsDemoMode = demoSelector.checked
        }
    }

    Rectangle
    {
        id: line2
        width: settingsPage.width*0.9
        height: 2
        border.width: 1
        anchors.top: demoSelector.bottom
        anchors.topMargin: applicationData.Theme.BarHeight/3
        anchors.horizontalCenter: parent.horizontalCenter
        border.color: applicationData.Theme.AccentBaseColor
    }

    CustomSelector
    {
        id: traceSelector
        anchors.top:  line2.bottom
        anchors.topMargin: applicationData.Theme.BarHeight/3
        anchors.left: line0.left
        selectorSize: 28
        text: "Trace"
        accentColor: applicationData.Theme.AccentBaseColor
        fontColor: applicationData.Theme.TextPrimaryColor
        backgroundColor: applicationData.Theme.BaseColor

        onClicked:
        {
            applicationData.IsTraceEnabled = traceSelector.checked

            if(applicationData.IsTraceEnabled === true)
            {
                dumpSelector.enabled = true;
            }
            else
            {
                dumpSelector.enabled = false;
            }
        }
    }

    Rectangle
    {
        id: line3
        width: settingsPage.width*0.9
        height: 2
        border.width: 1
        anchors.top: traceSelector.bottom
        anchors.topMargin: applicationData.Theme.BarHeight/3
        anchors.horizontalCenter: parent.horizontalCenter
        border.color: applicationData.Theme.AccentBaseColor
    }

    CustomSelector
    {
        id: dumpSelector
        anchors.top:  line3.bottom
        anchors.topMargin: applicationData.Theme.BarHeight/3
        anchors.left: line0.left
        selectorSize: 28
        text: "Dump Rx/Tx"
        accentColor: applicationData.Theme.AccentBaseColor
        fontColor: applicationData.Theme.TextPrimaryColor
        backgroundColor: applicationData.Theme.BaseColor

        onClicked:
        {
            applicationData.IsDumpRxTxEnabled = dumpSelector.checked
        }
    }

    Rectangle
    {
        id: line4
        width: settingsPage.width*0.9
        height: 2
        border.width: 1
        anchors.top: dumpSelector.bottom
        anchors.topMargin: applicationData.Theme.BarHeight/3
        anchors.horizontalCenter: parent.horizontalCenter
        border.color: applicationData.Theme.AccentBaseColor
    }

    Grid
    {
        id: mqttDetailsGrid
        rows: 3
        columns: 4
        width: parent.width*0.9
        anchors.right: parent.right
        anchors.topMargin: applicationData.Theme.BarHeight/3
        anchors.top: line4.bottom
        spacing: 10

        Label { font.pointSize: applicationData.Theme.FontSmall; text: "MQTT Host Address" }  TextField { width: 200; height:applicationData.Theme.BarHeight/2 }
        Label { font.pointSize: applicationData.Theme.FontSmall; text: "MQTT Port" }  TextField { width: 200; height:applicationData.Theme.BarHeight/2 }
        Label { font.pointSize: applicationData.Theme.FontSmall; text: "MQTT Client ID" }  TextField { width: 200; height:applicationData.Theme.BarHeight/2  }
        Label { font.pointSize: applicationData.Theme.FontSmall; text: "MQTT User" }  TextField { width: 200; height:applicationData.Theme.BarHeight/2 }
        Label { font.pointSize: applicationData.Theme.FontSmall; text: "MQTT Password" }  TextField { width: 200; height:applicationData.Theme.BarHeight/2 }
    }

    Rectangle
    {
        id: line5
        width: settingsPage.width*0.9
        height: 2
        border.width: 1
        anchors.top: mqttDetailsGrid.bottom
        anchors.topMargin: applicationData.Theme.BarHeight/3
        anchors.horizontalCenter: parent.horizontalCenter
        border.color: applicationData.Theme.AccentBaseColor
    }

    Grid
    {
        id: dbDetailsGrid
        rows: 3
        columns: 4
        width: parent.width*0.9
        anchors.right: parent.right
        anchors.topMargin: applicationData.Theme.BarHeight/3
        anchors.top: line5.bottom
        spacing: 10

        Label { font.pointSize: applicationData.Theme.FontSmall; text: "Database Name" }  TextField { width: 200; height:applicationData.Theme.BarHeight/2  }
        Label { font.pointSize: applicationData.Theme.FontSmall; text: "Database Host Address" }  TextField { width: 200; height:applicationData.Theme.BarHeight/2 }
        Label { font.pointSize: applicationData.Theme.FontSmall; text: "Database Port" }  TextField { width: 200; height:applicationData.Theme.BarHeight/2 }
        Label { font.pointSize: applicationData.Theme.FontSmall; text: "Database User" }  TextField { width: 200; height:applicationData.Theme.BarHeight/2 }
        Label { font.pointSize: applicationData.Theme.FontSmall; text: "Database Password" }  TextField { width: 200; height:applicationData.Theme.BarHeight/2 }
    }


    Rectangle
    {
        id: line6
        width: settingsPage.width*0.9
        height: 2
        border.width: 1
        anchors.top: dbDetailsGrid.bottom
        anchors.topMargin: applicationData.Theme.BarHeight/3
        anchors.horizontalCenter: parent.horizontalCenter
        border.color: applicationData.Theme.AccentBaseColor
    }

    Rectangle
    {
        id: rect4
        width: settingsPage.width*0.95
        height: applicationData.Theme.BarHeight*2
        anchors.top: line6.bottom
        anchors.topMargin: 10

        CustomButton
        {
            id:btnSave
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
            }
        }

        Rectangle
        {
            id: filler
            color: "transparent"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: btnSave.left
        }

        CustomButton
        {
            id:btnCancel
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
            }
        }
    }

    Label
    {
        id: swVersion
        text: "Version " + applicationData.AppVersion
        color: "darkgrey"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 10
    }
}

