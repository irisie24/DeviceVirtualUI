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
            id: spacer1
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
            anchors.left: spacer1.right
            source : "../images/GreenDot.png"
            visible: connectionIndicatorVisible
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

        RoundButton
        {
            height: titleRect.height*0.5
            width: titleRect.height*0.5
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: spacer2.left
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
            id: spacer2
            anchors.verticalCenter: parent.verticalCenter
            height: titleRect.height*0.5
            width: titleRect.height*0.5
            anchors.right: progressAnimator.left
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
