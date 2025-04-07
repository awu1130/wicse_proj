import 'package:flutter/material.dart';
import 'garden.dart';
import 'med_calendar.dart';
import 'meditation.dart';
import 'water_intake.dart';

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
      body: Stack(
        children: [
          Container(
            color: Color(0xFFE0F7FA), // set background color to a very light blue
          ),
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
                  child: Image.asset(
                    'test.gif', // temp flower image
                    width: 300,
                    height: 200,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter, // align soil image to the bottom center
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondRoute()),
                    );
              },
              child: Image.asset(
                'soil.jpg', // temp soil image
                width: 300,
                height: 300,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft, // align sun image to the top-left corner
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>RunMyApp()),
                    );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0), // padding
                child: Image.asset(
                  'sun.jpg', // temp sun image
                  width: 150,
                  height: 150,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight, // align can image to the top-right corner
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>WaterIntakePage()),
                    );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0), // padding
                child: Image.asset(
                  'can.jpg', // temp can image
                  width: 150,
                  height: 150,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}