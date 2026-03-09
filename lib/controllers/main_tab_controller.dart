import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/cosmic_background.dart';
import '../widgets/falling_emojis.dart';

import '../screens/idea_generator_screen.dart';
import '../screens/favorites_page.dart';
import '../screens/history_page.dart';

class MainTabController extends StatefulWidget {
  final VoidCallback toggleTheme;
  final ThemeMode themeMode;
  final List<String> favoritesIdeas;
  final List<String> historyIdeas;
  final Function(String) addToHistory;
  final Function(String) toggleFavorite;
  final Function(String) removeFromHistory;

  const MainTabController({
    Key? key,
    required this.toggleTheme,
    required this.themeMode,
    required this.favoritesIdeas,
    required this.historyIdeas,
    required this.addToHistory,
    required this.toggleFavorite,
    required this.removeFromHistory,
  }) : super(key: key);

  @override
  State<MainTabController> createState() => _MainTabControllerState();
}

class _MainTabControllerState extends State<MainTabController>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentIndex = 0;
  bool showFallingEmojis = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => currentIndex = _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void toggleFallingEmojis() {
    setState(() {
      showFallingEmojis = !showFallingEmojis;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CosmicAnimatedBackground(themeMode: widget.themeMode),
          if (showFallingEmojis) 
          FallingEmojis(count: 20, enabled: true),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              'Idevio',
              style: GoogleFonts.robotoMono(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    color: Colors.black26,
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            centerTitle: true,
            actions: [
              // Кнопка переключения темы
              Tooltip(
                message: widget.themeMode == ThemeMode.light
                    ? "Включить тёмную тему"
                    : "Включить светлую тему",
                child: IconButton(
                  icon: Icon(widget.themeMode == ThemeMode.light
                      ? Icons.dark_mode
                      : Icons.light_mode),
                  onPressed: widget.toggleTheme,
                ),
              ),
              // Кнопка включения/выключения падающих эмодзи
              Tooltip(
                message: showFallingEmojis
                    ? "Выключить падающие эмодзи"
                    : "Включить падающие эмодзи",
                child: IconButton(
                  icon: Icon(
                    showFallingEmojis
                        ? Icons.auto_awesome
                        : Icons.celebration,
                    color: widget.themeMode == ThemeMode.light
                        ? Colors.black87
                        : Colors.tealAccent,
                  ),
                  onPressed: toggleFallingEmojis,
                ),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: widget.themeMode == ThemeMode.light
                  ? Colors.redAccent
                  : Colors.tealAccent,
              labelColor: widget.themeMode == ThemeMode.light
                  ? Colors.redAccent
                  : Colors.tealAccent,
              unselectedLabelColor: widget.themeMode == ThemeMode.light
                  ? Colors.black87
                  : Colors.white70,
              labelStyle: GoogleFonts.robotoMono(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              tabs: const [
                Tab(text: "Главная"),
                Tab(text: "Избранное"),
                Tab(text: "История"),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              IdeaGeneratorScreen(
                addToHistory: widget.addToHistory,
                currentFavorites: widget.favoritesIdeas,
                toggleFavoriteCallback: widget.toggleFavorite,
                themeMode: widget.themeMode,
              ),
              FavoritesPage(
                favoritesIdeas: widget.favoritesIdeas,
                toggleFavorite: widget.toggleFavorite,
              ),
              HistoryPage(
                historyIdeas: widget.historyIdeas,
                favoritesIdeas: widget.favoritesIdeas,
                toggleFavorite: widget.toggleFavorite,
                removeFromHistory: widget.removeFromHistory,
              ),
            ],
          ),
        ),
      ],
    );
  }
}