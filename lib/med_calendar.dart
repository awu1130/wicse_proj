import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'calendar_day.dart';

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pop(context); // Go back to HomePage
            },
          ),
        ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Expanded(
              child: CalenderScreenUI(), // Displaying the calendar widget
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

  // This widget builds the detailed calendar grid for the chosen month.
  Widget buildCalendar(DateTime month) {
    int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    DateTime firstDayOfMonth = DateTime(month.year, month.month, 1);
    int weekdayOfFirstDay = firstDayOfMonth.weekday;

    DateTime lastDayOfPreviousMonth =
        firstDayOfMonth.subtract(const Duration(days: 1));
    int daysInPreviousMonth = lastDayOfPreviousMonth.day;

    return Container(
      child: GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7, // Always 7 columns for days of the week
          childAspectRatio: 1.0, // Maintain square cells
          mainAxisSpacing: 2, // Slight spacing for a clean look
          crossAxisSpacing: 2, // Slight spacing for a clean look
        ),
        itemCount: daysInMonth + weekdayOfFirstDay - 1,
        itemBuilder: (context, index) {
          if (index < weekdayOfFirstDay - 1) {
            int previousMonthDay =
                daysInPreviousMonth - (weekdayOfFirstDay - index) + 2;
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
            DateTime date =
                DateTime(month.year, month.month, index - weekdayOfFirstDay + 2);
            String text = date.day.toString();

            return InkWell(
              onTap: () {
                Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DayDetailsPage(date: date),
                      ),
                    );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, width: 0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Minimize vertical space
                  children: [
                    Icon(
                      Icons.sentiment_very_satisfied,
                      color: Colors.green,
                      size: 26.0, // Smaller icon size
                    ),
                    const SizedBox(height: 2), // Space between icon and text
                    Text(
                      text,
                      style: const TextStyle(fontSize: 16), // Smaller text
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

/*
class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.format_list_bulleted),
          label: 'Medicine and Symptoms',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blue,
      onTap: _onItemTapped,
    );
  }
}*/
