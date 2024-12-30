import 'package:flutter/material.dart';
import 'screens/jokes_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = true; // Initial mode

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JokeZone',
      theme: isDarkMode
          ? ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.teal,
      )
          : ThemeData.light(),
      home: JokesScreen(
        isDarkMode: isDarkMode,
        onToggleTheme: toggleTheme,
      ),
    );
  }
}
