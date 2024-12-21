import 'package:flutter/material.dart';

void main() {
  runApp(GardenWorkApp());
}

class GardenWorkApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'HelveticaNeue',  
      ),
      home: GardenWorkScreen(),  
    );
  }
}

class GardenWorkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50], 
      appBar: AppBar(
        title: Text('Garden Work'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Let's Unwind [Name]", 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 20),
            TaskCard(), 
            SizedBox(height: 20),
            GardeningSessionCard(), 
            SizedBox(height: 40),
            Text(
              'How are you Feeling Today?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            EmotionButtons(),
          ],
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Add Tasks to Book',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.add_circle, color: Colors.blue),
            onPressed: () {
              
            },
          ),
        ],
      ),
    );
  }
}

class GardeningSessionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Image.asset(
            'assets/img/iPhone 14.png', // Correct path
            height: 100,
          ),
          SizedBox(height: 10),
          Text(
            'Ready to Begin A Gardening Session?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text('Unwind and unwind'),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('20 Minutes', style: TextStyle(fontSize: 16)),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.play_circle_fill, size: 30),
                onPressed: () {
                  // Play session functionality
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EmotionButtons extends StatelessWidget {
  final emotions = ['Anxiety', 'Jealousy', 'Excitement', 'Anger'];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 15,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: emotions.map((emotion) {
        return ElevatedButton(
          onPressed: () {
            // Emotion button functionality
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[100],
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            emotion,
            style: TextStyle(fontSize: 16),
          ),
        );
      }).toList(),
    );
  }
}
