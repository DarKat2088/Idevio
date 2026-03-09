import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/main_tab_controller.dart';

class IdevioApp extends StatefulWidget {
  @override
  _IdevioAppState createState() => _IdevioAppState();
}

class _IdevioAppState extends State<IdevioApp> {
  ThemeMode themeMode = ThemeMode.light;
  List<String> favoritesIdeas = [];
  List<String> historyIdeas = [];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      themeMode =
          (prefs.getBool('isDarkTheme') ?? false) ? ThemeMode.dark : ThemeMode.light;
      favoritesIdeas = prefs.getStringList('favoritesIdeas') ?? [];
      historyIdeas = prefs.getStringList('historyIdeas') ?? [];
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkTheme', themeMode == ThemeMode.dark);
    prefs.setStringList('favoritesIdeas', favoritesIdeas);
    prefs.setStringList('historyIdeas', historyIdeas);
  }

  void toggleTheme() {
    setState(() {
      themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
    _savePreferences();
  }

  void addToHistory(String idea) {
    setState(() {
      historyIdeas.removeWhere((i) => i == idea);
      historyIdeas.insert(0, idea);
    });
    _savePreferences();
  }

  void toggleFavorite(String idea) {
    setState(() {
      if (favoritesIdeas.contains(idea)) {
        favoritesIdeas.remove(idea);
      } else {
        favoritesIdeas.add(idea);
      }
    });
    _savePreferences();
  }

  void removeFromHistory(String idea) {
    setState(() {
      historyIdeas.remove(idea);
      favoritesIdeas.remove(idea);
    });
    _savePreferences();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Idevio',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color.fromARGB(255, 115, 223, 199),
        scaffoldBackgroundColor: Colors.deepPurple[50],
        textTheme: GoogleFonts.robotoMonoTextTheme().apply(
          bodyColor: Colors.black87,
          displayColor: Colors.black87,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 4,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFD700),
            foregroundColor: Colors.indigo,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 10,
          ),
        ),
        cardColor: Colors.yellow.shade100,
        iconTheme: const IconThemeData(color: Colors.indigo),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.tealAccent,
        scaffoldBackgroundColor: Colors.grey[900],
        textTheme: GoogleFonts.robotoMonoTextTheme().apply(
          bodyColor: Colors.white70,
          displayColor: Colors.white70,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[850],
          foregroundColor: Colors.white70,
          elevation: 4,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 10,
          ),
        ),
        cardColor: Colors.grey[800],
        iconTheme: const IconThemeData(color: Colors.tealAccent),
      ),
      home: MainTabController(
        toggleTheme: toggleTheme,
        themeMode: themeMode,
        favoritesIdeas: favoritesIdeas,
        historyIdeas: historyIdeas,
        addToHistory: addToHistory,
        toggleFavorite: toggleFavorite,
        removeFromHistory: removeFromHistory,
      ),
    );
  }
}
