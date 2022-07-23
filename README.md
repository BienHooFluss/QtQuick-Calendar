<!--
 * @Author: jhjiang
 * @Date: 2022-07-23 10:34:17
 * @LastEditors: your name
 * @LastEditTime: 2022-07-23 10:36:44
 * @Description: file content
-->
# QtQuick-Calendar
1.develop the calendar which imitating the style above calendar of elementUi  By Qt
2.the calendar design includes static title,static weekOfRow,in addition,dayLists created dynamically 
3.internal readonly property: selectedDate inline property: today curYear curMonth dayList weekList m_dayGrid dayGridEnable 
4.the calendar also can sign currentDate by specifc color,hover or click also has other color changes 
5.the calendar also diff days which not in this month and these dats can not receive mouseArea events 
6.the calendar also has shortCuts,one of shortCuts is it can show "value is undefined and can not convert into object" when switch date,main reason is dayList changed with null
