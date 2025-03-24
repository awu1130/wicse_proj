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
  List<TextEditingController> symptomControllers = [];
  List<TextEditingController> medicineControllers = [];
  List<FocusNode> symptomFocusNodes = [];
  List<FocusNode> medicineFocusNodes = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data initially
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
          _initializeControllers();
        }
        print('Data fetched successfully!');
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _initializeControllers() {
    // Dispose existing controllers and focus nodes only if the lists are not empty
    if (symptomControllers.isNotEmpty) {
      for (var controller in symptomControllers) {
        controller.dispose();
      }
      symptomControllers.clear();
    }
    if (symptomFocusNodes.isNotEmpty) {
      for (var focusNode in symptomFocusNodes) {
        focusNode.dispose();
      }
      symptomFocusNodes.clear();
    }

    if (medicineControllers.isNotEmpty) {
      for (var controller in medicineControllers) {
        controller.dispose();
      }
      medicineControllers.clear();
    }
    if (medicineFocusNodes.isNotEmpty) {
      for (var focusNode in medicineFocusNodes) {
        focusNode.dispose();
      }
      medicineFocusNodes.clear();
    }

    // Initialize new controllers and focus nodes with the latest data
    symptomControllers = symptoms.map((symptom) {
      var controller = TextEditingController(text: symptom);
      var focusNode = FocusNode();
      focusNode.addListener(() {
        if (!focusNode.hasFocus) {
          saveData();
        }
      });
      symptomFocusNodes.add(focusNode);
      return controller;
    }).toList();

    medicineControllers = medicines.map((medicine) {
      var controller = TextEditingController(text: medicine);
      var focusNode = FocusNode();
      focusNode.addListener(() {
        if (!focusNode.hasFocus) {
          saveData();
        }
      });
      medicineFocusNodes.add(focusNode);
      return controller;
    }).toList();
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
      symptoms.add('');
      var controller = TextEditingController();
      var focusNode = FocusNode();
      focusNode.addListener(() {
        if (!focusNode.hasFocus) {
          symptoms[symptomControllers.indexOf(controller)] = controller.text;
          saveData();
        }
      });
      symptomControllers.add(controller);
      symptomFocusNodes.add(focusNode);
    });
  }

  void _removeSymptom(int index) {
    setState(() {
      symptoms.removeAt(index);
      symptomControllers[index].dispose();
      symptomFocusNodes[index].dispose();
      symptomControllers.removeAt(index);
      symptomFocusNodes.removeAt(index);
    });
    saveData();
  }

  void _addMedicine() {
    setState(() {
      medicines.add('');
      var controller = TextEditingController();
      var focusNode = FocusNode();
      focusNode.addListener(() {
        if (!focusNode.hasFocus) {
          medicines[medicineControllers.indexOf(controller)] = controller.text;
          saveData();
        }
      });
      medicineControllers.add(controller);
      medicineFocusNodes.add(focusNode);
    });
  }

  void _removeMedicine(int index) {
    setState(() {
      medicines.removeAt(index);
      medicineControllers[index].dispose();
      medicineFocusNodes[index].dispose();
      medicineControllers.removeAt(index);
      medicineFocusNodes.removeAt(index);
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Deselect the text field when tapping outside
      },
      child: Scaffold(
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
                  controllers: symptomControllers,
                  focusNodes: symptomFocusNodes,
                  onAdd: _addSymptom,
                  onRemove: _removeSymptom,
                ),
                const SizedBox(height: 20),
                _buildListSection(
                  title: 'Medicine List',
                  items: medicines,
                  controllers: medicineControllers,
                  focusNodes: medicineFocusNodes,
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
      ),
    );
  }

  Widget _buildListSection({
    required String title,
    required List<String> items,
    required List<TextEditingController> controllers,
    required List<FocusNode> focusNodes,
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
                controller: controllers[index],
                focusNode: focusNodes[index],
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

  Widget _buildListItem({
    required int index,
    required TextEditingController controller,
    required FocusNode focusNode,
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
              controller: controller,
              focusNode: focusNode,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
              ),
              onChanged: (newValue) {
                if (symptoms.contains(controller.text)) {
                  symptoms[index] = newValue;
                } else {
                  medicines[index] = newValue;
                }
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

  @override
  void dispose() {
    for (var controller in symptomControllers) {
      controller.dispose();
    }
    for (var controller in medicineControllers) {
      controller.dispose();
    }
    for (var focusNode in symptomFocusNodes) {
      focusNode.dispose();
    }
    for (var focusNode in medicineFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
}
