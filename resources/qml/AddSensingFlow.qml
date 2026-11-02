import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page
{
    id: addSensingFLowPage
    property string currentDate: ''
    property string calendarMode: 's'

    Component.onCompleted:
    {
        startDate.text = Qt.formatDate(datepickctl.selectedDate, 'dd/MM/yyyy').toString() + ' 00:00:00';
        endDate.text = Qt.formatDate(datepickctl.selectedDate, 'dd/MM/yyyy').toString() + ' 23:59:59';
    }

    contentItem: Rectangle
    {
        id: frame
        color: applicationData.Theme.PanelUpperColor
        anchors.fill: parent
        border.color: applicationData.Theme.LineColor

        Text
        {
            id: entityDetailsText
            text: "Sensing Flow Details"
            font.bold: true
            color: applicationData.Theme.TextPrimaryColor
            wrapMode: "Wrap"
            width: addSensingFLowPage.width
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: applicationData.Theme.BarHeight/2
            anchors.leftMargin: 10
        }

        Grid
        {
            id: entityDetailsGridDlg
            rows: 10
            columns: 4
            width: addSensingFLowPage.width
            anchors.right: parent.right
            anchors.top: entityDetailsText.bottom
            anchors.topMargin: applicationData.Theme.BarHeight/2
            anchors.leftMargin: 10
            spacing: 10

            Label { text: "Device Id" }  ComboBox { width: 250; model: applicationData.DeviceNames }  Label {width: 200} Label {width: 200}
            Label { text: "Flow Type" }  ComboBox { width: 200; height:applicationData.Theme.BarHeight/2; model: ["BaseLine", "Normal", "Spikes", "Dead", "Stuck", "Offset", "Noise", "Linear Drift", "Stepped Drift"] }
            Label {width: 200} Label {width: 200}

            Label { text: "Simulation Maximum" }  TextField { width: 200; height:applicationData.Theme.BarHeight/2 }
            Label { text: "Simulation Minimum" }  TextField { width: 200; height:applicationData.Theme.BarHeight/2 }
            Label { text: "Duration" }  TextField { width: 200; height:applicationData.Theme.BarHeight/2 }
            Label { text: "Dataset Filename" }  TextField { width: 200; height:applicationData.Theme.BarHeight/2 }

            Label { text: "Flow Start" }
            Rectangle
            {
                height: 32; width:235; color: "transparent"
                ToolButton { id: dtpick1; anchors.left: parent.left;  icon.source: "../images/Calendar.png"; height: 32; width:32; onClicked: { calendarMode = 's' ; datepickerpopup.open() }  }
                Rectangle { id: dummy1; height: 32; width:32; anchors.left: dtpick1.right; color: "transparent"}
                Label {id: startDate; anchors.left: dummy1.right;}
            }

            Label { text: "Flow End" }
            Rectangle
            {
                height: 32; width:235; color: "transparent"
                ToolButton { id: dtpick2; anchors.left: parent.left;  icon.source: "../images/Calendar.png"; height: 32; width:32; onClicked: { calendarMode = 'e' ;datepickerpopup.open() }  }
                Rectangle { id: dummy2; height: 32; width:32; anchors.left: dtpick2.right; color: "transparent"}
                Label {id: endDate; anchors.left: dummy2.right;}
            }
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
                    applicationData.invokeChangePage("SensingFlows.qml");
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
                    applicationData.invokeChangePage("SensingFlows.qml");
                }
            }
        }
    }

    Popup
    {
        id: datepickerpopup
        visible: false
        width: 400
        height: 400
        x: (addSensingFLowPage.width - datepickerpopup.width)/2
        y: parent.height/3
        padding: 0
        modal: true
        property int itemIndex: 0
        property string itemValue: ""

        contentItem: Rectangle
        {
            anchors.fill: parent
            color: applicationData.Theme.PanelUpperColor
            border.color: applicationData.Theme.AccentBaseColor

            CustomDatePicker
            {
                id: datepickctl
                height: parent.width*0.75
                width: parent.width*0.75
                fontColor: applicationData.Theme.TextPrimaryColor
                controlColor: applicationData.Theme.PanelUpperColor
                accentColor: applicationData.Theme.AccentBaseColor
                Component.onCompleted: set(new Date()) // today
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                onClicked:
                {
                    currentDate = selectedDate;
                }
            }

            Grid
            {
                id: gridDlg
                rows: 1
                columns: 2
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                anchors.rightMargin: 5
                anchors.right: parent.right
                spacing: 10

                CustomButton
                {
                    id:btnCancel
                    width: 105
                    height: applicationData.Theme.BarHeight
                    text: "Cancel"
                    isDefault: false
                    accentColor: applicationData.Theme.AccentBaseColor
                    onClicked:
                    {
                         datepickerpopup.close();
                    }
                }

                CustomButton
                {
                    id:btnSave
                    width: 105
                    height: applicationData.Theme.BarHeight
                    text: "Save"
                    isDefault: true
                    accentColor: applicationData.Theme.AccentBaseColor
                    onClicked:
                    {
                        if(calendarMode === 's')
                        {
                            startDate.text = Qt.formatDate(datepickctl.selectedDate, 'dd/MM/yyyy').toString() + ' 00:00:00';
                        }
                        else
                        {
                            endDate.text = Qt.formatDate(datepickctl.selectedDate, 'dd/MM/yyyy').toString() + ' 23:59:59';
                        }

                        datepickerpopup.close()
                    }
                }
            }
        }
    }

    Connections
    {
        target: applicationData
    }
}
