import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.15

Rectangle
{
    id: headerID

    Material.theme: Material.Light
    Material.accent: applicationData.Theme.AccentBaseColor

    height: applicationData.Theme.BarHeight
    width: parent.width

    property string headerTitle: ""
    property bool isConnectionIndicatorVisible: true

    property double fontSizeNormal: fontlabel.font.pointSize
    property double fontSizeSmall: fontlabel.font.pointSize -  2.5
    property double fontSizeTiny: fontlabel.font.pointSize - 5.0
    property double fontSizeBig: fontlabel.font.pointSize +  2.5
    property double fontSizeLarge: fontlabel.font.pointSize + 5.0

    Component.onCompleted:
    {
        fontSizeNormal = fontlabel.font.pointSize
        fontSizeSmall = fontlabel.font.pointSize -  2.5
        fontSizeTiny = fontlabel.font.pointSize - 5.0
        fontSizeBig = fontlabel.font.pointSize +  2.5
        fontSizeLarge = fontlabel.font.pointSize + 5.0
        headerTitle = "Dashboard"

        //progressAnimator.visible = false
        progressAnimator.visible = true

        // if(applicationData.IsAppConnected === true && isConnectionIndicatorVisible === true && applicationData.ShowIndicator)
        // {
        //     connectionStatusIcon.visible = true
        // }
        // else
        // {
        //     connectionStatusIcon.visible = false
        // }
        connectionStatusIcon.visible = true
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
            id: spacer
            anchors.verticalCenter: parent.verticalCenter
            height: titleRect.height*0.5
            width: titleRect.height*0.5
            anchors.left: parent.left
        }

        Image
        {
            id: connectionStatusIcon
            height: titleRect.height*0.5
            width: titleRect.height*0.5
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: spacer.right
            source : "../images/GreenDot.png"
            //visible: isConnectionIndicatorVisible
            visible: true
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
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: fontSizeBig
        }

        BusyIndicator
        {
            id: progressAnimator
            height: titleRect.height*0.85
            width: titleRect.height*0.85
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: titleRect.right
            anchors.rightMargin: 0
            running: true
            Material.accent: applicationData.Theme.AccentBaseColor
            Material.theme:
            {
                if(applicationData.IsDarkTheme === true)
                {
                    return Material.Dark;
                }
                else
                {
                    return Material.Light;
                }
            }

            //visible: isProgressStateVisible
            visible: true
        }
    }

    Connections
    {
        target: applicationData

        function onProgressIndicatorsOff()
        {
            progressPerCent.visible = false;
            progressAnimator.visible = false;
        }

        function onProgressIndicatorsOn()
        {
            if(applicationData.ShowIndicator)
            {
                progressPerCent.visible = true;
                progressAnimator.visible = true;
            }
        }

        function onNetworkIndicatorsOff()
        {
            connectionStatusIcon.visible = false
        }

        function onNetworkIndicatorsOn()
        {
            if(applicationData.ShowIndicator)
            {
                connectionStatusIcon.visible = true
            }
        }
    }
}
