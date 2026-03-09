import 'package:flutter/material.dart';
import 'package:flutter/services.dart';              
import 'package:google_fonts/google_fonts.dart';    
import 'package:animated_text_kit/animated_text_kit.dart'; 
import 'package:audioplayers/audioplayers.dart';  
import 'favorites_page.dart';                      
import 'history_page.dart';                        
import '../widgets/animated_rainbow_text.dart';

class IdeaGeneratorScreen extends StatefulWidget {
  final Function(String) addToHistory;
  final List<String> currentFavorites;
  final Function(String) toggleFavoriteCallback;
  final ThemeMode themeMode;

  const IdeaGeneratorScreen({
    Key? key,
    required this.addToHistory,
    required this.currentFavorites,
    required this.toggleFavoriteCallback,
    required this.themeMode,
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
      "ИИ-ассистент для творчества",
      "Приложение для умного списка покупок", 
      "Генератор прототипов интерфейсов с ИИ"
    ],
    "Искусство": [
      "Создать генератор идей для художников",
      "Приложение для подбора цветовых палитр",
      "Онлайн-галерея с ИИ-подбором похожих картин",
      "Организация виртуальных выставок",
      "Приложение для 3D-моделирования",
      "Игра с интерактивной живописью",
      "Создание музыкальных сэмплов",
      "Генератор стихов с ИИ",
      "ИИ-помощник по созданию комиксов",
      "Приложение для визуализации идей для интерьера"
    ],
    "Образование": [
      "Приложение для изучения истории в формате квестов",
      "Платформа для обмена знаниями между учениками",
      "Мобильный помощник для подготовки к экзаменам",
      "Создание онлайн-курсов",
      "Приложение для изучения языков",
      "Геймификация обучения",
      "Викторины с наградами",
      "Планировщик учебных целей",
      "Приложение для запоминания слов с флеш-картами",
      "Симулятор научных экспериментов"
    ],
    "Спорт": [
      "Приложение для тренировки дома",
      "Мониторинг активности с ИИ",
      "Приложение для бега с интерактивной картой",
      "Онлайн-фитнес клуб",
      "Программа питания и тренировок",
      "Геймификация спортивных достижений",
      "Приложение для йоги",
      "Подбор команд для спорта",
      "Приложение для отслеживания сна и восстановления",
      "Генератор планов тренировок под цели"
    ],
    "Путешествия": [
      "Путеводитель с ИИ-советами",
      "Приложение для планирования маршрута",
      "Онлайн-бронирование отелей",
      "Приложение для обмена впечатлениями",
      "Генератор интересных маршрутов",
      "AR-гиды по городам",
      "Социальная сеть путешественников",
      "Приложение с локальными рекомендациями",
      "Сервис поиска попутчиков",
      "Приложение для создания фотокниг из поездок"
    ],
    "Развлечения": [
      "Генератор идей для игр",
      "Приложение для создания мемов",
      "Киноподборка по настроению",
      "Онлайн-викторины",
      "Музыкальные челленджи",
      "Соревнования по мини-играм",
      "Приложение для караоке",
      "Генератор сценариев для видео",
      "Виртуальная комната настольных игр",
      "Приложение для интерактивных квизов с друзьями"
    ],
    "ИИ": [
      "ИИ-конструктор идей для стартапов",
      "Генератор персонажей с уникальными биографиями",
      "Приложение для обучения работе с нейросетями",
      "ИИ-редактор музыки и голоса",
      "Помощник по креативному письму на основе ChatGPT",
      "ИИ для анализа эмоционального состояния пользователя",
      "Автоматическое резюме и портфолио от ИИ",
      "ИИ-дизайнер логотипов и фирменного стиля",
      "ИИ-генератор инфографики",
      "Приложение для автоматической генерации контента в соцсетях"
    ],
    "Экология": [
      "Приложение для отслеживания углеродного следа",
      "Генератор идей по переработке мусора",
      "Карта пунктов приёма отходов",
      "Социальная сеть эко-волонтёров",
      "Сервис по обмену ненужными вещами",
      "Игра по воспитанию экологических привычек",
      "Приложение для выращивания растений дома",
      "ИИ-помощник по устойчивому образу жизни",
      "Приложение для планирования экологичных покупок",
      "Сервис отслеживания загрязнения воздуха в городах"
    ],
    "Здоровье": [
      "Дневник настроения с ИИ-анализом",
      "Медитации под настроение",
      "Приложение для дыхательных практик",
      "Трекер привычек с наградами",
      "ИИ-коуч для самодисциплины",
      "Музыка для концентрации с адаптацией к пользователю",
      "Визуализатор целей и эмоций",
      "Приложение для детокс-дней без гаджетов",
      "Приложение для отслеживания водного баланса",
      "Сервис рекомендаций по питанию и активности"
    ],
    "Социум": [
      "Платформа для помощи нуждающимся",
      "Сервис для поиска волонтёров",
      "Приложение для донорства и благотворительности",
      "Социальная сеть добрых дел",
      "ИИ-помощник для НКО",
      "Генератор идей для социальных стартапов",
      "Карта мест, где можно помочь",
      "Приложение для организации локальных мероприятий",
      "Сервис для создания локальных сообществ",
      "Приложение для проведения онлайн-акций добра"
    ],
    "Финансы": [
      "ИИ-помощник по личным финансам",
      "Геймификация накоплений",
      "Приложение для учёта подписок",
      "ИИ-анализатор расходов",
      "Планировщик дел с голосовым вводом",
      "Калькулятор целей и мечт",
      "Трекер микропривычек",
      "Приложение для учёта времени в стиле Pomodoro",
      "Сервис анализа бюджета с визуализацией",
      "Приложение для совместного планирования финансов семьи"
    ],
    "Бизнес": [
      "Генератор идей для малого бизнеса",
      "ИИ-конструктор стартап-питчей",
      "Сеть профессиональных знакомств",
      "Платформа для обмена навыками",
      "Симулятор переговоров",
      "ИИ-помощник для фрилансеров",
      "Трекер карьерных целей",
      "Курс по развитию личного бренда",
      "Приложение для анализа конкурентов",
      "Сервис автоматизированного планирования проектов"
    ]
  };
  Map<String, List<String>> shuffledIdeas = {};
  Map<String, int> currentIndex = {};
  String? currentIdea;
  bool isGenerating = false;
  String selectedCategory = "Категории";
  bool isDropdownOpen = false;

