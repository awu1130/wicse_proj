import 'package:flutter/material.dart';

class PlantDetailScreen extends StatefulWidget {
  final String plantName;
  final String plantImagePath;

  PlantDetailScreen({required this.plantName, required this.plantImagePath});

  @override
  _PlantDetailScreenState createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  double _waterLevel = 0.0; // Progress value between 0.0 and 1.0

  void _incrementWaterLevel() {
    setState(() {
      _waterLevel += 0.1; // Increment water level by 10%
      if (_waterLevel > 1.0) _waterLevel = 1.0; // Cap at 100%
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plantName),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              const Color.fromARGB(255, 138, 184, 222),
              const Color.fromARGB(255, 175, 225, 176),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Top Center Text
            Positioned(
              top: 40, // Adjust the distance from the top
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  widget.plantName,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 77, 76, 76), // Text color
                  ),
                ),
              ),
            ),
            // Center Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                    child: Image.asset(
                      widget.plantImagePath,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _incrementWaterLevel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 60, 164, 195), // Button background color
                      foregroundColor: Colors.white, // Button text color
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Tap to Water'),
                  ),
                  SizedBox(height: 40),
                  Container(
                    width: 200,
                    height: 20,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _waterLevel, // Progress indicator value
                        backgroundColor: Colors.grey[300],
                        color: const Color.fromARGB(255, 60, 164, 195),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '${(_waterLevel * 100).toInt()}% of Daily Water Goal Reached',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
