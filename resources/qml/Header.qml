import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle
{
    id: headerID

    height: applicationData.Theme.BarHeight
    width: parent.width

    property string headerTitle: ""
    property bool connectionIndicatorVisible: true
    property bool progressIndicatorVisible: true
    property bool addIconVisible: true
    signal drawerInvoked()

    Component.onCompleted:
    {
        headerTitle = "Dashboard"
    }

    Label
    {
        id: fontlabel
        text: ""
    }

    Rectangle
    {
        id: titleRect
        width: parent.width
        height: headerID.height
        color: applicationData.Theme.BaseColor

        Rectangle
        {
            id: spacer0
            anchors.verticalCenter: parent.verticalCenter
            height: titleRect.height*0.5
            width: titleRect.height*0.5
            anchors.left: parent.left
        }

        ToolButton
        {
            id: menuButton
            icon.source : "../images/Menu.png"
            icon.width:  titleRect.height*0.5
            icon.height: titleRect.height*0.5
            anchors.verticalCenter: parent.verticalCenter
            onClicked:
            {
                drawerInvoked();
            }
        }

        Rectangle
        {
            id: spacer1
            anchors.verticalCenter: parent.verticalCenter
            height: titleRect.height*0.5
            width: titleRect.height*0.5
            anchors.left: menuButton.right
        }

        Label
        {
            text: headerTitle
            font.bold: true
            color: applicationData.Theme.TextPrimaryColor
            elide: Label.ElideRight
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: spacer1.right
        }

        //

        Rectangle
        {
            id: spacer2
            anchors.verticalCenter: parent.verticalCenter
            height: titleRect.height*0.5
            width: titleRect.height*0.5
            anchors.right: parent.right
        }

        Image
        {
            id: connectionStatusIcon
            height: titleRect.height*0.5
            width: titleRect.height*0.5
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: spacer2.left
            source : "../images/Connected.png"
            visible: connectionIndicatorVisible
        }

        Rectangle
        {
            id: spacer3
            anchors.verticalCenter: parent.verticalCenter
            height: titleRect.height*0.5
            width: titleRect.height*0.5
            anchors.right: connectionStatusIcon.left
        }

        RoundButton
        {
            height: titleRect.height*0.5
            width: titleRect.height*0.5
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: spacer3.left
            visible: addIconVisible
            Image
            {
                height: titleRect.height*0.5
                width: titleRect.height*0.5
                id: name
                source: "../images/Add.png"
            }

            onClicked:
            {
                applicationData.invokeAddCommand();
            }
        }

        Rectangle
        {
            id: spacer4
            anchors.verticalCenter: parent.verticalCenter
            height: titleRect.height*0.5
            width: titleRect.height*0.5
            anchors.right: titleRect.left
        }

        BusyIndicator
        {
            id: progressAnimator
            height: titleRect.height*0.85
            width: titleRect.height*0.85
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: spacer4.left
            anchors.rightMargin: 0
            running: true
            visible: progressIndicatorVisible
        }
    }

    Connections
    {
        target: applicationData

        function onProgressIndicatorsOff()
        {
            progressIndicatorVisible.visible = false;
        }

        function onProgressIndicatorsOn()
        {
            if(applicationData.ShowIndicator)
            {
                progressIndicatorVisible.visible = true;
            }
        }

        function onNetworkIndicatorsOff()
        {
            connectionIndicatorVisible.visible = false
        }

        function onNetworkIndicatorsOn()
        {
            if(applicationData.ShowIndicator)
            {
                connectionIndicatorVisible.visible = true
            }
        }
    }
}
