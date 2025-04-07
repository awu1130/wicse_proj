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

  void _calculateWaterIntake() {
    final double weight = double.tryParse(_weightController.text) ?? 0;
    final double exerciseMinutes = double.tryParse(_exerciseController.text) ?? 0;
    final double waterIntake = (weight * 0.5) + (exerciseMinutes / 30 * 12);
    final double increment = waterIntake * 0.1;

    setState(() {
      _totalWaterIntake = waterIntake;
      _increment = increment;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Intake Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
              ),
            ),
            const SizedBox(height: 20),

            // Calculate Button
            ElevatedButton(
              onPressed: _calculateWaterIntake,
              child: const Text('Calculate Water Intake'),
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
                'Water your favorite plant every ${_increment!.toStringAsFixed(2)} ounces.',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
