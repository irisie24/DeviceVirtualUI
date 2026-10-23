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

    onClosing:
    {
        applicationData.invokeExit();
    }

    StackView
    {
        id: rootStack
        anchors.fill: parent
        Component.onCompleted:
        {
            rootStack.push("SplashScreen.qml")
            applicationData.invokeApplicationInitialization()
        }
    }

    Component
    {
        id: shellComponent

        Page
        {
            id: mainView
            visible: true

            //-- Temporarily commented
            //visibility: Window.FullScreen
            //width: Screen.width
            //height: Screen.height
            //-- Temporarily commented

            //-- Temporarily code
            width: mainWindow.width
            height: mainWindow.height
            //-- Temporarily code

            property int iconHeight : applicationData.Theme.BarHeight*0.8
            property int iconWidth : applicationData.Theme.BarHeight*0.8
            property bool isfirst: applicationData.IsFirstRun
            property string oldPage: ""
            property bool isClosing: false

            Component.onCompleted:
            {
                stackView.push("Dashboard.qml")
            }

            Drawer
            {
                id: drawer
                width: applicationData.Theme.SideMenuExpandedWidth
                height: mainView.height

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
                            isClosing = true;
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
                        icon.source :
                        if(applicationData.IsDarkTheme === true)
                        {
                            return "../images/MenuWhite.png";
                        }
                        else
                        {
                            return "../images/MenuBlack.png";
                        }

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
                            isClosing = true;
                            drawer.close();
                            applicationData.invokeExit();
                        }
                    }
                }
            }

            Rectangle
            {
                width: parent.width - applicationData.Theme.SideMenuCollapsedWidth
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right

                Header
                {
                    id: headerPanel
                    anchors.top: parent.top
                    width: parent.width - applicationData.Theme.SideMenuCollapsedWidth
                }

                StackView
                {
                   id: stackView
                   anchors.top: headerPanel.bottom
                   anchors.right: parent.right
                   anchors.bottom: parent.top
                   anchors.left: parent.left
                }
            }
        }
    }

    Connections
    {
        target: applicationData

        function onInitializationComplete()
        {
            rootStack.replace(shellComponent)
        }

        function onOperationCancelled()
        {
            //stackView.pop()
            applicationData.invokeSaveCurrentPage("Dashboard.qml")
            //stackView.push("Dashboard.qml")
        }

        function onUserLoginSucceeded()
        {
            //stackView.pop();
            applicationData.invokeSaveCurrentPage("AvailableMeters.qml")
            //stackView.push("AvailableMeters.qml");
        }

        function onPageAction(pg)
        {
            if(pg === 0)
            {
                //stackView.pop();
                oldPage = applicationData.invokeRetreiveLastPage()
                applicationData.invokeSaveCurrentPage(oldPage)
                //stackView.push(oldPage);
            }

            if(pg === 1)
            {
                //stackView.pop();
                applicationData.invokeSaveCurrentPage("Energy.qml")
                //stackView.push("Energy.qml");
            }

            if(pg === 3)
            {
                //stackView.pop();
                applicationData.invokeSaveCurrentPage("Alarms.qml")
                //stackView.push("Alarms.qml");
            }

            if(pg === 4)
            {
                //stackView.pop();
                applicationData.invokeSaveCurrentPage("AvailableMeters.qml")
                //stackView.push("AvailableMeters.qml");
            }

            if(pg === 5)
            {
                //stackView.pop();
                applicationData.invokeSaveCurrentPage("AvailableTokens.qml")
                //stackView.push("AvailableTokens.qml");
            }

            if(pg === 6)
            {
                //stackView.pop();
                applicationData.invokeSaveCurrentPage("QRCodeScanner.qml")
                //stackView.push("QRCodeScanner.qml");
            }

            if(pg === 7)
            {
                //stackView.pop();
                applicationData.invokeSaveCurrentPage("AddMeter.qml")
                //stackView.push("AddMeter.qml");
            }

            if(pg === 8)
            {
                //stackView.pop();
                applicationData.invokeSaveCurrentPage("AddToken.qml")
                //stackView.push("AddToken.qml");
            }

            if(pg === 9)
            {
                //stackView.pop();
                applicationData.invokeSaveCurrentPage("Login.qml")
                //stackView.push("Login.qml");
            }

            if(pg === 10)
            {
                //stackView.pop();
                applicationData.invokeSaveCurrentPage("CreateUserStage1.qml")
                //stackView.push("CreateUserStage1.qml");
            }

            if(pg === 11)
            {
                //stackView.pop();
                applicationData.invokeSaveCurrentPage("CreateUserStage2.qml")
                //stackView.push("CreateUserStage2.qml");
            }

            if(pg === 12)
            {
                //stackView.pop();
                applicationData.invokeSaveCurrentPage("CreateUserStage3.qml")
                //stackView.push("CreateUserStage3.qml");
            }

            if(pg === 13)
            {
                //stackView.pop();
                applicationData.invokeSaveCurrentPage("Dashboard.qml")
                //stackView.push("Dashboard.qml")
            }

            if(pg === 14)
            {
                //stackView.pop();
                applicationData.invokeSaveCurrentPage("ResetPasscodeStage1.qml")
                //stackView.push("ResetPasscodeStage1.qml");
            }

            if(pg === 15)
            {
                //stackView.pop();
                applicationData.invokeSaveCurrentPage("ResetPasscodeStage2.qml")
                //stackView.push("ResetPasscodeStage2.qml");
            }

            if(pg === 16)
            {
                //stackView.pop();
                applicationData.invokeSaveCurrentPage("ResetPasscodeStage3.qml")
                //stackView.push("ResetPasscodeStage3.qml");
            }

            if(pg === 19)
            {
                //stackView.pop();
                applicationData.invokeSaveCurrentPage("Help.qml")
                //stackView.push("Help.qml");
            }
        }
    }
}