import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Page
{
    id: availableSensingFlowsPage

    property variant availableSensingFlowsModel :  []
    property variant availableSensingFlowsHistoriesModel :  []
    property string selectedSensingFlow:  " "

    Component.onCompleted:
    {
        sensingFlowsListView.visible = true
        tokenHistoryListView.visible = false
        sensingFlowsListSelector.currentIndex = 0
        availableSensingFlowsModel = applicationData.TokenList
        availableSensingFlowsHistoriesModel = applicationData.TokenHistoryList
        errorLabel.text = ""
    }

    Rectangle
    {
        id: background
        width: parent.width
        height: parent.height
        anchors.top: parent.bottom
        color: applicationData.Theme.BackgroundColor
    }

    CustomTab
    {
        id: sensingFlowsListSelector
        tabHeight: applicationData.Theme.BarHeight
        tabWidth: availableSensingFlowsPage.width*0.9
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
        model: ["New", "Transferred"]
        accentColor: applicationData.Theme.AccentBaseColor
        accentLowColor: applicationData.Theme.AccentHighlightColor
        controlLowColor: applicationData.Theme.WidgetPassiveColor
        controlColor: applicationData.Theme.WidgetActiveColor
        fontColor: applicationData.Theme.TextPrimaryColor

        onCurrentIndexChanged:
        {
            if(currentIndex === 0)
            {
                sensingFlowsListView.visible = true
                tokenHistoryListView.visible = false
            }

            if(currentIndex === 1)
            {
                sensingFlowsListView.visible = false
                tokenHistoryListView.visible = true
            }
        }
    }

    ListView
    {
        id: sensingFlowsListView
        width: parent.width*0.90
        anchors.top:sensingFlowsListSelector.bottom
        anchors.topMargin: 10
        anchors.bottom: errorLabel.top
        anchors.horizontalCenter: parent.horizontalCenter
        visible: true
        spacing: 10
        clip: true
        model: availableSensingFlowsModel
        delegate: sensingFlowsListDelegate
    }

    Component
    {
        id: sensingFlowsListDelegate

        Rectangle
        {
            id: availableSensingFlowsItem
            width: sensingFlowsListView.width
            height: availableSensingFlowsPage.width*0.3
            radius: 5
            color: applicationData.Theme.WidgetActiveColor

            property int tokenStatus : availableSensingFlowsModel[index].IsTokenNew

            Column
            {
                id: imagecol
                anchors.left: availableSensingFlowsItem.left
                height: parent.height
                width: availableSensingFlowsItem.height*0.45

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
                       icon.source: "../images/TokenItem.png"
                       icon.color: "transparent"
                       icon.height: availableSensingFlowsItem.height*0.33
                       icon.width: availableSensingFlowsItem.height*0.33

                       background: Rectangle
                       {
                           color: applicationData.Theme.WidgetActiveColor
                       }
                   }
                }

            }

            Column
            {
                id: infocol
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 10
                anchors.leftMargin: 5
                anchors.left: imagecol.right

                Rectangle
                {
                    id: rectData
                    height: availableSensingFlowsItem.height
                    width: availableSensingFlowsItem.height*1.5
                    color: applicationData.Theme.WidgetActiveColor

                    Text
                    {
                        id: tokenNolabel
                        text: "Token No."
                        font.pointSize: headerPanel.fontSizeSmall
                        font.bold: true
                        anchors.top: rectData.top
                        anchors.topMargin: rectData.height*0.1
                        color: applicationData.Theme.TextPrimaryColor
                    }

                    Text
                    {
                        id: tokenNoValue
                        anchors.top: tokenNolabel.bottom
                        text: availableSensingFlowsModel[index].TokenId
                        font.pointSize: headerPanel.fontSizeSmall
                        color: applicationData.Theme.TextPrimaryColor
                    }

                    Text
                    {
                        id: tokenStatusLabel
                        anchors.top: tokenNoValue.bottom
                        font.bold: true
                        text: availableSensingFlowsModel[index].TokenStatusStr
                        font.pointSize: headerPanel.fontSizeSmall
                        color: applicationData.Theme.TextPrimaryColor
                    }

                    Text
                    {
                        id: tokenValue
                        anchors.top: tokenStatusLabel.bottom
                        text: availableSensingFlowsModel[index].TokenValue.toFixed(2)+ " " + applicationData.CreditCurrency
                        font.bold: true
                        font.pointSize: headerPanel.fontSizeSmall
                        color: applicationData.Theme.TextPrimaryColor
                    }
                }
            }

            Column
            {
                id: commandcol
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 0
                anchors.right: availableSensingFlowsItem.right
                anchors.rightMargin: 10

                Rectangle
                {
                    id: rectButtons
                    height: availableSensingFlowsItem.height
                    width: (availableSensingFlowsItem.height*0.35)*3
                    color: applicationData.Theme.TextPrimaryColor

                    CustomButton
                    {
                        id: btnRemove
                        anchors.right: rectButtons.right
                        anchors.top: rectButtons.top
                        anchors.topMargin: rectButtons.height*0.1
                        width: (availableSensingFlowsItem.height*0.35)*3
                        height: availableSensingFlowsItem.height*0.35
                        isDefault: false
                        text: "Remove"
                        accentColor: applicationData.Theme.AccentBaseColor
                        onClicked:
                        {
                            confirm.itemIndex = index;
                            headerPanel.isMenuButtonVisible = false
                            selectedToken = availableSensingFlowsModel[index].TokenId;
                            confirm.itemValue = availableSensingFlowsModel[index].TokenId;
                            confirm.open();
                        }
                    }

                    CustomButton
                    {
                        id: btnApply
                        anchors.right: rectButtons.right
                        anchors.bottom: rectButtons.bottom
                        anchors.bottomMargin: rectButtons.height*0.1
                        width: (availableSensingFlowsItem.height*0.35)*3
                        height: availableSensingFlowsItem.height*0.35
                        isDefault: true
                        text: "Apply"
                        accentColor: applicationData.Theme.AccentBaseColor
                        onClicked:
                        {
                            errorLabel.text = ""
                            sensingFlowsListView.enabled = false;
                            headerPanel.isMenuButtonVisible = false;
                            tokenAddCommandRect.enabled = false;
                            addTokenBtn.enabled = false
                            addTokenBtn.visible = false
                            addLbl.visible = false
                            applicationData.invokeApplyToken(availableSensingFlowsModel[index].TokenId)
                        }
                    }
                }
            }
        }
    }

    ListView
    {
        id: tokenHistoryListView
        width: parent.width*0.90
        anchors.top:sensingFlowsListSelector.bottom
        anchors.topMargin: 10
        anchors.bottom: errorLabel.top
        anchors.horizontalCenter: parent.horizontalCenter
        visible: true
        spacing: 10
        clip: true
        model: availableSensingFlowsHistoriesModel
        delegate: tokenHistoryListDelegate
    }

    Component
    {
        id: tokenHistoryListDelegate

        Rectangle
        {
            id: availableTokenHistoriesItemID
            width: tokenHistoryListView.width
            height: availableSensingFlowsPage.width*0.3
            radius: 5
            color: applicationData.Theme.AccentBaseColor

            Column
            {
                id: imagecol
                anchors.left: availableTokenHistoriesItemID.left
                height: parent.height
                width: availableTokenHistoriesItemID.height*0.45

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
                       icon.source: "../images/TokenItem.png"
                       icon.color: "transparent"
                       icon.height: availableTokenHistoriesItemID.height*0.33
                       icon.width: availableTokenHistoriesItemID.height*0.33

                       background: Rectangle
                       {
                           color: applicationData.Theme.AccentBaseColor
                       }
                   }
                }

            }

            Column
            {
                id: infocol
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 10
                anchors.leftMargin: 5
                anchors.left: imagecol.right

                Rectangle
                {
                    id: rectData
                    height: availableTokenHistoriesItemID.height
                    width: availableTokenHistoriesItemID.height*1.5
                    color: applicationData.Theme.AccentBaseColor

                    Text
                    {
                        id: tokenNolabel
                        text: "Token No."
                        font.pointSize: headerPanel.fontSizeSmall
                        font.bold: true
                        anchors.top: rectData.top
                        anchors.topMargin: rectData.height*0.1
                        color: applicationData.Theme.TextPrimaryColor
                    }

                    Text
                    {
                        id: tokenNoValue
                        anchors.top: tokenNolabel.bottom
                        text: availableSensingFlowsHistoriesModel[index].TokenId
                        font.pointSize: headerPanel.fontSizeSmall
                        color: applicationData.Theme.TextPrimaryColor
                    }

                    Text
                    {
                        id: tokenDateLabel
                        anchors.top: tokenNoValue.bottom
                        font.bold: true
                        text: availableSensingFlowsHistoriesModel[index].AppliedDateStr
                        font.pointSize: headerPanel.fontSizeSmall
                        color: applicationData.Theme.TextPrimaryColor
                    }

                    Text
                    {
                        id: tokenValue
                        anchors.top: tokenDateLabel.bottom
                        text: availableSensingFlowsHistoriesModel[index].TokenValue.toFixed(2)+ " " + applicationData.CreditCurrency
                        font.bold: true
                        font.pointSize: headerPanel.fontSizeSmall
                        color: applicationData.Theme.TextPrimaryColor
                    }
                }
            }
        }
    }


    Label
    {
        id: errorLabel
        anchors.bottom: tokenAddCommandRect.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.bold: true
        text: "Error"
        color: "red"
        wrapMode: "Wrap"
        anchors.topMargin: 5
        anchors.bottomMargin: 5
    }

    Rectangle
    {
        id: tokenAddCommandRect
        width: availableSensingFlowsPage.width
        height: availableSensingFlowsPage.width*0.2
        radius: 5
        color: applicationData.Theme.AccentHighlightColor

        anchors
        {
            bottom:parent.bottom
            horizontalCenter: parent.horizontalCenter
        }

        ToolButton
        {
            id: addTokenBtn
            height: tokenAddCommandRect.height*0.75
            width: tokenAddCommandRect.height*0.75
            icon.source: "../images/Add.png"
            icon.color: "transparent"
            icon.height: tokenAddCommandRect.height*0.5
            icon.width: tokenAddCommandRect.height*0.5
            anchors.horizontalCenter:tokenAddCommandRect.horizontalCenter

            background: Rectangle
            {
                color: applicationData.Theme.AccentHighlightColor
            }
        }

        Label
        {
            id: addLbl
            text: "Add a new Token"
            color: applicationData.Theme.TextPrimaryColor
            height: tokenAddCommandRect.height*0.5
            elide: Label.ElideRight
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
            anchors.bottom: tokenAddCommandRect.bottom
            anchors.horizontalCenter:tokenAddCommandRect.horizontalCenter
        }
    }

    Popup
    {
        id: confirm
        visible: false
        width: availableSensingFlowsPage.width*0.9
        height: (availableSensingFlowsPage.width*0.9)/1.5
        x: (availableSensingFlowsPage.width - confirm.width)/2
        y: parent.height/3
        padding: 0
        modal: true
        property int itemIndex: 0
        property string itemValue: ""

        contentItem: Rectangle
        {
            color: applicationData.Theme.WidgetActiveColor
            anchors.fill: parent
            border.color: applicationData.Theme.AccentBaseColor

            Text
            {
                id: confirmText
                text: "Do you want to remove the sensing flow " + selectedSensingFlow + " ?"
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
                    height: sensingFlowsListView.width*0.125
                    width: sensingFlowsListView.width*0.25
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
                    height: sensingFlowsListView.width*0.125
                    width: sensingFlowsListView.width*0.25
                    text: "Yes"
                    isDefault: true
                    accentColor: applicationData.Theme.AccentBaseColor
                    onClicked:
                    {
                        confirm.close()
                        applicationData.invokeRemoveToken(availableSensingFlowsModel[confirm.itemIndex].TokenId)
                    }
                }
            }
        }
    }

    Connections
    {
        target: applicationData

        function onTokenAction()
        {
            availableSensingFlowsModel = applicationData.TokenList
            availableSensingFlowsHistoriesModel = applicationData.TokenHistoryList
            sensingFlowsListView.enabled = true;
            tokenAddCommandRect.enabled = true;
            addTokenBtn.enabled = true
            addTokenBtn.visible = true
            addLbl.visible = true
        }

        function onTokenTransferState(fl, str)
        {
            errorLabel.text = str

            if(fl === true)
            {
                errorLabel.color = "green"
            }
            else
            {
                errorLabel.color = "red"
            }

            sensingFlowsListView.enabled = true;
            tokenAddCommandRect.enabled = true;
            addTokenBtn.enabled = true
            addTokenBtn.visible = true
            addLbl.visible = true
        }
    }
}

