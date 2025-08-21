// calendar_page.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:app/src/core/theme/app_colors.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text("Calendário", style: TextStyle(color: AppColors.black)),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: AppColors.darkerPink),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: AppColors.darkerPink,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: AppColors.mediumPink,
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: TextStyle(color: AppColors.grey),
                weekendTextStyle: TextStyle(color: AppColors.grey),
                selectedTextStyle: TextStyle(color: AppColors.white),
                todayTextStyle: TextStyle(color: AppColors.white),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(color: AppColors.black),
              ),
            ),
            SizedBox(height: 16),
            // Agenda de eventos
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Agenda",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  // Exemplo de item da agenda
                  _buildAgendaItem(
                    "Nutricionista",
                    "17:11",
                    AppColors.mediumPink,
                  ),
                  _buildAgendaItem("Ultrassom", "17:11", AppColors.boldPink),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgendaItem(String title, String time, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: AppColors.black)),
              Text(time, style: TextStyle(color: AppColors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
