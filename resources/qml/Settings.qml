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
        border.color: applicationData.Theme.BaseColor
    }

    CustomSelector
    {
        id: demoSelector
        anchors.top:  line0.bottom
        anchors.topMargin: applicationData.Theme.BarHeight
        anchors.left: line0.left
        selectorSize: 32
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
        anchors.topMargin: applicationData.Theme.BarHeight
        anchors.horizontalCenter: parent.horizontalCenter
        border.color: applicationData.Theme.AccentBaseColor
    }

    CustomSelector
    {
        id: traceSelector
        anchors.top:  line2.bottom
        anchors.topMargin: applicationData.Theme.BarHeight
        anchors.left: line0.left
        selectorSize: 32
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
        anchors.topMargin: applicationData.Theme.BarHeight
        anchors.horizontalCenter: parent.horizontalCenter
        border.color: applicationData.Theme.AccentBaseColor
    }

    CustomSelector
    {
        id: dumpSelector
        anchors.top:  line3.bottom
        anchors.topMargin: applicationData.Theme.BarHeight
        anchors.left: line0.left
        selectorSize: 32
        text: "Dump Rx/Tx"
        accentColor: applicationData.Theme.AccentBaseColor
        fontColor: applicationData.Theme.TextPrimaryColor
        backgroundColor: applicationData.Theme.BaseColor

        onClicked:
        {
            applicationData.IsDumpRxTxEnabled = dumpSelector.checked
        }
    }

    Label
    {
        id: swVersion
        text: "Version " + applicationData.AppVersion
        color: "darkgrey"
        anchors.top: dumpSelector.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 10
    }
}

