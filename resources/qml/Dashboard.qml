import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Page
{
    id: homePage

    Component.onCompleted:
    {
        console.log("loaded")
    }

    background: Rectangle
    {
        color: "black"
    }

    CircularProgressBar
    {
        width: parent.width/3
        height: parent.width/3
        anchors.horizontalCenter: parent.horizontalCenter
    }
}




