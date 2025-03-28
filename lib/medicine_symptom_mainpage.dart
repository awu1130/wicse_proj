import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'medicine_symptom_settings.dart';
import 'main.dart';
import 'calendar_day.dart';

class MainPage extends StatefulWidget {
  final DateTime date;

  const MainPage({Key? key, required this.date}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // medicines list to save
  List<Map<String, dynamic>> medicines = [];

  final TextEditingController medicineNameController = TextEditingController();
  final TextEditingController medicineTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getMeds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Medicine Schedule"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: medicines.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(medicines[index]["name"]),
                    subtitle: Text("${medicines[index]["time"]}"),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: medicineNameController,
                    decoration: const InputDecoration(
                      hintText: "Enter medicine name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: medicineTimeController,
                    decoration: const InputDecoration(
                      hintText: "Enter time to take (e.g. 8:30am)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (medicineNameController.text.isNotEmpty &&
                        medicineTimeController.text.isNotEmpty) {
                      setState(() {
                        medicines.add({
                          "name": medicineNameController.text,
                          "time": medicineTimeController.text,
                        });
                      });
                      medicineNameController.clear();
                      medicineTimeController.clear();
                    }
                  },
                  child: const Text("Add"),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _saveMed();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DayDetailsPage(date: widget.date),
                      ),
                    );
                  },
                  child: const Text("Save"),
                ),
                OutlinedButton(
                  onPressed: () {
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

  Future<void> _saveMed() async {
    for (var medicine in medicines) {
      try {
        var response = await http.post(
          Uri.parse('http://localhost:5000/saveMed'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode({
            'name': medicine["name"],
            'time': medicine["time"],
          }),
        );

        if (response.statusCode == 201) {
          print('Medicine saved successfully!');
        } else {
          print('Failed to save medicine. Response: ${response.body}');
        }
      } catch (e) {
        print('Error saving medicine: $e');
      }
    }
  }
}
