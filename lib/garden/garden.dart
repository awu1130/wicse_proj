import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import 'plant_details.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class GardenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
        ),
      ),
    );
  }
}

class PlantGrid extends StatefulWidget {
  @override
  _PlantGridState createState() => _PlantGridState();
}

class _PlantGridState extends State<PlantGrid> {
  List<Map<String, String>> plantImages = [
    {'name': 'Rose', 'imagePath': 'images/plant1.png'},
    {'name': 'Tulip', 'imagePath': 'images/plant2.png'},
    {'name': 'Sunflower', 'imagePath': 'images/plant3.png'},
    {'name': 'Daisy', 'imagePath': 'images/plant4.png'},
    {'name': 'Peony', 'imagePath': 'images/plant5.png'},
    {'name': 'Orchid', 'imagePath': 'images/plant6.png'},
    {'name': 'Jasmine', 'imagePath': 'images/plant7.png'},
    {'name': 'Marigold', 'imagePath': 'images/plant8.png'},
    {'name': 'Chrysanthemum', 'imagePath': 'images/plant9.png'},
    {'name': 'Carnation', 'imagePath': 'images/plant10.png'},
    {'name': 'Lisianthus', 'imagePath': 'images/plant11.png'},
    {'name': 'Morning Glory', 'imagePath': 'images/plant12.png'},
    {'name': 'Alstroemeria', 'imagePath': 'images/plant13.png'},
    {'name': 'Dahlia', 'imagePath': 'images/plant14.png'},
    {'name': 'Aster', 'imagePath': 'images/plant15.png'},
    {'name': 'Azalea', 'imagePath': 'images/plant16.png'},
    {'name': 'Begonia', 'imagePath': 'images/plant17.png'},
    {'name': 'Iris', 'imagePath': 'images/plant18.png'},
    {'name': 'Hydrangea', 'imagePath': 'images/plant19.png'},
    {'name': 'Craspedia', 'imagePath': 'images/plant20.png'},
    {'name': 'Anemone', 'imagePath': 'images/plant21.png'},
    {'name': 'Cornflower', 'imagePath': 'images/plant22.png'},
    {'name': 'Delphinium', 'imagePath': 'images/plant23.png'},
    {'name': 'Cosmos', 'imagePath': 'images/plant24.png'},
    {'name': 'Eucalyptus', 'imagePath': 'images/plant25.png'},
    {'name': 'Forget-Me-Not', 'imagePath': 'images/plant26.png'},
    {'name': 'Freesia', 'imagePath': 'images/plant27.png'},
    {'name': 'Gladiolus', 'imagePath': 'images/plant28.png'},
    {'name': 'Gardenia', 'imagePath': 'images/plant29.png'},
    {'name': 'Gypsophila', 'imagePath': 'images/plant30.png'},
    {'name': 'Honeysuckle', 'imagePath': 'images/plant31.png'},
    {'name': 'Lavender', 'imagePath': 'images/plant32.png'},
    {'name': 'Lilac', 'imagePath': 'images/plant33.png'},
    {'name': 'Lily of the Valley', 'imagePath': 'images/plant34.png'},
    {'name': 'Lotus', 'imagePath': 'images/plant35.png'},
    {'name': 'Monkshood', 'imagePath': 'images/plant36.png'},
    {'name': 'Poppy', 'imagePath': 'images/plant37.png'},
    {'name': 'Wisteria', 'imagePath': 'images/plant38.png'},
  ];

  void addPlant(String imageName, String imagePath) {
    setState(() {
      plantImages.add({'name': imageName, 'imagePath': imagePath});
    });
  }

  void removePlant(int index) {
    setState(() {
      plantImages.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPlants();
  }

  Future<void> fetchPlants() async {
    final response = await http.get(Uri.parse('http://localhost:3000/plants'));
    if (response.statusCode == 200) {
      final List<dynamic> plants = json.decode(response.body);
      setState(() {
        plantImages = plants.map((plant) {
          return {
            'name': plant['name'] as String,
            'imagePath': plant['imagePath'] as String,
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load plants');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Transparent status bar
        statusBarIconBrightness:
            Brightness.light, // Light icons on dark background
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Plants'),
          leading: IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pop(context); // home page
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                addPlant('new_plant', 'assets/new_plant.jpg');
              },
            ),
          ],
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
          child: GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 30,
              mainAxisSpacing: 30,
            ),
            itemCount: plantImages.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlantDetailScreen(
                        plantName: plantImages[index]['name']!,
                        plantImagePath: plantImages[index]['imagePath']!,
                      ),
                    ),
                  );
                },
                onLongPress: () {
                  removePlant(index);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.2), // Shadow color with opacity
                        blurRadius: 10, // Softness of the shadow
                        offset: Offset(5, 5), // Position of the shadow (x, y)
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(20), // Same as the container
                    child: Image.asset(
                      plantImages[index]['imagePath']!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
