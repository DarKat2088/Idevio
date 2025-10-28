// lib/main.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(IdevioApp());
}

class IdevioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Idevio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.robotoMonoTextTheme(),
        primaryColor: const Color.fromARGB(255, 115, 223, 199),
        scaffoldBackgroundColor: Colors.deepPurple[50],
      ),
      home: MainTabController(),
    );
  }
}

// ====================
// Контроллер с вкладками (главный экран приложения)
// ====================
class MainTabController extends StatefulWidget {
  @override
  _MainTabControllerState createState() => _MainTabControllerState();
}

class _MainTabControllerState extends State<MainTabController>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentIndex = 0;

  // Данные
  List<String> historyIdeas = [];
  List<String> favoritesIdeas = [];

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

  // Добавить в историю (новая идея сверху)
  void addToHistory(String idea) {
    setState(() {
      historyIdeas.removeWhere((i) => i == idea); // избегаем дублей в истории
      historyIdeas.insert(0, idea);
    });
  }

  // Переключить избранное
  void toggleFavorite(String idea) {
    setState(() {
      if (favoritesIdeas.contains(idea)) {
        favoritesIdeas.remove(idea);
      } else {
        favoritesIdeas.add(idea);
      }
    });
  }

  // Удалить из истории (и из избранного при удалении)
  void removeFromHistory(String idea) {
    setState(() {
      historyIdeas.remove(idea);
      favoritesIdeas.remove(idea);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Idevio - Генератор идей',
          style: GoogleFonts.robotoMono(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(offset: Offset(2, 2), color: Colors.black26, blurRadius: 4)],
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.redAccent,
          labelColor: Colors.redAccent,
          unselectedLabelColor: Colors.black87,
          labelStyle: GoogleFonts.robotoMono(fontSize: 18, fontWeight: FontWeight.bold),
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
            addToHistory: addToHistory,
            currentFavorites: favoritesIdeas,
            toggleFavoriteCallback: toggleFavorite,
          ),
          FavoritesPage(
            favoritesIdeas: favoritesIdeas,
            toggleFavorite: toggleFavorite,
          ),
          HistoryPage(
            historyIdeas: historyIdeas,
            favoritesIdeas: favoritesIdeas,
            toggleFavorite: toggleFavorite,
            removeFromHistory: removeFromHistory,
          ),
        ],
      ),
    );
  }
}

// ====================
// Главная страница генерации идей (весь функционал + анимации)
// ====================
class IdeaGeneratorScreen extends StatefulWidget {
  final Function(String) addToHistory;
  final List<String> currentFavorites;
  final Function(String) toggleFavoriteCallback;

  const IdeaGeneratorScreen({
    Key? key,
    required this.addToHistory,
    required this.currentFavorites,
    required this.toggleFavoriteCallback,
  }) : super(key: key);

  @override
  _IdeaGeneratorScreenState createState() => _IdeaGeneratorScreenState();
}

