import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

DateTime today = DateTime.now();
Widget SamaCalendrier() {
  return Column(
    children: [
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.white),
        child: TableCalendar(
            calendarStyle: const CalendarStyle(
                disabledTextStyle: TextStyle(fontWeight: FontWeight.bold),
                holidayTextStyle: TextStyle(fontWeight: FontWeight.bold),
                cellPadding: EdgeInsets.all(1)),
            focusedDay: today,
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14)),
      ),
    ],
  );
}
