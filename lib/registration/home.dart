import 'package:flutter/material.dart';
import '../garden/garden.dart';
import '../medicine/med_calendar.dart';
import '../meditation.dart';
import '../garden/water_intake.dart';

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Button Page Navigation',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
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
            // Centered flower image
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PlantGrid()),
                      );
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/test.gif', 
                          width: 150,
                          height: 150,
                        ),
                        const Text(
                          'Explore Your Plants', 
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
            // Bottom-aligned soil image
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecondRoute()),
                  );
                },
              child: Stack(
                children: [
                  // Soil image
                  Image.asset(
                    'assets/soil.jpg', 
                    width: 800,
                    height: 150,
                  ),
                  // soil text
                  Positioned(
                    bottom: 10, 
                    left: 20,   
                    right: 20, 
                    child: Text(
                      'Track Your Medicines and Symptoms', 
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              ),
            ),
            // Top-left-aligned sun image
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RunMyApp()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    //mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/sun.jpg', 
                        width: 100,
                        height: 100,
                      ),
                      const Text(
                        'Recharge with Medidation', 
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Top-right-aligned can image
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WaterIntakePage()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    //mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/can.jpg', 
                        width: 100,
                        height: 100,
                      ),
                      const Text(
                        'Calculate Your Water Intake', 
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
