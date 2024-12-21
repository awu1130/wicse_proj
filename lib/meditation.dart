import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RunMyApp());
}

class RunMyApp extends StatelessWidget {
  const RunMyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'HelveticaNeue'),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/img/background_name.png"),
                fit: BoxFit.cover),
          ),
          child: const CarouselExample(),
        ),
      ),
    );
  }
}
class CarouselExample extends StatefulWidget {
  const CarouselExample({super.key});

  @override
  _CarouselExampleState createState() => _CarouselExampleState();
}

class _CarouselExampleState extends State<CarouselExample> {
  late PageController _pageController;
  int _currentIndex = 0;
  bool _isAddingTask = false;
  List<String> tasks = [];
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: .5);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _taskController.dispose();
    super.dispose();
  }

  void _addTask(String task) {
    if (task.isNotEmpty) {
      setState(() {
        tasks.add(task);
        _isAddingTask = false;
        _taskController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 60),
            const Text(
              'Welcome to The Mindfulness Corner',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: Offset(0, 2),
                    blurRadius: 3.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: PageView.builder(
                controller: _pageController,
                itemCount: ImageInfo.values.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final scale = index == _currentIndex ? 1.0 : 0.9;
                  return GestureDetector(
                    onTap: () {
                      if (index == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BreathingPage()),
                        );
                      } else if (index == 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => JournalEntryScreen()),
                        );
                      }
                    },
                    child: Transform.scale(
                      scale: scale,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              ImageInfo.values[index].url,
                              height: 120,
                              width: 120,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              ImageInfo.values[index].title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                ImageInfo.values[index].subtitle,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                ImageInfo.values.length,
                (indicatorIndex) => AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  height: 8.0,
                  width: _currentIndex == indicatorIndex ? 16.0 : 8.0,
                  decoration: BoxDecoration(
                    color: _currentIndex == indicatorIndex
                        ? Colors.white
                        : Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TaskCard(
                onAddPressed: () {
                  setState(() {
                    _isAddingTask = true;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            tasks[index],
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              tasks.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        if (_isAddingTask)
          GestureDetector(
            onTap: () {
              setState(() {
                _isAddingTask = false;
              });
            },
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: GestureDetector(
                  onTap: () {}, // Prevent taps from closing the dialog
                  child: Container(
                    width: 300,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _taskController,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: "Enter your task...",
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: _addTask,
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isAddingTask = false;
                                  _taskController.clear();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                              ),
                              child: Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () => _addTask(_taskController.text),
                              child: Text("Add Task"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class TaskCard extends StatelessWidget {
  final VoidCallback onAddPressed;

  const TaskCard({
    Key? key,
    required this.onAddPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 209, 230, 211),
        borderRadius: BorderRadius.circular(20),
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
            icon: Icon(Icons.add_circle, color: const Color.fromARGB(255, 173, 214, 246)),
            onPressed: onAddPressed,
          ),
        ],
      ),
    );
  }
}
class BreathingPage extends StatefulWidget {
  @override
  _BreathingPageState createState() => _BreathingPageState();
}

class _BreathingPageState extends State<BreathingPage>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  var _breathe = 0.0;

  @override
  void initState() {
    super.initState();
    _breathingController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 4500));

    _breathingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _breathingController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _breathingController.forward();
      }
    });

    _breathingController.addListener(() {
      setState(() {
        _breathe = _breathingController.value;
      });
    });

    _breathingController.forward();
  }

@override
Widget build(BuildContext context) {
  final size = 200.0 - 100.0 * _breathe;
  final isBreathingIn = _breathingController.status == AnimationStatus.forward;
  final text = _breathingController.isAnimating
      ? (isBreathingIn ? 'Breathe In' : 'Breathe Out')
      : '';
  final imagePath = isBreathingIn
      ? "assets/img/resp.jpg"
      : "assets/img/outing.jpg";

  return Scaffold(
    body: DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/img/background_name.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: BackButton(
                  color: Colors.black,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Stay For As Long As You Need',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 3.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: size,
                      width: size,
                      child: ClipOval(
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }
}

class JournalEntryScreen extends StatefulWidget {
  @override
  _JournalEntryScreenState createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {
  final _textController = TextEditingController();
  final _entries = <Map<String, String>>[];

  void _saveJournalEntry() {
    final entry = _textController.text.trim();
    if (entry.isNotEmpty) {
      final date = DateTime.now();
      final formattedDate = "${date.day}/${date.month}/${date.year}";
      setState(() {
        _entries.add({
          'date': formattedDate,
          'entry': entry,
        });
        _textController.clear();
      });
    }
  }

  void _deleteEntry(int index) {
    setState(() {
      _entries.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/background_name.png'), // Ensure the image exists in the correct folder
            fit: BoxFit.cover, // Ensures the image covers the entire background
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Custom title with back button
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context); // Pops the screen and returns to the previous screen
                  },
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'My Journal',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            // TextField for writing journal entries
            TextField(
              controller: _textController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Write your thoughts here...',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white.withOpacity(0.7), // Adds a translucent background to the text field
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveJournalEntry,
              child: Text('Save Entry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[50], // Sets the background color
                ),
              ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _entries.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    color: Colors.green[50], // Set the background color for saved entries
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _entries[index]['date']!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(_entries[index]['entry']!),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteEntry(index),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum ImageInfo {
  image0('Breathing Exercise', 'Quick Grounding Guided Breathing.', 'assets/img/breathe.jpg'),
  image2('Quick Journal Exercise', 'Quick Entries to Gather Your Thoughts.', 'assets/img/journal.jpg'),
  image3('Music Meditation', 'Jam Out and Unwind', 'assets/img/music.jpg');

  const ImageInfo(this.title, this.subtitle, this.url);
  final String title;
  final String subtitle;
  final String url;
}
