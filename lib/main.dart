import 'package:flutter/material.dart';
import 'package:habit_hammer/pages/habitsPage.dart';
import 'package:habit_hammer/pages/profilePage.dart';
import 'package:habit_hammer/pages/progressPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/homePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NavigationScreen(
        currentIndex: 3,
      ),
    );
  }
}

class NavigationScreen extends StatefulWidget {
  NavigationScreen({required this.currentIndex});
  int currentIndex;
  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

const List<Widget> screens = [
  HomePage(),
  ProgressPage(),
  HabitsPage(),
  ProfilePage()
];

class _NavigationScreenState extends State<NavigationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: widget.currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.deepPurpleAccent,
        currentIndex: widget.currentIndex,
        onTap: (index) {
          setState(() {
            widget.currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: "Progress"),
          BottomNavigationBarItem(icon: Icon(Icons.timeline), label: "Habits"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
        ],
      ),
    );
  }
}
