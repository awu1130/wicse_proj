import 'package:flutter/material.dart';
import 'medicine_symptom_settings.dart';
import '../main.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Lists to store symptoms and medicines
  List<String> symptoms = [];
  List<String> medicines = [];

  int _selectedIndex = 0; // Default index for the bottom nav bar

  // Method to navigate to the selected page
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the corresponding page based on the index
    if (index == 0) {
      // Stay on the current page
    } else if (index == 1) {
      // Navigate to Home Page
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyApp()),
          ); 
    } 
    else if (index == 2) {
      // Navigate to Settings Page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MedicineSympSettingsPage()),
      );
    }
  }

  // Add new symptom
  void _addSymptom() {
    setState(() {
      symptoms.add('');
    });
  }

  // Remove symptom
  void _removeSymptom(int index) {
    setState(() {
      symptoms.removeAt(index);
    });
  }

  // Add new medicine
  void _addMedicine() {
    setState(() {
      medicines.add('');
    });
  }

  // Remove medicine
  void _removeMedicine(int index) {
    setState(() {
      medicines.removeAt(index);
    });
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
              // Symptom List Section
              _buildListSection(
                title: 'Symptom List',
                items: symptoms,
                onAdd: _addSymptom,
                onRemove: _removeSymptom,
              ),
              const SizedBox(height: 20),
              // Medicine List Section
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
            label: 'Home',
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

  // Widget to build each section (Symptom and Medicine)
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

  // Widget to build each item in the list (with a text field and remove button)
  Widget _buildListItem({
    required int index,
    required String value,
    required VoidCallback onRemove,
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
              onChanged: (newValue) {
                setState(() {
                  value = newValue;
                });
              },
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
