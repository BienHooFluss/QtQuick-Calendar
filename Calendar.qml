/**
 * @file    DynamicBaseButton.qml
 * @author  jhjiang jhjiang@zdmedtech.com
 * @version V1.0.0
 * @date    2022-07-22
 * @brief
 * @since
 * <table>
 * <tr><th>Date         <th>H_Version    <th>Author      <th>Description                </tr>
 * <tr><td>2022-05-15   <td>1.0.0        <td>Jhjiang     <td>the first version.         </tr>
 *
 * @attention
 *
 * <h2><center>&copy; COPYRIGHT (C) 2022 ZD MEDTECH</center></h2>
 */

import QtQuick 2.12
import QtQuick.Controls 2.12
import Qt5Compat.GraphicalEffects

Rectangle {
    id: root

    // default size.
    implicitWidth: 318
    implicitHeight: 330
    color: "white"
    border.color: "white"
    border.width: 1

    property int style: DynamicBaseCalendar.Style.StandardCalendar

    property var today: new Date()
    property int curYear: new Date().getFullYear()
    property int curMonth: new Date().getMonth() + 1
    property var dayList: []
    property var weekList: ['日','一','二','三','四','五','六']
    property var m_dayGrid: null
    property bool dayGridEnable: false
    readonly property var selectedDate: new Date()

    enum Style {
        Undefiend,
        StandardCalendar
    }

    enum DayType {
        Undefiend,
        Past,
        Now,
        Fucture
    }


    Item {
        id: m_title
        width: 318
        height: 40
        z: 2
        anchors {
            left: parent.left
            top: parent.top
        }

        Image {
            id: m_lastMonth
            source: "qrc:/icons/calendar/lastMonth.svg"
            z: 3
            anchors.left: parent.left
            anchors.leftMargin: 11
            anchors.verticalCenter: parent.verticalCenter
            MouseArea {
                anchors.fill: m_lastMonth
                enabled: (root.curYear == 1900 && root.curMonth == 1) ? 0 : 1
                onClicked: {
                    if (curMonth == 1) {
                        curMonth = 12
                        curYear = curYear - 1
                    }
                    else if (curMonth > 1) {
                        curMonth = curMonth - 1
                    }
                    dayList = []
                    dayList = generateCurMonDate(curYear,curMonth)
                }
            }
        }

        Text {
            id: m_curYear
            font.weight: Font.normal
            font.pixelSize: 20
            color: "#333333"
            text: curYear + "年"
            font.family: "Microsoft Sans Serif"
            anchors {
                left: parent.left
                leftMargin: 99
                verticalCenter: parent.verticalCenter
            }
        }

        Text {
            id: m_curMonth
            font.weight: Font.normal
            font.pixelSize: 20
            color: "#5F74F0"
            text: curMonth + "月"
            font.family: "Microsoft Sans Serif"
            anchors {
                left: m_curYear.right
                top: m_curYear.top
            }
        }

        Image {
            id: m_nextMonth
            source: "qrc:/icons/calendar/nextMonth.svg"
            z: 3
            anchors.right: parent.right
            anchors.rightMargin: 11
            anchors.verticalCenter: parent.verticalCenter
            MouseArea {
                anchors.fill: m_nextMonth
                z: 1
                enabled: (root.curYear >= 1900) && (root.curMonth >= 1)
                onClicked: {
                    if (curMonth == 12) {
                        curMonth = 1
                        curYear = curYear + 1
                    }
                    else {
                        curMonth = curMonth + 1
                    }
                    dayList = []
                    dayList = generateCurMonDate(curYear,curMonth)
                }
            }
        }
    }


    Rectangle {
        id: m_weekRow
        color: "transparent"
        border.color: "transparent"
        border.width: 1
        width: 318
        height: 40
        anchors {
            left: m_title.left
            top: m_title.bottom
            topMargin: 10
        }

        ListView {
            id: m_weekList
            model: weekList
            spacing: 4
            orientation: ListView.Horizontal
            anchors.fill: parent
            delegate: Item {
                width: 42
                height: 40
                Text {
                    color: "#333333"
                    font.weight: Font.Normal
                    font.pixelSize: 0
                    text: modelData
                    anchors.centerIn: parent
                }
            }
        }
    }


    function createSubObjects() {
        var curDate = new Date()
        curYear = curDate.getFullYear()
        curMonth = curDate.getMonth() + 1
        dayList = generateCurMonDate(curYear,curMonth)
        if (m_dayGrid == null) {
            m_dayGrid = Qt.createQmlObject('import QtQuick 2.12;

            GridView {
                id: listView
                width: 318 + 4
                height: 240
                cellWidth: 46
                cellHeight: 40

                property int currentIndex: 1
                delegate: Item {
                    width: 42
                    height: 40
                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: dayList[index].dayType == 2
                        enabled: dayList[index].dayType == 2
                        onClicked: {
                            currentIndex = index
                            selectedDate.setFullYear(root.curYear)
                            selectedDate.setMonth(root.curMonth -1 )
                            selectedDate.setDate(root.dayList[index].day)
                            console.debug("selectedDate",JSON.stringify(selectedDate))
                        }
                    }
                    Rectangle {
                        id: inlineRect
                        width: 32
                        height: 32
                        radius: width * 0.5
                        color: {
                            if ( (currentIndex == index) && dayList[index].dayType == 2) return "#5F74F0"
                            if (mouseArea.containsMouse) return "#E6ECFF"
                            else return "transparent"
                        }
                        border.width: 1
                        border.color: {
                            if (root.curYear == root.today.getFullYear() && root.curMonth == (root.today.getMonth() + 1) && dayList[index].day == root.today.getDate() && dayList[index].dayType == 2)   return  "#5F74F0"
                            if (mouseArea.containsMouse) return "#E6ECFF"
                            if ( (currentIndex == index) && dayList[index].dayType == 2)  return "#5F74F0"
                            else return "transparent"
                        }
                        anchors.centerIn: parent
                        Text {
                            id: inlineText
                            color: {
                                if (dayList[index].dayType == 2 && currentIndex == index) return "#FFFFFF"
                                else if (dayList[index].dayType == 2 && currentIndex != index) return "#333333"
                                else return "#D8D8D8"
                            }
                            font.pixelSize: 16
                            font.weight: Font.Normal
                            text: dayList[index].day
                            anchors.centerIn: parent
                        }
                    }
                }
            }',root)
            if (m_dayGrid != null) {
                console.debug("create m_dayGrid succeed")
                m_dayGrid.model = dayList
                m_dayGrid.z = 10
                m_dayGrid.anchors.left = root.left
                m_dayGrid.anchors.top = root.top
                m_dayGrid.anchors.topMargin = 90
            }
            else {
                console.debug("create m_dayGrid failed")
            }
        }
    }

    function styleConfig() {
        switch (root.style) {
            case DynamicBaseCalendar.Style.Undefiend:
                break
            case DynamicBaseCalendar.Style.StandardCalendar:
                createSubObjects()
                break

            default:
                break
        }
    }

    function nyear(year)
    {
        if((year % 4 == 0 && year % 100 != 0) || year % 400 == 0)
            return 366;
        else
            return 365;
    }


    function nmonth(y, m)
    {
        if(m === 1 || m === 3 || m === 5 || m === 7 || m === 8 || m === 10 || m === 12)  //大月
            return 31
        else if(nyear(y) === 366 && m === 2)
            return 29
        else if(nyear(y) === 365 && m === 2)
            return 28
        else
            return 30
    }

    function getDays(year, month)
    {
        var i = 0
        var sum = 0
        if(year > 1990)
        {
            for(i = 1990; i < year; i++)
                sum += nyear(i)
        }
        if(month > 1)
        {
            for(i = 1; i < month; i++)
            {
                sum += nmonth(year, i)
            }
        }
        return sum
    }


    function generateCurMonDate(year,month) {
        var dayObjList = []
        var lastMonDayCnt
        if (month < 1 || year < 1990) return
        var sum = getDays(year, month);
        var space = (sum + 1) % 7;
        if (month === 1) {
            lastMonDayCnt = nmonth(year - 1, 12)
        }
        else if (month > 1) {
            lastMonDayCnt = nmonth(year, month - 1)
        }
        var dayCnt = nmonth(year, month);
        for(var i = (lastMonDayCnt - space + 1); i <= lastMonDayCnt; i++) { //frontSpace
            console.debug("i:",i)
            var tempObj = {}
            tempObj.day = i
            tempObj.dayType = DynamicBaseCalendar.DayType.past
            dayObjList.push(tempObj)
        }
        for(var k = 1; k <= dayCnt; k++) {
            var tempObj1 = {}
            tempObj1.day = k
            tempObj1.dayType = DynamicBaseCalendar.DayType.Now
            dayObjList.push(tempObj1)
        }
        for(var j = 1; j <= (42 - dayCnt - space); j++) {
            var tempObj2 = {}
            tempObj2.day = j
            tempObj2.dayType = DynamicBaseCalendar.DayType.Fucture
            dayObjList.push(tempObj2)
        }
        return dayObjList
    }


    Component.onCompleted: {
        console.debug("DynamicBasCalendar onCompletd: ", root.style)
        root.styleConfig()
    }

    Component.onDestruction: {
        console.debug("DynamicBaseCalendar onDestruction.")
        if (m_dayGrid != null) {
            m_dayGrid.destroy(0)
        }
    }

    MouseArea {
        anchors.fill: root
        hoverEnabled: true
    }
}
