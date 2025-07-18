﻿/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          2.11
import QtQuick.Controls 2.4
import QtQuick.Dialogs  1.3
import QtQuick.Layouts  1.11
import QtQuick.Window   2.11

import QGroundControl               1.0
import QGroundControl.Palette       1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap     1.0
import Mavlinkpaotou 1.0
/// @brief Native QML top level window
/// All properties defined here are visible to all QML pages.
ApplicationWindow {
    id:             mainWindow
    minimumWidth:   ScreenTools.isMobile ? Screen.width  : Math.min(ScreenTools.defaultFontPixelWidth * 100, Screen.width)
    minimumHeight:  ScreenTools.isMobile ? Screen.height : Math.min(ScreenTools.defaultFontPixelWidth * 50, Screen.height)
    visible:        true

    Component.onCompleted: {
        //-- Full screen on mobile or tiny screens
        if (ScreenTools.isMobile || Screen.height / ScreenTools.realPixelDensity < 120) {
            mainWindow.showFullScreen()
        } else {
            width   = ScreenTools.isMobile ? Screen.width  : Math.min(250 * Screen.pixelDensity, Screen.width)
            height  = ScreenTools.isMobile ? Screen.height : Math.min(150 * Screen.pixelDensity, Screen.height)
        }

        // Start the sequence of first run prompt(s)
        firstRunPromptManager.nextPrompt()
    }

    QtObject {
        id: firstRunPromptManager

        property var currentDialog:     null
        property var rgPromptIds:       QGroundControl.corePlugin.firstRunPromptsToShow()
        property int nextPromptIdIndex: 0

        function clearNextPromptSignal() {
            if (currentDialog) {
                currentDialog.closed.disconnect(nextPrompt)
            }
        }

        function nextPrompt() {
            if (nextPromptIdIndex < rgPromptIds.length) {
                var component = Qt.createComponent(QGroundControl.corePlugin.firstRunPromptResource(rgPromptIds[nextPromptIdIndex]));
                currentDialog = component.createObject(mainWindow)
                currentDialog.closed.connect(nextPrompt)
                currentDialog.open()
                nextPromptIdIndex++
            } else {
                currentDialog = null
                showPreFlightChecklistIfNeeded()
            }
        }
    }

    property var                _rgPreventViewSwitch:       [ false ]

    readonly property real      _topBottomMargins:          ScreenTools.defaultFontPixelHeight * 0.5

    //-------------------------------------------------------------------------
    //-- Global Scope Variables

    QtObject {
        id: globals

        readonly property var       activeVehicle:                  QGroundControl.multiVehicleManager.activeVehicle
        readonly property real      defaultTextHeight:              ScreenTools.defaultFontPixelHeight
        readonly property real      defaultTextWidth:               ScreenTools.defaultFontPixelWidth
        readonly property var       planMasterControllerFlyView:    flightView.planController
        readonly property var       guidedControllerFlyView:        flightView.guidedController

        property var                planMasterControllerPlanView:   null
        property var                currentPlanMissionItem:         planMasterControllerPlanView ? planMasterControllerPlanView.missionController.currentPlanViewItem : null

        // Property to manage RemoteID quick acces to settings page
        property bool               commingFromRIDIndicator:        false
    }

    /// Default color palette used throughout the UI
    QGCPalette { id: qgcPal; colorGroupEnabled: true }

    //-------------------------------------------------------------------------
    //-- Actions

    signal armVehicleRequest
    signal forceArmVehicleRequest
    signal disarmVehicleRequest
    signal vtolTransitionToFwdFlightRequest
    signal vtolTransitionToMRFlightRequest
    signal showPreFlightChecklistIfNeeded

    //-------------------------------------------------------------------------
    //-- Global Scope Functions

    /// Prevent view switching
    function pushPreventViewSwitch() {
        _rgPreventViewSwitch.push(true)
    }

    /// Allow view switching
    function popPreventViewSwitch() {
        if (_rgPreventViewSwitch.length == 1) {
            console.warn("mainWindow.popPreventViewSwitch called when nothing pushed")
            return
        }
        _rgPreventViewSwitch.pop()
    }

    /// @return true: View switches are not currently allowed
    function preventViewSwitch() {
        return _rgPreventViewSwitch[_rgPreventViewSwitch.length - 1]
    }

    function viewSwitch(currentToolbar) {
        toolDrawer.visible      = false
        toolDrawer.toolSource   = ""
        flightView.visible      = false
        planView.visible        = false
        toolbar.currentToolbar  = currentToolbar
    }

    function showFlyView() {
        if (!flightView.visible) {
            mainWindow.showPreFlightChecklistIfNeeded()
        }
        viewSwitch(toolbar.flyViewToolbar)
        flightView.visible = true
    }

    function showPlanView() {
        viewSwitch(toolbar.planViewToolbar)
        planView.visible = true
    }

    function showTool(toolTitle, toolSource, toolIcon) {
        toolDrawer.backIcon     = flightView.visible ? "/qmlimages/PaperPlane.svg" : "/qmlimages/Plan.svg"
        toolDrawer.toolTitle    = toolTitle
        toolDrawer.toolSource   = toolSource
        toolDrawer.toolIcon     = toolIcon
        toolDrawer.visible      = true
    }

    function showAnalyzeTool() {
        showTool(qsTr("Analyze Tools"), "AnalyzeView.qml", "/qmlimages/Analyze.svg")
    }

    function showSetupTool() {
        showTool(qsTr("Vehicle Setup"), "SetupView.qml", "/qmlimages/Gears.svg")
    }

    function showSettingsTool() {
        showTool(qsTr("Application Settings"), "AppSettings.qml", "/res/QGCLogoWhite")
    }

    //-------------------------------------------------------------------------
    //-- Global simple message dialog

    function showMessageDialog(dialogTitle, dialogText, buttons = StandardButton.Ok, acceptFunction = null) {
        simpleMessageDialogComponent.createObject(mainWindow, { title: dialogTitle, text: dialogText, buttons: buttons, acceptFunction: acceptFunction }).open()
    }

    // This variant is only meant to be called by QGCApplication
    function _showMessageDialog(dialogTitle, dialogText) {
        showMessageDialog(dialogTitle, dialogText)
    }

    Component {
        id: simpleMessageDialogComponent

        QGCSimpleMessageDialog {
        }
    }

    /// Saves main window position and size
    MainWindowSavedState {
        window: mainWindow
    }

    property bool _forceClose: false

    function finishCloseProcess() {
        _forceClose = true
        // For some reason on the Qml side Qt doesn't automatically disconnect a signal when an object is destroyed.
        // So we have to do it ourselves otherwise the signal flows through on app shutdown to an object which no longer exists.
        firstRunPromptManager.clearNextPromptSignal()
        QGroundControl.linkManager.shutdown()
        QGroundControl.videoManager.stopVideo();
        mainWindow.close()
    }

    // On attempting an application close we check for:
    //  Unsaved missions - then
    //  Pending parameter writes - then
    //  Active connections

    property string closeDialogTitle: qsTr("Close %1").arg(QGroundControl.appName)

    function checkForUnsavedMission() {
        if (globals.planMasterControllerPlanView && globals.planMasterControllerPlanView.dirty) {
            showMessageDialog(closeDialogTitle,
                              qsTr("You have a mission edit in progress which has not been saved/sent. If you close you will lose changes. Are you sure you want to close?"),
                              StandardButton.Yes | StandardButton.No,
                              function() { checkForPendingParameterWrites() })
        } else {
            checkForPendingParameterWrites()
        }
    }

    function checkForPendingParameterWrites() {
        for (var index=0; index<QGroundControl.multiVehicleManager.vehicles.count; index++) {
            if (QGroundControl.multiVehicleManager.vehicles.get(index).parameterManager.pendingWrites) {
                mainWindow.showMessageDialog(closeDialogTitle,
                    qsTr("You have pending parameter updates to a vehicle. If you close you will lose changes. Are you sure you want to close?"),
                    StandardButton.Yes | StandardButton.No,
                    function() { checkForActiveConnections() })
                return
            }
        }
        checkForActiveConnections()
    }

    function checkForActiveConnections() {
        if (QGroundControl.multiVehicleManager.activeVehicle) {
            mainWindow.showMessageDialog(closeDialogTitle,
                qsTr("There are still active connections to vehicles. Are you sure you want to exit?"),
                StandardButton.Yes | StandardButton.No,
                function() { finishCloseProcess() })
        } else {
            finishCloseProcess()
        }
    }

    onClosing: {
        if (!_forceClose) {
            close.accepted = false
            checkForUnsavedMission()
        }
    }

    //-------------------------------------------------------------------------
    /// Main, full window background (Fly View)
    background: Item {
        id:             rootBackground
        anchors.fill:   parent
    }

    //-------------------------------------------------------------------------
    /// Toolbar
    header: MainToolBar {
        id:         toolbar
        height:     ScreenTools.toolbarHeight
        visible:    !(QGroundControl.videoManager.fullScreen && flightView.visible)
    }

    footer: LogReplayStatusBar {
        visible: QGroundControl.settingsManager.flyViewSettings.showLogReplayStatusBar.rawValue
    }

    function showToolSelectDialog() {
        if (!mainWindow.preventViewSwitch()) {
            toolSelectDialogComponent.createObject(mainWindow).open()
        }
    }

    Component {
        id: toolSelectDialogComponent

        QGCPopupDialog {
            id:         toolSelectDialog
            title:      qsTr("Select Tool")
            buttons:    StandardButton.Close

            property real _toolButtonHeight:    ScreenTools.defaultFontPixelHeight * 3
            property real _margins:             ScreenTools.defaultFontPixelWidth

            ColumnLayout {
                width:  innerLayout.width + (toolSelectDialog._margins * 2)
                height: innerLayout.height + (toolSelectDialog._margins * 2)

                ColumnLayout {
                    id:             innerLayout
                    Layout.margins: toolSelectDialog._margins
                    spacing:        ScreenTools.defaultFontPixelWidth

                    SubMenuButton {
                        id:                 setupButton
                        height:             toolSelectDialog._toolButtonHeight
                        Layout.fillWidth:   true
                        text:               qsTr("Vehicle Setup")
                        imageColor:         qgcPal.text
                        imageResource:      "/qmlimages/Gears.svg"
                        onClicked: {
                            if (!mainWindow.preventViewSwitch()) {
                                toolSelectDialog.close()
                                mainWindow.showSetupTool()
                            }
                        }
                    }

                    SubMenuButton {
                        id:                 analyzeButton
                        height:             toolSelectDialog._toolButtonHeight
                        Layout.fillWidth:   true
                        text:               qsTr("Analyze Tools")
                        imageResource:      "/qmlimages/Analyze.svg"
                        imageColor:         qgcPal.text
                        visible:            QGroundControl.corePlugin.showAdvancedUI
                        onClicked: {
                            if (!mainWindow.preventViewSwitch()) {
                                toolSelectDialog.close()
                                mainWindow.showAnalyzeTool()
                            }
                        }
                    }

                    SubMenuButton {
                        id:                 settingsButton
                        height:             toolSelectDialog._toolButtonHeight
                        Layout.fillWidth:   true
                        text:               qsTr("Application Settings")
                        imageResource:      "/res/QGCLogoFull"
                        imageColor:         "transparent"
                        visible:            !QGroundControl.corePlugin.options.combineSettingsAndSetup
                        onClicked: {
                            if (!mainWindow.preventViewSwitch()) {
                                toolSelectDialog.close()
                                mainWindow.showSettingsTool()
                            }
                        }
                    }

                    ColumnLayout {
                        width:                  innerLayout.width
                        spacing:                0
                        Layout.alignment:       Qt.AlignHCenter

                        QGCLabel {
                            id:                     versionLabel
                            text:                   qsTr("%1 Version").arg(QGroundControl.appName)
                            font.pointSize:         ScreenTools.smallFontPointSize
                            wrapMode:               QGCLabel.WordWrap
                            Layout.maximumWidth:    parent.width
                            Layout.alignment:       Qt.AlignHCenter
                        }

                        QGCLabel {
                            text:                   QGroundControl.qgcVersion
                            font.pointSize:         ScreenTools.smallFontPointSize
                            wrapMode:               QGCLabel.WrapAnywhere
                            Layout.maximumWidth:    parent.width
                            Layout.alignment:       Qt.AlignHCenter

                            QGCMouseArea {
                                id:                 easterEggMouseArea
                                anchors.topMargin:  -versionLabel.height
                                anchors.fill:       parent

                                onClicked: {
                                    if (mouse.modifiers & Qt.ControlModifier) {
                                        QGroundControl.corePlugin.showTouchAreas = !QGroundControl.corePlugin.showTouchAreas
                                        showTouchAreasNotification.open()
                                    } else if (ScreenTools.isMobile || mouse.modifiers & Qt.ShiftModifier) {
                                        if(!QGroundControl.corePlugin.showAdvancedUI) {
                                            advancedModeOnConfirmation.open()
                                        } else {
                                            advancedModeOffConfirmation.open()
                                        }
                                    }
                                }

                                // This allows you to change this on mobile
                                onPressAndHold: {
                                    QGroundControl.corePlugin.showTouchAreas = !QGroundControl.corePlugin.showTouchAreas
                                    showTouchAreasNotification.open()
                                }

                                MessageDialog {
                                    id:                 showTouchAreasNotification
                                    title:              qsTr("Debug Touch Areas")
                                    text:               qsTr("Touch Area display toggled")
                                    standardButtons:    StandardButton.Ok
                                }

                                MessageDialog {
                                    id:                 advancedModeOnConfirmation
                                    title:              qsTr("Advanced Mode")
                                    text:               QGroundControl.corePlugin.showAdvancedUIMessage
                                    standardButtons:    StandardButton.Yes | StandardButton.No
                                    onYes: {
                                        QGroundControl.corePlugin.showAdvancedUI = true
                                        advancedModeOnConfirmation.close()
                                    }
                                }

                                MessageDialog {
                                    id:                 advancedModeOffConfirmation
                                    title:              qsTr("Advanced Mode")
                                    text:               qsTr("Turn off Advanced Mode?")
                                    standardButtons:    StandardButton.Yes | StandardButton.No
                                    onYes: {
                                        QGroundControl.corePlugin.showAdvancedUI = false
                                        advancedModeOffConfirmation.close()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }


    FlyView {
        id:             flightView
        anchors.fill:   parent
    }

    PlanView {
        id:             planView
        anchors.fill:   parent
        visible:        false
    }

    Drawer {
        id:             toolDrawer
        width:          mainWindow.width
        height:         mainWindow.height
        edge:           Qt.LeftEdge
        dragMargin:     0
        closePolicy:    Drawer.NoAutoClose
        interactive:    false
        visible:        false

        property alias backIcon:    backIcon.source
        property alias toolTitle:   toolbarDrawerText.text
        property alias toolSource:  toolDrawerLoader.source
        property alias toolIcon:    toolIcon.source

        // Unload the loader only after closed, otherwise we will see a "blank" loader in the meantime
        onClosed: {
            toolDrawer.toolSource = ""
        }
        
        Rectangle {
            id:             toolDrawerToolbar
            anchors.left:   parent.left
            anchors.right:  parent.right
            anchors.top:    parent.top
            height:         ScreenTools.toolbarHeight
            color:          qgcPal.toolbarBackground

            RowLayout {
                anchors.leftMargin: ScreenTools.defaultFontPixelWidth
                anchors.left:       parent.left
                anchors.top:        parent.top
                anchors.bottom:     parent.bottom
                spacing:            ScreenTools.defaultFontPixelWidth

                QGCColoredImage {
                    id:                     backIcon
                    width:                  ScreenTools.defaultFontPixelHeight * 2
                    height:                 ScreenTools.defaultFontPixelHeight * 2
                    fillMode:               Image.PreserveAspectFit
                    mipmap:                 true
                    color:                  qgcPal.text
                }

                QGCLabel {
                    id:     backTextLabel
                    text:   qsTr("Back")
                }

                QGCLabel {
                    font.pointSize: ScreenTools.largeFontPointSize
                    text:           "<"
                }

                QGCColoredImage {
                    id:                     toolIcon
                    width:                  ScreenTools.defaultFontPixelHeight * 2
                    height:                 ScreenTools.defaultFontPixelHeight * 2
                    fillMode:               Image.PreserveAspectFit
                    mipmap:                 true
                    color:                  qgcPal.text
                }

                QGCLabel {
                    id:             toolbarDrawerText
                    font.pointSize: ScreenTools.largeFontPointSize
                }
            }

            QGCMouseArea {
                anchors.top:        parent.top
                anchors.bottom:     parent.bottom
                x:                  parent.mapFromItem(backIcon, backIcon.x, backIcon.y).x
                width:              (backTextLabel.x + backTextLabel.width) - backIcon.x
                onClicked: {
                    toolDrawer.visible      = false
                }
            }
        }

        Loader {
            id:             toolDrawerLoader
            anchors.left:   parent.left
            anchors.right:  parent.right
            anchors.top:    toolDrawerToolbar.bottom
            anchors.bottom: parent.bottom

            Connections {
                target:                 toolDrawerLoader.item
                ignoreUnknownSignals:   true
                onPopout:               toolDrawer.visible = false
            }
        }
    }

    //-------------------------------------------------------------------------
    //-- Critical Vehicle Message Popup

    function showCriticalVehicleMessage(message) {
        indicatorPopup.close()
        if (criticalVehicleMessagePopup.visible || QGroundControl.videoManager.fullScreen) {
            // We received additional wanring message while an older warning message was still displayed.
            // When the user close the older one drop the message indicator tool so they can see the rest of them.
            criticalVehicleMessagePopup.dropMessageIndicatorOnClose = true
        } else {
            criticalVehicleMessagePopup.criticalVehicleMessage      = message
            criticalVehicleMessagePopup.dropMessageIndicatorOnClose = false
            criticalVehicleMessagePopup.open()
        }
    }

    Popup {
        id:                 criticalVehicleMessagePopup
        y:                  ScreenTools.defaultFontPixelHeight
        x:                  Math.round((mainWindow.width - width) * 0.5)
        width:              mainWindow.width  * 0.55
        height:             criticalVehicleMessageText.contentHeight + ScreenTools.defaultFontPixelHeight * 2
        modal:              false
        focus:              true
        closePolicy:        Popup.CloseOnEscape

        property alias  criticalVehicleMessage:        criticalVehicleMessageText.text
        property bool   dropMessageIndicatorOnClose:   false

        background: Rectangle {
            anchors.fill:   parent
            color:          qgcPal.alertBackground
            radius:         ScreenTools.defaultFontPixelHeight * 0.5
            border.color:   qgcPal.alertBorder
            border.width:   2

            Rectangle {
                anchors.horizontalCenter:   parent.horizontalCenter
                anchors.top:                parent.top
                anchors.topMargin:          -(height / 2)
                color:                      qgcPal.alertBackground
                radius:                     ScreenTools.defaultFontPixelHeight * 0.25
                border.color:               qgcPal.alertBorder
                border.width:               1
                width:                      vehicleWarningLabel.contentWidth + _margins
                height:                     vehicleWarningLabel.contentHeight + _margins

                property real _margins: ScreenTools.defaultFontPixelHeight * 0.25

                QGCLabel {
                    id:                 vehicleWarningLabel
                    anchors.centerIn:   parent
                    text:               qsTr("Vehicle Error")
                    font.pointSize:     ScreenTools.smallFontPointSize
                    color:              qgcPal.alertText
                }
            }

            Rectangle {
                id:                         additionalErrorsIndicator
                anchors.horizontalCenter:   parent.horizontalCenter
                anchors.bottom:             parent.bottom
                anchors.bottomMargin:       -(height / 2)
                color:                      qgcPal.alertBackground
                radius:                     ScreenTools.defaultFontPixelHeight * 0.25
                border.color:               qgcPal.alertBorder
                border.width:               1
                width:                      additionalErrorsLabel.contentWidth + _margins
                height:                     additionalErrorsLabel.contentHeight + _margins
                visible:                    criticalVehicleMessagePopup.dropMessageIndicatorOnClose

                property real _margins: ScreenTools.defaultFontPixelHeight * 0.25

                QGCLabel {
                    id:                 additionalErrorsLabel
                    anchors.centerIn:   parent
                    text:               qsTr("Additional errors received")
                    font.pointSize:     ScreenTools.smallFontPointSize
                    color:              qgcPal.alertText
                }
            }
        }

        QGCLabel {
            id:                 criticalVehicleMessageText
            width:              criticalVehicleMessagePopup.width - ScreenTools.defaultFontPixelHeight
            anchors.centerIn:   parent
            wrapMode:           Text.WordWrap
            color:              qgcPal.alertText
            textFormat:         TextEdit.RichText
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                criticalVehicleMessagePopup.close()
                if (criticalVehicleMessagePopup.dropMessageIndicatorOnClose) {
                    criticalVehicleMessagePopup.dropMessageIndicatorOnClose = false;
                    QGroundControl.multiVehicleManager.activeVehicle.resetErrorLevelMessages();
                    toolbar.dropMessageIndicatorTool();
                }
            }
        }
    }

    //-------------------------------------------------------------------------
    //-- Indicator Popups

    function showIndicatorPopup(item, dropItem, dim = true) {
        indicatorPopup.currentIndicator = dropItem
        indicatorPopup.currentItem = item
        indicatorPopup.dim = dim
        indicatorPopup.open()
    }

    function hideIndicatorPopup() {
        indicatorPopup.close()
        indicatorPopup.currentItem = null
        indicatorPopup.currentIndicator = null
    }

    Popup {
        id:             indicatorPopup
        padding:        ScreenTools.defaultFontPixelWidth * 0.75
        modal:          true
        focus:          true
        dim:            false
        closePolicy:    Popup.CloseOnEscape | Popup.CloseOnPressOutside
        property var    currentItem:        null
        property var    currentIndicator:   null
        background: Rectangle {
            width:  loader.width
            height: loader.height
            color:  Qt.rgba(0,0,0,0)
        }
        Loader {
            id:             loader
            onLoaded: {
                var centerX = mainWindow.contentItem.mapFromItem(indicatorPopup.currentItem, 0, 0).x - (loader.width * 0.5)
                if((centerX + indicatorPopup.width) > (mainWindow.width - ScreenTools.defaultFontPixelWidth)) {
                    centerX = mainWindow.width - indicatorPopup.width - ScreenTools.defaultFontPixelWidth
                }
                indicatorPopup.x = centerX
            }
        }
        onOpened: {
            loader.sourceComponent = indicatorPopup.currentIndicator
        }
        onClosed: {
            loader.sourceComponent = null
            indicatorPopup.currentIndicator = null
        }
    }

    // We have to create the popup windows for the Analyze pages here so that the creation context is rooted
    // to mainWindow. Otherwise if they are rooted to the AnalyzeView itself they will die when the analyze viewSwitch
    // closes.

    function createrWindowedAnalyzePage(title, source) {
        var windowedPage = windowedAnalyzePage.createObject(mainWindow)
        windowedPage.title = title
        windowedPage.source = source
    }

    Component {
        id: windowedAnalyzePage

        Window {
            width:      ScreenTools.defaultFontPixelWidth  * 100
            height:     ScreenTools.defaultFontPixelHeight * 40
            visible:    true

            property alias source: loader.source

            Rectangle {
                color:          QGroundControl.globalPalette.window
                anchors.fill:   parent

                Loader {
                    id:             loader
                    anchors.fill:   parent
                    onLoaded:       item.popped = true
                }
            }

            onClosing: {
                visible = false
                source = ""
            }
        }
    }


        property int count: 0
        property int enable_flag: 0

        property int button2_flag: 1
        property int button3_flag: 1
        property int button4_flag: 1
        property int button5_flag: 1
        property int button6_flag: 1
        property int button7_flag: 1
        property int button8_flag: 1
        property int button9_flag: 1
        property int button10_flag: 1
        property int button11_flag: 1

        Mavlinkpaotou
        {
           id:paotou_mavlink
        }


        GridLayout
        {

            id: mainLayout
            columns: 3
            x: 1
            y: 30
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: ScreenTools.defaultFontPixelWidth * 1
            z: 100 // 确保在最上层
            visible: !toolDrawer.visible // 抽屉打开时隐藏
            columnSpacing: ScreenTools.defaultFontPixelWidth * 0.1
            rowSpacing: ScreenTools.defaultFontPixelHeight * 0.1

            Button
            {
               id: button1
               x: 2
               y: 2
               text: enable_flag ? qsTr("已解锁") : qsTr("已锁定")

               background: Rectangle
               {
                   implicitWidth: ScreenTools.defaultFontPixelWidth * 10
                   implicitHeight: ScreenTools.defaultFontPixelHeight * 2
                   color: enable_flag ? "#4CAF50":"#F44336";
                   radius: 4
               }

               onClicked:
               {
                   count++;
                   button2_flag = 1;
                   button3_flag = 1;
                   button4_flag = 1;
                   button5_flag = 1;
                   button6_flag = 1;
                   button7_flag = 1;
                   button8_flag = 1;
                   button9_flag  = 1;
                   button10_flag = 1;
                   button11_flag = 1;
                   enable_flag = enable_flag ? 0 : 1;
                   paotou_mavlink._sendcom(enable_flag, 0, 0, 0, 0, 0, 0, 0, 0, count)
               }
            }

            Item
            {
                Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 10
                Layout.preferredHeight: ScreenTools.defaultFontPixelHeight * 2
            }
            Button
            {
                id: button2
                // x: 163
                // y: 2
                text: qsTr("全投")

                onClicked:
                {
                    count++;
                    button2_flag = button2_flag ? 0:1;
                    button3_flag = 0;
                    button4_flag = 0;
                    button5_flag = 0;
                    button6_flag = 0;
                    button7_flag = 0;
                    button8_flag = 0;
                    button9_flag   = 0;
                    button10_flag  = 0;
                    button11_flag  = 0;
                    paotou_mavlink._sendcom(enable_flag, 0, 0, 0, 0, 1, 1, 1, 1, count)
                }
                background: Rectangle
                {
                    implicitWidth: ScreenTools.defaultFontPixelWidth * 10
                    implicitHeight: ScreenTools.defaultFontPixelHeight * 2
                    color: enable_flag? (button2_flag ? "#2196F3" : "#0D47A1"): "#cccccc"
                    radius: 4
                }

            }

            Button {
                   id: button3

                   text: qsTr("投1")

                   background: Rectangle
                   {
                       implicitWidth: ScreenTools.defaultFontPixelWidth * 10
                       implicitHeight: ScreenTools.defaultFontPixelHeight * 2
                       color: enable_flag? (button3_flag ? "#2196F3" : "#0D47A1"): "#cccccc"
                       radius: 4

                   }
                   onClicked:
                   {
                        button4_flag =0;
                        button6_flag =0;
                        button3_flag = button3_flag ? 0:1;
                       count++;
                       paotou_mavlink._sendcom(enable_flag, 0, 0, 0, 0, 1, 0, 0, 0, count)
                   }
               }
            Button
            {
                id: button4
                background: Rectangle
                {
                    implicitWidth: ScreenTools.defaultFontPixelWidth * 10
                    implicitHeight: ScreenTools.defaultFontPixelHeight * 2
                    color: enable_flag? (button4_flag ? "#2196F3" : "#0D47A1"): "#cccccc"
                    radius: 4
                }
                text: qsTr("投前")
                onClicked:
                {
                    count++;
                    button3_flag =0;
                    button4_flag = button4_flag ? 0:1;
                    button5_flag = 0;
                    paotou_mavlink._sendcom(enable_flag, 1, 0, 0, 0, 0, 0, 0, 0, count)
                }
            }
            Button
            {
                id: button5
                background: Rectangle
                {
                    implicitWidth: ScreenTools.defaultFontPixelWidth * 10
                    implicitHeight: ScreenTools.defaultFontPixelHeight * 2
                    color: enable_flag? (button5_flag ? "#2196F3" : "#0D47A1"): "#cccccc"
                    radius: 4
                }
                text: qsTr("投2")
                onClicked:
                {
                    count++;
                    button4_flag = 0;
                    button8_flag = 0;
                    button5_flag = button5_flag ? 0:1;
                    paotou_mavlink._sendcom(enable_flag, 0, 0, 0, 0, 0, 1, 0, 0, count)
                }
            }
            Button
            {
                id: button6
                background: Rectangle
                {
                    implicitWidth: ScreenTools.defaultFontPixelWidth * 10
                    implicitHeight: ScreenTools.defaultFontPixelHeight * 2
                    color: enable_flag? (button6_flag ? "#2196F3" : "#0D47A1"): "#cccccc"
                    radius: 4
                }
                text: qsTr("投左")
                onClicked:
                {
                    count++;
                    button3_flag = 0;
                    button6_flag = button6_flag ? 0:1;
                    button9_flag = 0;
                    paotou_mavlink._sendcom(enable_flag, 0, 0, 1, 0, 0, 0, 0, 0, count)
                }
            }
            // Button
            // {
            //     id: button7
            //     background: Rectangle
            //     {
            //         implicitWidth: ScreenTools.defaultFontPixelWidth * 10
            //         implicitHeight: ScreenTools.defaultFontPixelHeight * 2
            //         color: button7_flag ? "#2196F3": "#0D47A1";
            //         radius: 4
            //     }
            //     text: qsTr("投中")
            //     onClicked:
            //     {
            //         count++;
            //          button7_flag = button7_flag ? 0:1;
            //          button6_flag = button6_flag ? 0:1;
            //          button8_flag = button8_flag ? 0:1;
            //         paotou_mavlink._sendcom(enable_flag, 2, 0, 0, 0, 0, 0, 0, 0, count);
            //     }
            // }
            Item
            {
                Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 10
                Layout.preferredHeight: ScreenTools.defaultFontPixelHeight * 2
            }
            Button
            {
                id: button8
                background: Rectangle
                {
                    implicitWidth: ScreenTools.defaultFontPixelWidth * 10
                    implicitHeight: ScreenTools.defaultFontPixelHeight * 2
                    color: enable_flag? (button8_flag ? "#2196F3" : "#0D47A1"): "#cccccc"
                    radius: 4
                }
                text: qsTr("投右")
                onClicked:
                {
                    count++;
                    button8_flag = button8_flag ? 0:1;
                    button5_flag = 0;
                    button11_flag = 0;
                    paotou_mavlink._sendcom(enable_flag, 0, 0, 0, 1, 0, 0, 0, 0, count)
                }
            }
            Button
            {
                id: button9
                background: Rectangle
                {
                    implicitWidth: ScreenTools.defaultFontPixelWidth * 10
                    implicitHeight: ScreenTools.defaultFontPixelHeight * 2
                    color: enable_flag? (button9_flag ? "#2196F3" : "#0D47A1"): "#cccccc"
                    radius: 4
                }
                text: qsTr("投3")
                onClicked:
                {
                    count++;
                     button6_flag=0;
                     button10_flag=0;
                     button9_flag = button9_flag ? 0:1;
                    paotou_mavlink._sendcom(enable_flag, 0, 0, 0, 0, 0, 0, 1, 0, count)
                }
            }
            Button
            {
                id: button10
                background: Rectangle
                {
                    implicitWidth: ScreenTools.defaultFontPixelWidth * 10
                    implicitHeight: ScreenTools.defaultFontPixelHeight * 2
                    color: enable_flag? (button10_flag ? "#2196F3" : "#0D47A1"): "#cccccc"
                    radius: 4
                }
                text: qsTr("投后")
                onClicked:
                {
                    count++;
                     button10_flag = button10_flag ? 0:1;
                     button9_flag = 0;
                     button11_flag = 0;
                     paotou_mavlink._sendcom(enable_flag, 0, 1, 0, 0, 0, 0, 0, 0, count)
                }

            }
            Button
            {
                id: button11
                background: Rectangle
                {
                    implicitWidth: ScreenTools.defaultFontPixelWidth * 10
                    implicitHeight: ScreenTools.defaultFontPixelHeight * 2
                    color: enable_flag? (button11_flag ? "#2196F3" : "#0D47A1"): "#cccccc"
                    radius: 4
                }
                text: qsTr("投4")



                onClicked:
                {
                    count++;
                    button8_flag=0;
                    button10_flag=0;
                     button11_flag = button11_flag ? 0:1;
                     paotou_mavlink._sendcom(enable_flag, 0, 0, 0, 0, 0, 0, 0, 1, count)
                }
            }

        }


}
