import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WaterIntakePage extends StatefulWidget {
  @override
  _WaterIntakePageState createState() => _WaterIntakePageState();
}

class _WaterIntakePageState extends State<WaterIntakePage> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _exerciseController = TextEditingController();
  double? _totalWaterIntake;
  double? _increment;
  int? _cups;

  void _calculateWaterIntake() {
    final double weight = double.tryParse(_weightController.text) ?? 0;
    final double exerciseMinutes = double.tryParse(_exerciseController.text) ?? 0;
    final double waterIntake = (weight * 0.5) + (exerciseMinutes / 30 * 12);
    final double increment = waterIntake * 0.1;
    final int cups = (increment / 8).round();

    setState(() {
      _totalWaterIntake = waterIntake;
      _increment = increment;
      _cups = cups;
    });
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Water Intake Calculator'),
    ),
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color.fromARGB(255, 138, 184, 222),
            Color.fromARGB(255, 175, 225, 176),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Weight Input
                TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Weight (in pounds)',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // Exercise Minutes Input
                TextField(
                  controller: _exerciseController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Exercise Minutes per Day',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // calculate Button
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF8AB8DE), 
                        Color(0xFFAFE1B0), 
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _calculateWaterIntake,
                    child: const Text(
                      'Calculate Water Intake',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),


                // Display result
                if (_totalWaterIntake != null)
                  Text(
                    'You need ${_totalWaterIntake!.toStringAsFixed(2)} ounces of water per day.',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                if (_increment != null)
                  Text(
                    'Water your favorite plant every ${_increment!.toStringAsFixed(2)} ounces (${_cups.toString}).',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}
