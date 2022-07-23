# QtQuick-Calendar
develop the calendar which imitating the style above calendar of elementUi  By Qt
the calendar design includes static title,static weekOfRow,in addition,dayLists created dynamically
internal readonly property: selectedDate
inline property: today curYear curMonth dayList weekList m_dayGrid dayGridEnable
the calendar also can sign currentDate by specifc color,hover or click also has other color changes
the calendar also diff days which not in this month and these dats can not receive mouseArea events
but the calendar also has shortCuts,one of shortCuts is it can show "value is undefined and can not 
convert into object" when switch date,main reason is dayList changed with null 
