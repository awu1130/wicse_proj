import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'med_calendar.dart';
import 'medicine_symptom_mainpage.dart';

class DayDetailsPage extends StatefulWidget {
  final DateTime date;

  const DayDetailsPage({Key? key, required this.date}) : super(key: key);

  @override
  _DayDetailsPageState createState() => _DayDetailsPageState();
}

class _DayDetailsPageState extends State<DayDetailsPage> {
  List<Map<String, dynamic>> medicines = [];
  List<Map<String, dynamic>> symptoms = [];
  final TextEditingController symptomController = TextEditingController();
  final TextEditingController medicineNameController = TextEditingController();
  final TextEditingController medicineTimeController = TextEditingController();
  IconData? selectedIcon;
  List<Map<String, dynamic>> savedDays = [];
  Map<String, IconData> icons = {}; // Define icons here

  @override
  void initState() {
    super.initState();
    _getMeds();
    _getDays();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getDays(); // Ensure data is fetched whenever the widget is rebuilt
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          DateFormat('EEEE, MMMM d, yyyy').format(widget.date),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                children: [
                  const Text(
                    "Medicines",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: medicines.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        title: Text("${medicines[index]["time"]} - ${medicines[index]["name"]}"),
                        value: medicines[index]["isChecked"] ?? false,
                        onChanged: (bool? value) {
                          setState(() {
                            medicines[index]["isChecked"] = value!;
                          });
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainPage(date: widget.date),
                        ),
                      );
                    },
                    child: const Text("Adjust Schedule"),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "Symptoms",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: symptoms.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(symptoms[index]["name"]),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  // Input symptoms
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: symptomController,
                          decoration: const InputDecoration(
                            hintText: "Enter a symptom",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (symptomController.text.isNotEmpty) {
                            setState(() {
                              symptoms.add({
                                "name": symptomController.text,
                                //"icon": selectedIcon,
                              });
                              symptomController.clear();
                            });
                          }
                        },
                        child: const Text("Add"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Choose faces
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSelectableIcon(Icons.sentiment_very_satisfied, "Very Happy"),
                      _buildSelectableIcon(Icons.sentiment_satisfied, "Happy"),
                      _buildSelectableIcon(Icons.sentiment_dissatisfied, "Sad"),
                      _buildSelectableIcon(Icons.sentiment_very_dissatisfied, "Very Sad"),
                    ],
                  ),
                ],
              ),
            ),
            // Save and Cancel buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await _saveDay();
                    Navigator.pop(context, {
                      "symptoms": symptoms,
                      "medicines": medicines,
                      "selectedIcon": selectedIcon,
                    });
                  },
                  child: const Text("Save"),
                ),
                OutlinedButton(
                  onPressed: () {
                    // Cancel and go back
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SecondRoute(),
                      ),
                    );
                  },
                  child: const Text("Cancel"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveDay() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/saveDay'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'date': widget.date.toIso8601String(),
          'medicines': medicines,
          'symptoms': symptoms,
          'icon': selectedIcon?.codePoint,
        }),
      );

      if (response.statusCode == 201) {
        print('Day saved successfully!');
      } else {
        print('Failed to save day. Response: ${response.body}');
      }
    } catch (e) {
      print('Error saving day: $e');
    }
  }

  Future<void> _getDays() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5000/getDays'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        Map<String, IconData> fetchedIcons = {};

        for (var day in data) {
          DateTime savedDate = DateTime.parse(day['date']);
          if (savedDate.year == widget.date.year && savedDate.month == widget.date.month && savedDate.day == widget.date.day) {
            // Ensure the correct day is fetched
            if (day['icon'] != null) {
              fetchedIcons[savedDate.toString()] = IconData(
                day['icon'],
                fontFamily: 'MaterialIcons',
              );
            }
            // Update the medicines and symptoms for this specific day
            setState(() {
              symptoms = List<Map<String, dynamic>>.from(day['symptoms']);
              medicines = List<Map<String, dynamic>>.from(day['medicines']);
              selectedIcon = fetchedIcons[savedDate.toString()];
            });
          }
        }
      } else {
        print("Failed to load days: ${response.body}");
      }
    } catch (e) {
      print("Error loading days: $e");
    }
  }

  Widget _buildSelectableIcon(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIcon = icon;
        });
      },
      child: Column(
        children: [
          Icon(
            icon,
            color: selectedIcon == icon ? Colors.blue : Colors.grey,
            size: 36,
          ),
          Text(
            label,
            style: TextStyle(
              color: selectedIcon == icon ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getMeds() async {
    try {
      var response = await http.get(
        Uri.parse('http://localhost:5000/getMeds'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          medicines = List<Map<String, dynamic>>.from(data);
        });
      } else {
        print('Failed to get medicines. Response: ${response.body}');
      }
    } catch (e) {
      print('Error getting medicines: $e');
    }
  }

  @override
  void dispose() {
    symptomController.dispose();
    medicineNameController.dispose();
    medicineTimeController.dispose();
    super.dispose();
  }
}
