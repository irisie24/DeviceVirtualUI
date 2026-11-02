import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page
{
    id: addDevicePage
    property string currentDate: ''

    Component.onCompleted:
    {
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
            text: "Device Details"
            font.bold: true
            color: applicationData.Theme.TextPrimaryColor
            wrapMode: "Wrap"
            width: addDevicePage.width
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: applicationData.Theme.BarHeight/2
            anchors.leftMargin: 10
        }

        Grid
        {
            id: entityDetailsGridDlg
            rows: 9
            columns: 4
            width: addDevicePage.width
            anchors.right: parent.right
            anchors.top: entityDetailsText.bottom
            anchors.topMargin: applicationData.Theme.BarHeight/2
            anchors.leftMargin: 10
            spacing: 10

            Label { text: "Device Name" }  TextField { width: 200; height:applicationData.Theme.BarHeight/2  }
            Label { text: "Make" }  TextField { width: 200; height:applicationData.Theme.BarHeight/2 }
            Label { text: "Model" }  TextField { width: 200; height:applicationData.Theme.BarHeight/2 }
            Label { text: "Operating Maximum" }  TextField { width: 200; height:applicationData.Theme.BarHeight/2 }
            Label { text: "Operating Minimum" }  TextField { width: 200; height:applicationData.Theme.BarHeight/2 }
            Label { text: "No. Of Simulation Flows" }  TextField { width: 200; height:applicationData.Theme.BarHeight/2 }
            Label { text: "Simulation Mode" }  ComboBox { width: 200; height:applicationData.Theme.BarHeight/2; model: ["Realtime", "Dataset"] }
            Label { text: "Generator Model" }  ComboBox { width: 200; height:applicationData.Theme.BarHeight/2; model: ["Bernoulli", "Markov (Two-State)", "Semi-Markov", "Renewal Process", "Poisson Onset", "Negative Binomial Runs", "Hidden Markov", "Beta-Bernoulli Mixture", "Block Segment", "Deterministic Pattern", "Unknown"] }
            Label { text: "Latitude" }  TextField { width: 200; height:applicationData.Theme.BarHeight/2  }
            Label { text: "Longitude" }  TextField { width: 200; height:applicationData.Theme.BarHeight/2  }
            Label { text: "Altitude" }  TextField { width: 200; height:applicationData.Theme.BarHeight/2  }
            Label { text: "Scale" }  TextField { width: 200; height:applicationData.Theme.BarHeight/2  }
            Label { text: "Unit of Measurement" }  ComboBox { width: 200; height:applicationData.Theme.BarHeight/2; model: ["degC", "cusec", "bar", "KHz", "cms", "rpm", "volts", "mAmps", "ohms", "dB"] }
            // Dummy spacing
            Label {width: 200} Label {width: 200}
            CheckBox { text: "Flows Repeatable"; width: 200; height:applicationData.Theme.BarHeight/2 } Label {width: 200} Label {width: 200} Label {width: 200}
            Label { text: "Flow Sequence End" }

            Rectangle
            {
                height: 32; width:235; color: "transparent"
                ToolButton { id: dtpick; anchors.left: parent.left;  icon.source: "../images/Calendar.png"; height: 32; width:32; onClicked: { datepickerpopup.open() }  }
                Rectangle { id: dummy; height: 32; width:32; anchors.left: dtpick.right; color: "transparent"}
                Label {id: endDate; anchors.left: dummy.right;}
            }
        }

        Rectangle
        {
            width: addDevicePage.width
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
                    applicationData.invokeChangePage("Devices.qml");
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
                    applicationData.invokeChangePage("Devices.qml");
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
        x: (addDevicePage.width - datepickerpopup.width)/2
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
                        endDate.text = Qt.formatDate(datepickctl.selectedDate, 'dd/MM/yyyy').toString() + ' 23:59:59';
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
