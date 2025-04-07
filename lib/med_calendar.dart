import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'calendar_day.dart';

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton( // go back to home
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pop(context); 
            },
          ),
        ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Expanded(
              child: CalenderScreenUI(), 
            ),
          ],
        ),
      ),
      //bottomNavigationBar: const BottomNavigationBarExample(),
    );
  }
}


class CalenderScreenUI extends StatefulWidget {
  const CalenderScreenUI({super.key});

  @override
  State<CalenderScreenUI> createState() => _CalenderScreenUIState();
}

class _CalenderScreenUIState extends State<CalenderScreenUI> {
  PageController _pageController =
      PageController(initialPage: DateTime.now().month - 1);
  DateTime _currentMonth = DateTime.now();

  Map<String, IconData> icons = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          _buildWeeks(),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentMonth =
                      DateTime(_currentMonth.year, (index % 12) + 1, 1);
                });
              },
              itemCount: 12 * 10, // Adjustable years count
              itemBuilder: (context, pageIndex) {
                DateTime month =
                    DateTime(_currentMonth.year, (pageIndex % 12) + 1, 1);
                return buildCalendar(month);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (_pageController.page! > 0) {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
          Text(
            '${DateFormat('MMMM').format(_currentMonth)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          DropdownButton<int>(
            value: _currentMonth.year,
            onChanged: (int? year) {
              if (year != null) {
                setState(() {
                  _currentMonth = DateTime(year, _currentMonth.month, 1);
                  int monthIndex = (year - DateTime.now().year) * 12 +
                      _currentMonth.month -
                      1;
                  _pageController.jumpToPage(monthIndex);
                });
              }
            },
            items: [
              for (int year = DateTime.now().year;
                  year <= DateTime.now().year + 10;
                  year++)
                DropdownMenuItem<int>(
                  value: year,
                  child: Text(year.toString()),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeeks() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Text('Mon', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('Tue', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('Wed', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('Thu', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('Fri', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('Sat', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('Sun', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget buildCalendar(DateTime month) {
  int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
  DateTime firstDayOfMonth = DateTime(month.year, month.month, 1);
  int weekdayOfFirstDay = firstDayOfMonth.weekday;

  DateTime lastDayOfPreviousMonth = firstDayOfMonth.subtract(const Duration(days: 1));
  int daysInPreviousMonth = lastDayOfPreviousMonth.day;

  return Container(
    child: GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7, // 7 days
        childAspectRatio: 1.0, 
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemCount: daysInMonth + weekdayOfFirstDay - 1,
      itemBuilder: (context, index) {
        if (index < weekdayOfFirstDay - 1) {
          int previousMonthDay = daysInPreviousMonth - (weekdayOfFirstDay - index) + 2;
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Text(
              previousMonthDay.toString(),
              style: const TextStyle(color: Colors.black, fontSize: 12),
            ),
          );
        } else {
          DateTime date = DateTime(month.year, month.month, index - weekdayOfFirstDay + 2);
          String text = date.day.toString();

          // Fetch the saved mood icon for this date
          IconData? moodIcon = icons[date.toString()];

          return InkWell(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DayDetailsPage(date: date),
                ),
              );
              if (result != null) {
                setState(() {
                  icons[date.toString()] = result["selectedIcon"];
                });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 0.5),
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (moodIcon != null)
                    Icon(
                      moodIcon,
                      color: Colors.blue,
                      size: 26.0,
                    ),
                  const SizedBox(height: 2),
                  Text(
                    text,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }
      },
    ),
  );
}
}
