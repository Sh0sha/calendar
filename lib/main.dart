import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:ThemeData.dark(),
      home: const CalendarScreen(),

    );
  }
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDate;
  bool editable = true;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Календарь'),
        actions: [
          IconButton(
            onPressed: () {
              _selectDate(context);
            },
            icon: const Icon(Icons.today),
          ),
          IconButton(
            onPressed: () {
              _goToCurrentDate();
            },
            icon: const Icon(Icons.restore),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildMonthNavigator(),
          _buildCalendar(),
        ],
      ),
    );
  }

  // Кнопки переключения месяцев
  Widget _buildMonthNavigator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              _selectedDate = DateTime(_selectedDate.year,
                  _selectedDate.month - 1, _selectedDate.day);
            });
          },
          icon: const Icon(Icons.arrow_back),
        ),
        Text(
          DateFormat('MMMM yyyy').format(_selectedDate),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _selectedDate = DateTime(_selectedDate.year,
                  _selectedDate.month + 1, _selectedDate.day);
            });
          },
          icon: const Icon(Icons.arrow_forward),
        ),
      ],
    );
  }

  // построения сетки календаря:
  Widget _buildCalendar() {
    final List<DateTime> daysInMonth =
    _getDaysInMonth(_selectedDate.year, _selectedDate.month);

    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: daysInMonth.length,
      itemBuilder: (context, index) {
        final day = daysInMonth[index];

        // Обработка выбора даты
        return GestureDetector(
          onTap: () {
            if (editable) {
              setState(() {
                _selectedDate = day;
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (day.year == DateTime.now().year &&
                  day.month == DateTime.now().month &&
                  day.day == DateTime.now().day)
                  ? Colors.blue
                  : (day.isAtSameMomentAs(_selectedDate) ? Colors.green : null),
            ),
            alignment: Alignment.center,
            child: Text(
              day.day.toString(),
              style: TextStyle(
                color: day.month != _selectedDate.month ? Colors.grey : null,
                fontWeight: day.isAtSameMomentAs(DateTime.now())
                    ? FontWeight.bold
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }

  List<DateTime> _getDaysInMonth(int year, int month) {
    final DateTime firstDayOfMonth = DateTime(year, month, 1);
    final DateTime lastDayOfMonth = DateTime(year, month + 1, 0);
    final List<DateTime> days = [];

    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      days.add(DateTime(year, month, day));
    }

    return days;
  }

  // выбор даты с окна
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Навигация к текущей дате
  void _goToCurrentDate() {
    setState(() {
      _selectedDate = DateTime.now();
    });
  }
}
