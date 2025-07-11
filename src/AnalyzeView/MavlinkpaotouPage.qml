import QtQuick          2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs  1.2
import QtQuick.Layouts  1.2

import QGroundControl               1.0
import QGroundControl.Palette       1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Controllers   1.0
import QtQuick.Controls.Styles 1.2
import Mavlinkpaotou   1.0
AnalyzePage
{
    id:              mavlinkConsolePage
    pageComponent:   pageComponent
    //pageName:        qsTr("Mavlink PAOTOU")
    allowPopout:     true

    property int count: 0
    property int enable_flag: 0
    Mavlinkpaotou
    {
       id:paotou_mavlink
    }


    Button
    {
        id: button1
        x: 2
        y: 2
        text: enable_flag ? qsTr("解锁") : qsTr("锁定")

            style: ButtonStyle
            {
                background: Rectangle {
                    implicitWidth: ScreenTools.defaultFontPixelWidth * 10
                    implicitHeight: ScreenTools.defaultFontPixelHeight * 1.5
                    border.color: "#3498db"  // 边框颜色
                               border.width: 1          // 边框宽度
                               radius: 4                // 圆角半径
                    color:
                    {
                        // 正常状态
                        if (!control.pressed && !control.hovered)
                        {
                            return enable_flag ?  "#2ecc71":"#e74c3c"  // 红/绿
                        }
                    }
                }
            }

        onClicked:
        {
            count++;
            enable_flag = enable_flag ? 0 : 1;
            paotou_mavlink._sendcom(enable_flag, 0, 0, 0, 0, 0, 0, 0, 0, count)
        }
        Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 10
        Layout.preferredHeight: ScreenTools.defaultFontPixelHeight * 2
    }

    Button
    {
        id: button2
        x: 163
        y: 2
        text: qsTr("全投")
        style: ButtonStyle
        {
            background: Rectangle
            {
                implicitWidth: ScreenTools.defaultFontPixelWidth * 10
                implicitHeight: ScreenTools.defaultFontPixelHeight * 1.5
                border.width: 1          // 边框宽度
                radius: 4                // 圆角半径
            }
        }

        onClicked:
        {
            count++;
            paotou_mavlink._sendcom(enable_flag,0,0,1,1,1,1,1,1,count)
        }
        Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 10
        Layout.preferredHeight: ScreenTools.defaultFontPixelHeight * 2
    }
    GridLayout
    {
        id: mainLayout
        columns: 3
        x: 1
        y: 30
        columnSpacing: ScreenTools.defaultFontPixelWidth * 0.1
        rowSpacing: ScreenTools.defaultFontPixelHeight * 0.1

        Button
        {
            id: button3
            Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 10
            Layout.preferredHeight: ScreenTools.defaultFontPixelHeight * 2
            text: qsTr("投1")
            onClicked:
            {
                 count++;
                paotou_mavlink._sendcom(enable_flag,0,0,1,0,0,0,0,0,count)
            }
        }
        Button
        {
            id: button4
            Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 10
            Layout.preferredHeight: ScreenTools.defaultFontPixelHeight * 2
            text: qsTr("投前")
            onClicked:
            {
                count++;
                paotou_mavlink._sendcom(enable_flag, 1, 0, 0, 0, 0, 0, 0, 0, count);
            }
        }
        Button
        {
            id: button5
            Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 10
            Layout.preferredHeight: ScreenTools.defaultFontPixelHeight * 2
            text: qsTr("投2")
            onClicked:
            {
                count++;
                paotou_mavlink._sendcom(enable_flag, 0, 0, 0, 1, 0, 0, 0, 0, count);
            }
        }
        Button
        {
            id: button6
            Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 10
            Layout.preferredHeight: ScreenTools.defaultFontPixelHeight * 2
            text: qsTr("投3")
            onClicked:
            {
                count++;
                paotou_mavlink._sendcom(enable_flag, 0, 0, 0, 0, 1, 0, 0, 0, count);
            }
        }
        Button
        {
            id: button7
            Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 10
            Layout.preferredHeight: ScreenTools.defaultFontPixelHeight * 2
            text: qsTr("投中")
            onClicked:
            {
                count++;
                paotou_mavlink._sendcom(enable_flag, 2, 0, 0, 0, 0, 0, 0, 0, count);
            }
        }
        Button
        {
            id: button8
            Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 10
            Layout.preferredHeight: ScreenTools.defaultFontPixelHeight * 2
            text: qsTr("投4")
            onClicked:
            {
                count++;
                paotou_mavlink._sendcom(enable_flag, 0, 0, 0, 0, 0, 1, 0, 0, count);
            }
        }
        Button
        {
            id: button9
            Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 10
            Layout.preferredHeight: ScreenTools.defaultFontPixelHeight * 2
            text: qsTr("投5")
            onClicked:
            {
                count++;
                paotou_mavlink._sendcom(enable_flag, 0, 0, 0, 0, 0, 0, 1, 0, count);
            }
        }
        Button
        {
            id: button10
            Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 10
            Layout.preferredHeight: ScreenTools.defaultFontPixelHeight * 2
            text: qsTr("投后")
            onClicked:
            {
                count++;
                paotou_mavlink._sendcom(enable_flag, 3, 0, 0, 0, 0, 0, 0, 0, count);
            }
        }
        Button
        {
            id: button11
            Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 10
            Layout.preferredHeight: ScreenTools.defaultFontPixelHeight * 2
            text: qsTr("投6")
            onClicked:
            {
                count++;
                paotou_mavlink._sendcom(enable_flag, 0, 0, 0, 0, 0, 0, 0, 1, count);
            }
        }
    }
}



