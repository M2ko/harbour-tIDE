import QtQuick 2.2
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3

/* Copyright (C) 2017  Teemu Makkonen
 *
 * This file is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation. You may also find the details of GPL v3 at:
 * http://www.gnu.org/licenses/gpl-3.0.txt
 *
 * If you have any questions regarding the use of this file, feel free to
 * contact the author of this file, or the owner of the project in which
 * this file belongs to.
 */

Page {
    id: page
    SilicaListView {
        id: listView
        anchors.top: parent.top
        width: parent.width
        height: Theme.itemSizeHuge
        spacing: Theme.paddingMedium
        VerticalScrollDecorator {}
        PullDownMenu {

        }

        header: Column {
            width: parent.width
            spacing: Theme.paddingMedium
            PageHeader  {
                width: parent.width
                title: qsTr("Git")
                _titleItem.color: rootMode ? reverseColor(Theme.highlightColor) :Theme.highlightColor
            }
            Label {
                width: parent.width
                anchors.bottomMargin: Theme.paddingLarge
                x: Theme.paddingLarge
                text: qsTr("Git status")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
            }
        }
        model: ListModel {
            id: lmodel
            Component.onCompleted: lmodel.gitStatus()
            function gitStatus() {
                py.call('git.gitStatus', [projectPath], function(result) {
                    console.log(result)
                    if(!result) {
                        init.visible = true
                    }
                    else {
                        for (var i=0; i<result.length; i++) {
                            lmodel.append(result[i]);
                        }
                    }
                });
            }
        }
        delegate: ListItem {
            id: litem
            width: parent.width
            height: Theme.itemSizeSmall
            anchors {
                left: parent.left
                right: parent.right
            }
            Label {
                id: status
                text: lmodel[index]
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                x: Theme.paddingMedium
            }
        }
    }
    Item {
        id: init
        width: parent.width
        height: Theme.itemSizeMedium
        visible: false
        anchors {
            top: listView.bottom
            left: parent.left
            right: parent.right
        }
        Label {
            wrapMode: Text.WordWrap
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            x: Theme.paddingMedium
            text: qsTr("You need to init git first")
        }
    }
    Python {
        id: py

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('./../python'));
            importModule('git', function () {});
        }
        onError: {
            showError(traceback)
            // when an exception is raised, this error handler will be called
            console.log('python error: ' + traceback);

        }
    }

}