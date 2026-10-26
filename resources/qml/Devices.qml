import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3

Page
{
    id: availableDevicesPage

    Material.theme: Material.Light
    Material.accent: applicationData.Theme.AccentColor

    property variant availableDevicessModel :  []
    property string selectedDevice:  " "


    Component.onCompleted:
    {
        confirm.close()
        availableDevicessModel = applicationData.DeviceList
        errorLabel.text = ""
    }

    Rectangle
    {
        id: background
        anchors.fill: parent
        color: applicationData.Theme.BaseColor
    }


    ListView
    {
        id: deviceListView
        width: parent.width*0.90
        anchors.top:parent.top
        anchors.topMargin: 5
        anchors.bottom: errorLabel.top
        anchors.horizontalCenter: parent.horizontalCenter
        visible: true
        spacing: 5
        clip: true
        model: availableDevicessModel
        delegate: deviceListDelegate
    }

    Component
    {
        id: deviceListDelegate

        Rectangle
        {
            id: availableDevicesItem
            width: deviceListView.width
            height: availableDevicesPage.width*0.3
            radius: 5
            color: applicationData.Theme.ControlColor

            property string deviceStatus  : availableDevicessModel[index].StatusStr

            Column
            {
                id: imagecol
                anchors.left: availableDevicesItem.left
                height: parent.height
                width: availableDevicesItem.height*0.45

                Rectangle
                {
                    height: imagecol.height
                    width: imagecol.width
                    color: "transparent"

                   ToolButton
                   {
                       id: imageBtnID
                       height: imagecol.width*0.9
                       width: imagecol.width*0.9
                       anchors.verticalCenter: parent.verticalCenter

                       onClicked:
                       {
                           applicationData.invokeSelectMeter(availableDevicessModel[index].SerialNo)
                       }

                       icon.source: "../images/MeterItem.png"
                       icon.color: "transparent"
                       icon.height: availableDevicesItem.height*0.35
                       icon.width: availableDevicesItem.height*0.35

                       background: Rectangle
                       {
                           color: applicationData.Theme.ControlColor
                       }
                   }
                }
            }

            Column
            {
                id: infocol
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 20
                anchors.left: imagecol.right

                Rectangle
                {
                    id: rectData
                    height: availableDevicesItem.height
                    width:  availableDevicesItem.height*1.5
                    color: applicationData.Theme.ControlColor

                    Text
                    {
                        id: meterNamelabel
                        text: availableDevicessModel[index].MeterName
                        font.pointSize: headerPanel.fontSizeSmall
                        font.bold: true
                        anchors.top: rectData.top
                        anchors.topMargin: rectData.height*0.1
                        color: applicationData.Theme.FontColor
                    }

                    Text
                    {
                        id: serialNolabel
                        anchors.top: meterNamelabel.bottom
                        text: availableDevicessModel[index].SerialNo
                        font.pointSize: headerPanel.fontSizeNormal
                        font.bold: availableDevicessModel[index].IsSelected ? true : false
                        font.underline: availableDevicessModel[index].IsSelected ? true : false
                        color: applicationData.Theme.FontColor
                    }

                    Text
                    {
                        id: syncDatelabel
                        anchors.top: serialNolabel.bottom
                        text: availableDevicessModel[index].LastSyncStr
                        font.pointSize: headerPanel.fontSizeSmall
                        font.bold: false
                        color: applicationData.Theme.FontColor
                    }

                    Text
                    {
                        id: rssilabel
                        anchors.top: syncDatelabel.bottom
                        text: "Signal " + availableDevicessModel[index].RSSIStr
                        font.pointSize: headerPanel.fontSizeSmall
                        font.bold: false
                        color: applicationData.Theme.FontColor
                    }

                    Text
                    {
                        anchors.top: rssilabel.bottom
                        font.pointSize: headerPanel.fontSizeNormal
                        color:
                        {
                            if(deviceStatus === "0")
                                return "red"
                            else
                                return "green"
                        }

                        font.bold:
                        {
                            if(deviceStatus === "0")
                                return false
                            else
                                return true
                        }

                        elide: Label.ElideRight
                        horizontalAlignment: Qt.AlignHCenter
                        verticalAlignment: Qt.AlignVCenter
                        text:
                        {
                            if(deviceStatus === "0")
                                return "Not Connected"
                            else
                                return "Connected"
                        }

                        visible:
                        {
                            if(availableDevicessModel[index].SerialNo === "EDM1DEMO" || availableDevicessModel[index].SerialNo === "EDM2DEMO")
                            {
                                return false
                            }
                            else
                            {
                                return true
                            }
                        }
                    }
                }
            }

            Column
            {
                id: commandcol
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: availableDevicesItem.right
                anchors.rightMargin: 10

                Rectangle
                {
                    id: rectButtons
                    height: availableDevicesItem.height
                    width: (availableDevicesItem.height*0.35)*3
                    color: applicationData.Theme.ControlColor

                    CustomButton
                    {
                        id: btnRemove
                        text: "Remove"
                        anchors.right: rectButtons.right
                        anchors.top: rectButtons.top
                        anchors.topMargin: rectButtons.height*0.1
                        width: (availableDevicesItem.height*0.35)*3
                        height: availableDevicesItem.height*0.35
                        isDefault: false
                        accentColor: applicationData.Theme.AccentColor
                        enabled:
                        {
                            if(deviceStatus === "0")
                                return true
                            else
                                return false
                        }

                        visible: true

                        onClicked:
                        {
                            confirm.itemIndex = index;
                            selectedMeter = availableDevicessModel[index].SerialNo;
                            confirm.open();
                        }
                    }

                    CustomButton
                    {
                        id: btnConnect
                        anchors.right: rectButtons.right
                        anchors.bottom: rectButtons.bottom
                        anchors.bottomMargin: rectButtons.height*0.1
                        width: (availableDevicesItem.height*0.35)*3
                        height: availableDevicesItem.height*0.35
                        isDefault: true
                        accentColor: applicationData.Theme.AccentColor
                        enabled:
                        {
                            if(deviceStatus === "0" && applicationData.IsAppConnected === true)
                            {
                                return false;
                            }

                            if(deviceStatus === "0" && applicationData.IsAppConnected === false)
                            {
                                return true;
                            }

                            if(deviceStatus === "1" && applicationData.IsAppConnected === true)
                            {
                                return true;
                            }

                            if(deviceStatus === "1" && applicationData.IsAppConnected === false)
                            {
                                return false;
                            }
                        }

                        visible: true

                        text:
                        {
                            if(deviceStatus === "0")
                                return "Connect"
                            else
                                return "Disconnect"
                        }

                        onClicked:
                        {
                            errorLabel.text = ""
                            deviceListView.enabled = false;
                            deviceAddCommandRect.enabled = false;
                            addDeviceBtn.enabled = false;
                            addDeviceBtn.visible = false;
                            addLbl.visible = false;
                            headerPanel.isMenuButtonVisible = false
                            if(deviceStatus === "0")
                            {
                                applicationData.invokeConnectMeter(availableDevicessModel[index].SerialNo)
                            }
                            else
                            {
                                if(deviceStatus === "1")
                                {
                                    applicationData.invokeDisconnectMeter(availableDevicessModel[index].SerialNo)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Label
    {
        id: errorLabel
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.bold: true
        text: "Error"
        color: "red"
        wrapMode: "Wrap"
        anchors.topMargin: 5
        anchors.bottomMargin: 5
    }

    Popup
    {
        id: confirm
        visible: false
        width: availableDevicesPage.width*0.9
        height: (availableDevicesPage.width*0.9)/1.5
        x: (availableDevicesPage.width - confirm.width)/2
        y: parent.height/3
        padding: 0
        modal: true
        property int itemIndex: 0
        property string itemValue: ""

        contentItem: Rectangle
        {
            color: applicationData.Theme.ControlColor
            anchors.fill: parent
            border.color: applicationData.Theme.AccentBaseColor

            Text
            {
                id: confirmText
                text: "Do you want to remove the meter " + selectedDevice + " ?"
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
                    width: deviceListView.width*0.25
                    height: deviceListView.width*0.125
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
                    width: deviceListView.width*0.25
                    height: deviceListView.width*0.125
                    text: "Yes"
                    isDefault: true
                    accentColor: applicationData.Theme.AccentBaseColor
                    onClicked:
                    {
                        confirm.close()
                        applicationData.invokeRemoveMeter(availableDevicessModel[confirm.itemIndex].SerialNo)
                    }
                }
            }
        }
    }

    Connections
    {
        target: applicationData

        function onDeviceAction(fl)
        {
            confirm.close()
            availableDevicessModel = applicationData.MeterList

            if(fl === true)
            {
                deviceListView.enabled = true;
                deviceAddCommandRect.enabled = true;
                headerPanel.isMeterNameVisible = true;
                headerPanel.isSyncDateVisible = true;
                headerPanel.isMenuButtonVisible = true
                addDeviceBtn.enabled = true;
                addDeviceBtn.visible = true;
                addLbl.visible = true;
            }
            else
            {
                deviceListView.enabled = false;
                deviceAddCommandRect.enabled = false;
                headerPanel.isMeterNameVisible = false;
                headerPanel.isSyncDateVisible = false;
                headerPanel.isMenuButtonVisible = false
                addDeviceBtn.enabled = false;
                addDeviceBtn.visible = false;
                addLbl.visible = false;
            }
        }

        function onDeviceMessage(fl, str)
        {
            if(fl === true)
            {
                errorLabel.color = "green"
            }
            else
            {
                errorLabel.color = "red"
            }

            errorLabel.text = str
            confirm.close()
            availableDevicessModel = applicationData.MeterList
        }
    }
}


