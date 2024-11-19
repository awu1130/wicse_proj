import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayDetailsPage extends StatefulWidget {
  final DateTime date;

  const DayDetailsPage({Key? key, required this.date}) : super(key: key);

  @override
  _DayDetailsPageState createState() => _DayDetailsPageState();
}

class _DayDetailsPageState extends State<DayDetailsPage> {
  // List of medicines and their checked status
  final List<Map<String, dynamic>> medicines = [
    {"time": "8:30am", "name": "Paracetamol", "isChecked": false},
    {"time": "12:30pm", "name": "Ibuprofen", "isChecked": false},
    {"time": "3:00pm", "name": "Amoxicillin", "isChecked": false},
    {"time": "7:00pm", "name": "Cough Syrup", "isChecked": false},
  ];

  // List of symptoms with icons
  final List<Map<String, dynamic>> symptoms = [];
  final TextEditingController symptomController = TextEditingController();
  IconData selectedIcon = Icons.sentiment_satisfied; // Default selected icon

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
            // Main content
            Expanded(
              child: ListView(
                children: [
                  // Medicines section
                  const Text(
                    "Medicines",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16), // Space before medicines list
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: medicines.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        title: Text("${medicines[index]["time"]} - ${medicines[index]["name"]}"),
                        value: medicines[index]["isChecked"],
                        onChanged: (bool? value) {
                          setState(() {
                            medicines[index]["isChecked"] = value!;
                          });
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 32), // Space between sections

                  // Symptoms section
                  const Text(
                    "Symptoms",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16), // Space before symptoms list
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: symptoms.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(symptoms[index]["icon"], color: Colors.blue),
                        title: Text(symptoms[index]["name"]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              symptoms.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16), // Space between symptoms list and input

                  // Input for symptoms
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
                                "icon": selectedIcon,
                              });
                              symptomController.clear();
                            });
                          }
                        },
                        child: const Text("Add"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8), // Space between input and icons

                  // Icon selection
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
                  onPressed: () {
                    // Implement Save functionality
                    Navigator.pop(context, {"symptoms": symptoms, "medicines": medicines});
                  },
                  child: const Text("Save"),
                ),
                OutlinedButton(
                  onPressed: () {
                    // Cancel and go back
                    Navigator.pop(context);
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

  Widget _buildSelectableIcon(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIcon = icon; // Update the selected icon
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

  @override
  void dispose() {
    symptomController.dispose();
    super.dispose();
  }
}
