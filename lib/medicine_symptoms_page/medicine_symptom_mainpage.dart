import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'medicine_symptom_settings.dart';
import '../main.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<String> symptoms = [];
  List<String> medicines = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchData(); // Load data when the page initializes
  }

  Future<void> fetchData() async {
    const url = 'http://10.0.2.2:3000/data';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          setState(() {
            symptoms = List<String>.from(data[0]['symptoms'] ?? []);
            medicines = List<String>.from(data[0]['medicines'] ?? []);
          });
        }
        print('Data fetched successfully!');
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> saveData() async {
    const url = 'http://10.0.2.2:3000/data';

    final data = {
      'symptoms': symptoms,
      'medicines': medicines,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        print('Data saved successfully!');
      } else {
        print('Failed to save data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  void _addSymptom() {
    setState(() {
      symptoms.add(''); // Add an empty placeholder for user input
    });
  }

  void _removeSymptom(int index) {
    setState(() {
      symptoms.removeAt(index);
    });
    saveData();
  }

  void _addMedicine() {
    setState(() {
      medicines.add(''); // Add an empty placeholder for user input
    });
  }

  void _removeMedicine(int index) {
    setState(() {
      medicines.removeAt(index);
    });
    saveData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MedicineSympSettingsPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Symptoms Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildListSection(
                title: 'Symptom List',
                items: symptoms,
                onAdd: _addSymptom,
                onRemove: _removeSymptom,
              ),
              const SizedBox(height: 20),
              _buildListSection(
                title: 'Medicine List',
                items: medicines,
                onAdd: _addMedicine,
                onRemove: _removeMedicine,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Medicine/Symptoms',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
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

  Widget _buildListSection({
    required String title,
    required List<String> items,
    required VoidCallback onAdd,
    required Function(int) onRemove,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...List.generate(items.length, (index) {
              return _buildListItem(
                index: index,
                value: items[index],
                onRemove: () => onRemove(index),
                onChanged: (newValue) {
                  setState(() {
                    items[index] = newValue;
                  });
                  saveData();
                },
              );
            }),
            const SizedBox(height: 10),
            Center(
              child: IconButton(
                onPressed: onAdd,
                icon: const Icon(Icons.add_circle_outline),
                tooltip: 'Add new item',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem({
    required int index,
    required String value,
    required VoidCallback onRemove,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 10),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              initialValue: value,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
              ),
              onChanged: onChanged,
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
