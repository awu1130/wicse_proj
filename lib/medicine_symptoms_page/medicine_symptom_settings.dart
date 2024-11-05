import 'package:flutter/material.dart';
import 'medicine_symptom_mainpage.dart';
import '../main.dart';

class MedicineSympSettingsPage extends StatefulWidget {
  const MedicineSympSettingsPage({super.key});

  @override
  _MedicineSympSettingsPageState createState() => _MedicineSympSettingsPageState();
}

class _MedicineSympSettingsPageState extends State<MedicineSympSettingsPage> {
  int _selectedIndex = 2;  // Set the initial index to the "Settings" tab

  // Placeholder for toggles or other settings options
  bool notificationsEnabled = false;
  double textScaleFactor = 1.0;

  // Method to navigate to the selected page
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Navigate to Medicine Symptoms Page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    } else if (index == 1) {
      // Navigate to Home Page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
      );
    } else if (index == 2) {
      // Already on Settings Page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Page'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'General Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                notificationsEnabled = value;
              });
            },
          ),
          const SizedBox(height: 20),

          ListTile(
            title: const Text('Clear Medicine List'),
            trailing: const Icon(Icons.refresh),
            onTap: () {
              // Future functionality
            },
          ),
          ListTile(
            title: const Text('Clear Symptom List'),
            trailing: const Icon(Icons.refresh),
            onTap: () {
              // Future functionality
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Medicine/Symptoms',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