  // Анимации
  late final AnimationController _ideaController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;
  late final AnimationController _waveController;
  late final Animation<double> _waveAnimation;
  late final AnimationController _starController;

  bool _isCopied = false;
  final player = AudioPlayer();

  // ====================
  // Инициализация
  // ====================
  @override
  void initState() {
    super.initState();

    ideasByCategory.forEach((category, ideas) {
      shuffledIdeas[category] = List.from(ideas)..shuffle();
      currentIndex[category] = 0;
    });

    _ideaController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ideaController, curve: Curves.easeOut));

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

  // ====================
  // Генерация идеи
  // ====================
 void generateIdea() {
  try {
    player.play(AssetSource(
        'sounds/cartoon-game-damage-alert-ni-sound-1-00-03.mp3'));
  } catch (e) {}

  setState(() {
    isGenerating = true;
    currentIdea = null;
  });

  Future.delayed(const Duration(milliseconds: 2000), () {
    final selectedCategoryForIdea = selectedCategory == "Категории"
        ? (ideasByCategory.keys.toList()..shuffle()).first
        : selectedCategory;

    final index = currentIndex[selectedCategoryForIdea]!;
    final idea = shuffledIdeas[selectedCategoryForIdea]![index];

    currentIndex[selectedCategoryForIdea] =
        (index + 1) % shuffledIdeas[selectedCategoryForIdea]!.length;

    if (currentIndex[selectedCategoryForIdea] == 0) {
      shuffledIdeas[selectedCategoryForIdea] =
          List.from(ideasByCategory[selectedCategoryForIdea]!)..shuffle();
    }

    setState(() {
      currentIdea = idea;
      isGenerating = false;
    });

    _ideaController.forward(from: 0);

    widget.addToHistory(currentIdea!);
  });
}

  // ====================
  // Избранное
  // ====================
  void toggleFavoriteCurrentIdea() {
    if (currentIdea == null) return;

    widget.toggleFavoriteCallback(currentIdea!);

    if (!widget.currentFavorites.contains(currentIdea)) {
      _waveController.forward(from: 0);
    }

    _starController.forward(from: 0);
  }

  // ====================
  // Overlay уведомление "скопировано"
  // ====================
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF9E7),
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

    Widget buildCategoryDropdown() {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? Color(0xFF014F5B) : const Color.fromARGB(255, 241, 235, 200);
    final textColor = isDark ? Colors.tealAccent.shade100 : Colors.indigo[900];

    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
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
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: textColor,
                  ),
                ],
              ),
            ),
          ),
          
          ClipRect(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              constraints: BoxConstraints(
              maxHeight: isDropdownOpen ? 32 * 6.0 : 0, 
             ),
              child: SingleChildScrollView(
                child: Column(
                  children: ideasByCategory.keys.toList().asMap().entries.map((entry) {
                  final idx = entry.key;
                  final cat = entry.value;

                  return TweenAnimationBuilder<Offset>(
                    tween: Tween<Offset>(
                      begin: const Offset(0, -0.5),
                      end: Offset.zero,
                    ),
                    duration: const Duration(milliseconds: 300),
                    curve: Interval(
                      idx * 0.05,
                      1.0,
                      curve: Curves.easeOut,
                    ),
                    builder: (context, offset, child) {
                      return Transform.translate(
                        offset: Offset(0, offset.dy * 36),
                        child: child,
                      );
                    },
                    child: AnimatedOpacity(
                      opacity: isDropdownOpen ? 1 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () => setState(() {
                          selectedCategory = cat;
                          isDropdownOpen = false;
                        }),
                        child: Container(
                          height: 32,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            cat,
                            style: GoogleFonts.robotoMono(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),

                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  // ====================
  // Основной билд
  // ====================
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    Widget buildInitialText() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 22),
        decoration: BoxDecoration(
          color: isDark ? const Color.fromARGB(255, 3, 78, 66) : Colors.yellow.shade100,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: AnimatedRainbowText(
          text: "Нажмите снизу, чтобы начать!",
          style: GoogleFonts.robotoMono(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          themeMode: widget.themeMode,
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isGenerating)
              AnimatedTextKit(
                key: ValueKey(isGenerating),
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Генерация идеи...',
                    textStyle: GoogleFonts.robotoMono(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: widget.themeMode == ThemeMode.light
                          ? Colors.deepOrange.shade600
                          : Colors.tealAccent.shade200,
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
          // Текст идеи
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
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: widget.themeMode == ThemeMode.light
                      ? const Color.fromARGB(255, 43, 53, 158)
                      : Colors.cyanAccent.shade200,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Звезда с анимацией волны
          Stack(
            alignment: Alignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                  maxWidth: 40,
                  maxHeight: 40,
                ),
                child: AnimatedBuilder(
                  animation: _waveController,
                  builder: (context, child) {
                    final waveValue = _waveAnimation.value;
                    return Center(
                      child: Container(
                        width: 30 + waveValue,  
                        height: 30 + waveValue,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.currentFavorites.contains(currentIdea)
                              ? Colors.redAccent.withOpacity(
                                  (1 - waveValue / 20).clamp(0.0, 0.25))
                              : Colors.transparent,
                        ),
                      ),
                    );
                  },
                ),
              ),
              ScaleTransition(
                scale: _starController,
                child: GestureDetector(
                  onTap: toggleFavoriteCurrentIdea,
                  child: Icon(
                    widget.currentFavorites.contains(currentIdea)
                        ? Icons.star
                        : Icons.star_border,
                    color: widget.themeMode == ThemeMode.light
                        ? Colors.redAccent
                        : (widget.currentFavorites.contains(currentIdea)
                            ? Colors.amber
                            : Colors.grey[400]),
                            size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
            else
              buildInitialText(),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: isGenerating ? null : generateIdea,
              icon: Icon(
                Icons.auto_awesome,
                color: isDark ? Colors.tealAccent : Colors.indigo[900],
                size: 28,
              ),
              label: Text(
                "Сгенерировать",
                style: GoogleFonts.robotoMono(
                  color: isDark ? Colors.tealAccent : Colors.indigo[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark
                    ? const Color(0xFF00695C)
                    : const Color.fromARGB(255, 240, 235, 220),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                shadowColor: isDark
                    ? Colors.tealAccent.withOpacity(0.35)
                    : Colors.amberAccent.withOpacity(0.6),
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