class _IdeaGeneratorScreenState extends State<IdeaGeneratorScreen>
    with TickerProviderStateMixin {
  final Map<String, List<String>> ideasByCategory = {
    "Технологии": [
      "Создать приложение для изучения языков через мемы",
      "Придумать умную кружку, которая подогревает кофе",
      "Разработать AR-приложение для путешествий по истории города",
      "Разработка умного дома",
      "Создание дронов для доставки",
      "Разработка VR-игры для обучения",
      "Приложение для мониторинга здоровья",
      "ИИ-ассистент для творчества"
    ],
    "Искусство": [
      "Создать генератор идей для художников",
      "Приложение для подбора цветовых палитр",
      "Онлайн-галерея с ИИ-подбором похожих картин",
      "Организация виртуальных выставок",
      "Приложение для 3D-моделирования",
      "Игра с интерактивной живописью",
      "Создание музыкальных сэмплов",
      "Генератор стихов с ИИ"
    ],
    "Образование": [
      "Приложение для изучения истории в формате квестов",
      "Платформа для обмена знаниями между учениками",
      "Мобильный помощник для подготовки к экзаменам",
      "Создание онлайн-курсов",
      "Приложение для изучения языков",
      "Геймификация обучения",
      "Викторины с наградами",
      "Планировщик учебных целей"
    ],
    "Спорт": [
      "Приложение для тренировки дома",
      "Мониторинг активности с ИИ",
      "Приложение для бега с интерактивной картой",
      "Онлайн-фитнес клуб",
      "Программа питания и тренировок",
      "Геймификация спортивных достижений",
      "Приложение для йоги",
      "Подбор команд для спорта"
    ],
    "Путешествия": [
      "Путеводитель с ИИ-советами",
      "Приложение для планирования маршрута",
      "Онлайн-бронирование отелей",
      "Приложение для обмена впечатлениями",
      "Генератор интересных маршрутов",
      "AR-гиды по городам",
      "Социальная сеть путешественников",
      "Приложение с локальными рекомендациями"
    ],
    "Развлечения": [
      "Генератор идей для игр",
      "Приложение для создания мемов",
      "Киноподборка по настроению",
      "Онлайн-викторины",
      "Музыкальные челленджи",
      "Соревнования по мини-играм",
      "Приложение для караоке",
      "Генератор сценариев для видео"
    ],
  };

  String? currentIdea;
  bool isGenerating = false;
  String selectedCategory = "Категории";
  bool isDropdownOpen = false;

  // анимации
  late final AnimationController _ideaController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  late final AnimationController _waveController;
  late final Animation<double> _waveAnimation;

  late final AnimationController _starController;

  bool _isCopied = false;
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    _ideaController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ideaController, curve: Curves.easeOut));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_ideaController);

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _waveAnimation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeOut),
    );

    _starController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
      lowerBound: 0.8,
      upperBound: 1.18,
    );
  }

  @override
  void dispose() {
    _ideaController.dispose();
    _waveController.dispose();
    _starController.dispose();
    super.dispose();
  }

  void generateIdea() {
    // звук (проверь, что файл подключён в pubspec)
    try {
      player.play(AssetSource('sounds/cartoon-game-damage-alert-ni-sound-1-00-03.mp3'));
    } catch (e) {
      // ignore if asset missing in web environment
    }

    setState(() {
      isGenerating = true;
      currentIdea = null;
    });

    Future.delayed(const Duration(milliseconds: 2000), () {
      final selectedCategoryForIdea = selectedCategory == "Категории"
          ? (ideasByCategory.keys.toList()..shuffle()).first
          : selectedCategory;
      final selectedIdeas = ideasByCategory[selectedCategoryForIdea]!;

      setState(() {
        currentIdea = selectedIdeas[Random().nextInt(selectedIdeas.length)];
        isGenerating = false;
      });

      _ideaController.forward(from: 0);

      // Добавляем в историю (родительский колбек)
      widget.addToHistory(currentIdea!);
    });
  }

  // Добавление/удаление из избранного для текущей идеи (и запуск волны при добавлении)
  void toggleFavoriteCurrentIdea() {
    if (currentIdea == null) return;
    widget.toggleFavoriteCallback(currentIdea!);

    // если сейчас в избранном — запустить волну (крупная)
    if (widget.currentFavorites.contains(currentIdea)) {
      // уже было в избранном — удалили; не запускаем волну
    } else {
      // добавляем — запускаем волну
      _waveController.forward(from: 0);
    }
    _starController.forward(from: 0);
  }

  // Светлое уведомление снизу (без чёрного, с золотистым акцентом)
  Future<void> _showCopiedOverlay(BuildContext ctx) async {
    final overlay = Overlay.of(ctx);
    if (overlay == null) return;

    late OverlayEntry entry;
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
      reverseDuration: const Duration(milliseconds: 260),
    );
    final animation = CurvedAnimation(parent: controller, curve: Curves.easeOutCubic);

    entry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 68,
        left: 0,
        right: 0,
        child: FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF9E7), // светлая
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.25),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Text(
                  '✨ Идея скопирована!',
                  style: GoogleFonts.robotoMono(
                    color: Colors.amber.shade700,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    controller.forward();
    await Future.delayed(const Duration(milliseconds: 900));
    await controller.reverse();
    entry.remove();
    controller.dispose();
  }

  Widget buildInitialText() {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          Colors.red.shade400,
          Colors.orange.shade300,
          const Color.fromARGB(255, 235, 214, 26),
          Colors.green.shade400,
          Colors.blue.shade400,
          Colors.purple.shade400,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(
        "Нажмите, чтобы сгенерировать идею!",
        textAlign: TextAlign.center,
        style: GoogleFonts.robotoMono(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildCategoryDropdown() {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: const Color(0xFFFFD700),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => setState(() => isDropdownOpen = !isDropdownOpen),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedCategory,
                    style: GoogleFonts.robotoMono(
                      color: Colors.indigo[900],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: Colors.indigo[900],
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            height: isDropdownOpen ? ideasByCategory.keys.length * 36.0 : 0,
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: ideasByCategory.keys
                  .map(
                    (cat) => InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () => setState(() {
                        selectedCategory = cat;
                        isDropdownOpen = false;
                      }),
                      child: Container(
                        height: 36,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          cat,
                          style: GoogleFonts.robotoMono(
                            color: Colors.indigo[900],
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // main content
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // анимация "Генерация идеи..." или текст/идея
            if (isGenerating)
              AnimatedTextKit(
                key: ValueKey(isGenerating),
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Генерация идеи...',
                    textStyle: GoogleFonts.robotoMono(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrangeAccent,
                    ),
                    speed: const Duration(milliseconds: 100),
                  ),
                ],
                totalRepeatCount: 1,
              )
            else if (currentIdea != null)
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // текст идеи + волна (если в избранном)
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // тонкая волна вокруг текста (появляется когда идея в избранном)
                          if (widget.currentFavorites.contains(currentIdea))
                            AnimatedBuilder(
                              animation: _waveAnimation,
                              builder: (context, child) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.amber.withOpacity(0.22),
                                        spreadRadius: _waveAnimation.value,
                                        blurRadius: _waveAnimation.value * 2.5,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),

                          // сама идея (нажатие копирует и вызывает "светлое" уведомление)
                          GestureDetector(
                            onTap: () async {
                              if (currentIdea == null) return;
                              await Clipboard.setData(ClipboardData(text: currentIdea!));
                              await _showCopiedOverlay(context);
                            },
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 280),
                              child: Text(
                                currentIdea!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.robotoMono(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent.shade400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 10),

                      // звёздочка справа (анимируется при нажатии)
                      ScaleTransition(
                        scale: _starController,
                        child: GestureDetector(
                          onTap: toggleFavoriteCurrentIdea,
                          child: Icon(
                            widget.currentFavorites.contains(currentIdea)
                                ? Icons.star
                                : Icons.star_border,
                            color: widget.currentFavorites.contains(currentIdea)
                                ? Colors.amber
                                : Colors.grey,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              buildInitialText(),

            const SizedBox(height: 40),

            // Старая кнопка "Сгенерировать"
            ElevatedButton.icon(
              onPressed: isGenerating ? null : generateIdea,
              icon: Icon(Icons.auto_awesome, color: Colors.indigo[900], size: 28),
              label: Text(
                "Сгенерировать",
                style: GoogleFonts.robotoMono(
                  color: Colors.indigo[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                shadowColor: Colors.amberAccent,
                elevation: 10,
              ),
            ),

            const SizedBox(height: 30),

            buildCategoryDropdown(),
          ],
        ),
      ),
    );
  }
}

// ====================
// Избранное (с карточками, звёздочкой для удаления)
// ====================
class FavoritesPage extends StatelessWidget {
  final List<String> favoritesIdeas;
  final Function(String) toggleFavorite;

  const FavoritesPage({
    Key? key,
    required this.favoritesIdeas,
    required this.toggleFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (favoritesIdeas.isEmpty) {
      return Center(
        child: Text(
          '⭐ Избранное пусто',
          style: GoogleFonts.robotoMono(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: favoritesIdeas.length,
      itemBuilder: (context, index) {
        final idea = favoritesIdeas[index];
        return Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.yellow.shade100,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(2, 2))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    idea,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.robotoMono(fontSize: 18),
                  ),
                ),
                IconButton(
                  onPressed: () => toggleFavorite(idea),
                  icon: const Icon(Icons.star, color: Colors.amber),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ====================
// История (узкие карточки как ты просил, кнопки - сохранить в избранное/удалить)
// ====================
class HistoryPage extends StatelessWidget {
  final List<String> historyIdeas;
  final List<String> favoritesIdeas;
  final Function(String) toggleFavorite;
  final Function(String) removeFromHistory;

  const HistoryPage({
    Key? key,
    required this.historyIdeas,
    required this.favoritesIdeas,
    required this.toggleFavorite,
    required this.removeFromHistory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (historyIdeas.isEmpty) {
      return Center(
        child: Text(
          '🕓 История пуста',
          style: GoogleFonts.robotoMono(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: historyIdeas.length,
      itemBuilder: (context, index) {
        final idea = historyIdeas[index];
        final isStarred = favoritesIdeas.contains(idea);

        return Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(1, 1))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    idea,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.robotoMono(fontSize: 18),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => toggleFavorite(idea),
                      icon: Icon(Icons.star, color: isStarred ? Colors.amber : Colors.grey),
                    ),
                    IconButton(
                      onPressed: () => removeFromHistory(idea),
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
