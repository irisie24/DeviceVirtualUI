import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

ApplicationWindow
{
    id: mainWindow
    visible: true

    //-- Temporarily commented
    //visibility: Window.FullScreen
    //width: Screen.width
    //height: Screen.height
    //-- Temporarily commented

    //-- Temporarily code
    width: 1024
    height: 768
    //-- Temporarily code

    minimumHeight: height
    minimumWidth: width
    property int iconHeight: 32
    property int iconWidth: 32

    Component.onCompleted:
    {
        headerPanel.visible = false
        collapsedMenu.visible = false
        stackView.push("SplashScreen.qml")
        applicationData.invokeApplicationInitialization()
    }

    onClosing:
    {
        applicationData.invokeExit();
    }

    Drawer
    {
        id: drawer
        width: applicationData.Theme.SideMenuExpandedWidth
        height: mainWindow.height

        background: Rectangle
        {
            color: applicationData.Theme.AccentHighlightColor
            radius: 0
        }

        Column
        {
            anchors.fill: parent

            ItemDelegate
            {
                text: qsTr("Home")
                width: parent.width

                onClicked:
                {
                    drawer.close()
                    applicationData.invokeSaveCurrentPage("Dashboard.qml")
                    stackView.pop()
                    stackView.push("Dashboard.qml")
                    headerPanel.addIconVisible = false
                    headerPanel.progressIndicatorVisible = false;
                }

                icon
                {
                    source: "../images/Home.png"
                    width: iconWidth
                    height: iconHeight
                }

                enabled:
                {
                    if(applicationData.CurrentMeterSerialNo === "")
                    {
                        return false
                    }

                    return true
                }
            }

            MenuSeparator
            {
                width: parent.width
            }

            ItemDelegate
            {
                text: qsTr("Devices")
                width: parent.width
                onClicked:
                {
                    applicationData.invokeSaveCurrentPage("Devices.qml")
                    stackView.pop()
                    stackView.push("Devices.qml")
                    headerPanel.headerTitle = "Devices"
                    headerPanel.addIconVisible = true;
                    headerPanel.progressIndicatorVisible = false;
                    headerPanel.connectionIndicatorVisible = true;
                    drawer.close()
                }

                icon
                {
                    source: "../images/Device.png"
                    width: iconWidth
                    height: iconHeight
                }
            }

            MenuSeparator
            {
                width: parent.width
            }

            ItemDelegate
            {
                text: qsTr("Sensing Flows")
                width: parent.width

                onClicked:
                {
                    drawer.close()
                    applicationData.invokeSaveCurrentPage("SensingFlows.qml")
                    stackView.pop()
                    stackView.push("SensingFlows.qml")
                    headerPanel.headerTitle = "Sensing Flows"
                    headerPanel.addIconVisible = true;
                    headerPanel.progressIndicatorVisible = false;
                    headerPanel.connectionIndicatorVisible = true;
                }

                icon
                {
                    source: "../images/Sensing.png"
                    width: iconWidth
                    height: iconHeight
                }

                enabled:
                {
                    if(applicationData.CurrentMeterSerialNo === "")
                    {
                        return false
                    }

                    return true
                }
            }

            ItemDelegate
            {
                text: qsTr("Actuation Rules")
                width: parent.width

                onClicked:
                {
                    drawer.close()
                    applicationData.invokeSaveCurrentPage("ActuationRules.qml")
                    stackView.pop()
                    headerPanel.headerTitle = "Actuation Rules"
                    headerPanel.addIconVisible = true;
                    headerPanel.progressIndicatorVisible = false;
                    headerPanel.connectionIndicatorVisible = true;
                    stackView.push("ActuationRules.qml")
                }

                icon
                {
                    source: "../images/Actuation.png"
                    width: iconWidth
                    height: iconHeight
                }

                enabled:
                {
                    if(applicationData.CurrentMeterSerialNo === "")
                    {
                        return false
                    }

                    return true
                }
            }

            ItemDelegate
            {
                text: qsTr("Signal Graph")
                width: parent.width

                onClicked:
                {
                    drawer.close()
                    applicationData.invokeSaveCurrentPage("SignalGraph.qml")
                    stackView.pop()
                    headerPanel.headerTitle = "Signal Graph"
                    headerPanel.addIconVisible = false;
                    headerPanel.progressIndicatorVisible = false;
                    headerPanel.connectionIndicatorVisible = true;
                    stackView.push("SignalGraph.qml")
                }

                icon
                {
                    source: "../images/SignalGraph.png"
                    width: iconWidth
                    height: iconHeight
                }

                enabled:
                {
                    if(applicationData.CurrentMeterSerialNo === "")
                    {
                        return false
                    }

                    return true
                }
            }

            MenuSeparator
            {
                width: parent.width
            }

            ItemDelegate
            {
                text: qsTr("Settings")
                width: parent.width
                onClicked:
                {
                    applicationData.invokeSaveCurrentPage("Settings.qml")
                    stackView.pop()
                    stackView.push("Settings.qml")
                    headerPanel.headerTitle = "Settings"
                    headerPanel.addIconVisible = false;
                    headerPanel.progressIndicatorVisible = false;
                    headerPanel.connectionIndicatorVisible = false;
                    drawer.close()
                }

                icon
                {
                    source: "../images/Settings.png"
                    width: iconWidth
                    height: iconHeight
                }
            }

            ItemDelegate
            {
                text: qsTr("Help")
                width: parent.width
                onClicked:
                {
                    applicationData.invokeSaveCurrentPage("Help.qml")
                    stackView.pop()
                    stackView.push("Help.qml")
                    drawer.close()
                    headerPanel.headerTitle = "Help"
                    headerPanel.addIconVisible = false;
                    headerPanel.progressIndicatorVisible = false;
                    headerPanel.connectionIndicatorVisible = false;
                }

                icon
                {
                    source: "../images/Help.png"
                    width: iconWidth
                    height: iconHeight
                }
            }

            ItemDelegate
            {
                text: qsTr("Trace")
                width: parent.width
                onClicked:
                {
                    applicationData.invokeSaveCurrentPage("Trace.qml")
                    stackView.pop()
                    stackView.push("Trace.qml")
                    drawer.close()
                    headerPanel.headerTitle = "Trace"
                    headerPanel.addIconVisible = false;
                    headerPanel.progressIndicatorVisible = false;
                    headerPanel.connectionIndicatorVisible = false;
                }

                icon
                {
                    source: "../images/Trace.png"
                    width: iconWidth
                    height: iconHeight
                }
            }

            MenuSeparator
            {
                width: parent.width
            }

            ItemDelegate
            {
                text: qsTr("Exit")
                width: parent.width
                onClicked:
                {
                    drawer.close();
                    applicationData.invokeExit();
                }

                icon
                {
                    source: "../images/Exit.png"
                    width: iconWidth
                    height: iconHeight
                }
            }
        }
    }

    Rectangle
    {
        id: collapsedMenu
        visible: true
        height: parent.height
        width: applicationData.Theme.SideMenuCollapsedWidth
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        color: applicationData.Theme.PanelLowerColor

        ColumnLayout
        {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10

            ToolButton
            {
                icon.source : "../images/Menu.png"
                icon.width:  iconWidth
                icon.height: iconHeight
                onClicked:
                {
                    drawer.open();
                }
            }

            // bottom utility icons — settings, logout etc.
            ToolButton
            {
                icon.source: "../images/Home.png"
                icon.width:  iconWidth
                icon.height: iconHeight
                onClicked:
                {
                    stackView.pop()
                    applicationData.invokeSaveCurrentPage("Dashboard.qml")
                    stackView.push("Dashboard.qml")
                    headerPanel.addIconVisible = false
                    headerPanel.progressIndicatorVisible = false;
                }
            }

            // spacer to push bottom items down
            Item
            {
                Layout.fillHeight: true
            }

            ToolButton
            {
                icon.source: "../images/Exit.png"
                icon.width:  iconWidth
                icon.height: iconHeight
                onClicked:
                {
                    drawer.close();
                    applicationData.invokeExit();
                }
            }
        }
    }

    Header
    {
        id: headerPanel
        anchors.top: parent.top
        anchors.left: collapsedMenu.right
        width: parent.width - applicationData.Theme.SideMenuCollapsedWidth
    }

    StackView
    {
       id: stackView
       anchors.top: headerPanel.bottom
       anchors.right: parent.right
       anchors.bottom: parent.bottom
       anchors.left: collapsedMenu.right
    }

    Connections
    {
        target: applicationData

        function onInitializationComplete()
        {
            headerPanel.visible = true
            collapsedMenu.visible = true
            stackView.pop()
            applicationData.invokeSaveCurrentPage("Dashboard.qml")
            stackView.push("Dashboard.qml")
            headerPanel.addIconVisible = false
            headerPanel.progressIndicatorVisible = false;
        }

        function onOperationCancelled()
        {
            stackView.pop()
            applicationData.invokeSaveCurrentPage("Dashboard.qml")
            stackView.push("Dashboard.qml")
            headerPanel.addIconVisible = false
            headerPanel.progressIndicatorVisible = false;
        }

        function onUserLoginSucceeded()
        {
            stackView.pop();
            applicationData.invokeSaveCurrentPage("Dashboard.qml")
            stackView.push("Dashboard.qml");
            headerPanel.addIconVisible = false
            headerPanel.progressIndicatorVisible = false;
        }

        function onPageAction(pg)
        {
            stackView.pop();
            applicationData.invokeSaveCurrentPage(pg)
            stackView.push(pg);

            if((pg) === "AddDevice.qml")
            {
                headerPanel.headerTitle = "New Device"
                headerPanel.addIconVisible = false
            }

            if((pg) === "AddSensingFlow.qml")
            {
                headerPanel.headerTitle = "New Sensing Flow"
                headerPanel.addIconVisible = false
            }

            if((pg) === "AddActuationRule.qml")
            {
                headerPanel.headerTitle = "New Activation Rule"
                headerPanel.addIconVisible = false
            }
        }
    }
}