import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3

Page{
    id:mainPage
    property bool hadArgs: false

    function openEditor(chooserPath){
        filePath=chooserPath
        pageStack.replaceAbove(mainPage, Qt.resolvedUrl("Editor2.qml"))
        pageStack.nextPage();
    }

    SilicaFlickable {
        anchors.top: parent.top
        width: parent.width
        height: parent.height
        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                //onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }
        Column {
            id: header
            width: parent.width
            spacing: Theme.paddingMedium
            PageHeader  {
                width: parent.width
                title: qsTr("TITLE")
            }
            Label {
                id:topLabel
                width: parent.width
                anchors.bottomMargin: Theme.paddingLarge
                x: Theme.paddingLarge
                text: qsTr("TITLE")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
            }
        }
        Button{
            id:projects
            width:parent.width*(3/4)
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: header.bottom
                topMargin: Theme.paddingLarge *2
            }
            text: qsTr("Projects")
            onClicked: pageStack.push(Qt.resolvedUrl("CreatorHome.qml"))
        }
        Button{
            id:file
            width:parent.width*(3/4)
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: projects.bottom
                topMargin: Theme.paddingLarge
            }
            text: qsTr("Edit single file")
            onClicked: pageStack.push(Qt.resolvedUrl("FileManagerPage.qml"),{callback:openEditor})
        }
    }

    onStatusChanged:{
        if((status !== PageStatus.Active)){
            return;
        }
        else{
            if(!hadArgs){
                var args = Qt.application.arguments
                if (args.length > 1) {
                    filePath=args[1]
                    hadArgs = true
                    pageStack.push(Qt.resolvedUrl("Editor2.qml"))
                }
            }
        }

    }
}