import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Page
{
    id: homePage

    Component.onCompleted:
    {
    }

    background: Rectangle
    {
        color: "transparent"
    }

    CircularProgressBar
    {
        width: parent.width/3
        height: parent.width/3
        anchors.horizontalCenter: parent.horizontalCenter
        size: parent.width/3
        lineWidth: 40
        value: 66
        secondaryColor: applicationData.Theme.AccentBaseColor
        primaryColor: applicationData.Theme.AccentHighlightColor
    }
}




