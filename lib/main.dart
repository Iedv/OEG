import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Listening App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Apple-style color palette: White/Beige driven
        scaffoldBackgroundColor: const Color(0xFFFDFCF8), // Warm white background
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFCF6E3), // Beige seed
          primary: const Color(0xFF333333), // Soft black
          surface: Colors.white,
          background: const Color(0xFFFDFCF8),
          outline: const Color(0xFFE0E0E0),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFF333333),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(color: Color(0xFF333333)),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF333333),
          unselectedItemColor: Color(0xFFAAAAAA),
          elevation: 8,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();

  static _MainPageState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MainPageState>();
  }
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void switchToTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // List of pages corresponding to each tab
  final List<Widget> _pages = const [
    ListeningPage(),
    FavoritesPage(),
    ExplorePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.headphones_outlined),
              activeIcon: Icon(Icons.headphones),
              label: '听力',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border),
              activeIcon: Icon(Icons.bookmark),
              label: '收藏',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: '探索',
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Listening Page & Sub-pages
// ---------------------------------------------------------------------------

class ListeningPage extends StatelessWidget {
  const ListeningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('听力'),
      ),
      body: ListView(
        children: [
          _buildListItem(context, 'test', true),
          _buildListItem(context, 'test2', false),
          _buildAddButton(context),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, String title, bool isTest1) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      clipBehavior: Clip.hardEdge, // Ensure ripple effect respects border radius
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (isTest1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ListeningPracticePage()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Clicked $title')),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF333333)),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFBBBBBB)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE), style: BorderStyle.solid),
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showAddMenu(context),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Icon(Icons.add, color: Color(0xFF888888), size: 28),
            ),
          ),
        ),
      ),
    );
  }

  void _showAddMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '添加内容',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                ),
                const SizedBox(height: 24),
                _buildModalOption(ctx, Icons.file_upload_outlined, '本地导入', () {}),
                _buildModalOption(ctx, Icons.auto_awesome_outlined, '文本生成 (AI)', () {}),
                _buildModalOption(ctx, Icons.link, '网站链接导入', () {}),
                _buildModalOption(ctx, Icons.explore_outlined, '探索资源', () {
                  Navigator.pop(ctx);
                  // Switch to Explore Tab (Index 2)
                  MainPage.of(context)?.switchToTab(2);
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModalOption(BuildContext context, IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.black87),
      ),
      title: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }
}

class ListeningPracticePage extends StatefulWidget {
  const ListeningPracticePage({super.key});

  @override
  State<ListeningPracticePage> createState() => _ListeningPracticePageState();
}

class _ListeningPracticePageState extends State<ListeningPracticePage> {
  final String fullText = 
      "Sometimes, the best moments in life are quiet and simple. Imagine a sunny morning. You are drinking warm tea and listening to birds sing outside your window. The air feels fresh. You take a slow, deep breath and feel calm. Or think about walking in a park. You see green trees, colorful flowers, and children playing happily. You smile at a stranger, and they smile back. These small things do not cost money, but they make life beautiful. We often look for big happiness. We forget that joy is all around us—in a good book, a friend's laugh, or a quiet moment alone. Today, try to notice one small thing that makes you happy. You might be surprised how much light it brings to your day.";

  late List<String> sentences;

  @override
  void initState() {
    super.initState();
    // Split text but keep structure simple for now.
    // Enhanced splitting to avoid cutting off inside words
    sentences = fullText.split(RegExp(r'(?<=[.!?])\s+'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('听力练习 test'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: sentences.map((sentence) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: SentenceWidget(text: sentence),
                  );
                }).toList(),
              ),
            ),
          ),
          const AudioPlayerWidget(),
        ],
      ),
    );
  }
}

class SentenceWidget extends StatefulWidget {
  final String text;

  const SentenceWidget({super.key, required this.text});

  @override
  State<SentenceWidget> createState() => _SentenceWidgetState();
}

class _SentenceWidgetState extends State<SentenceWidget> {
  late List<String> tokens;
  late List<bool> tokenStates; // true = revealed, false = masked. Punctuation always true.

  @override
  void initState() {
    super.initState();
    _parseTokens();
  }

  void _parseTokens() {
    // Regex to split by either words or punctuation sequences
    // Matches: [word characters] OR [non-word characters excluding space]
    final RegExp regex = RegExp(r"(\w+|[^\w\s]+)");
    final matches = regex.allMatches(widget.text);
    
    tokens = matches.map((m) => m.group(0)!).toList();
    
    // Initialize states: punctuation is always revealed (state irrelevant but effectively true), words are masked (false)
    tokenStates = tokens.map((t) => _isPunctuation(t)).toList();
  }

  bool _isPunctuation(String token) {
    return !RegExp(r'\w').hasMatch(token);
  }

  void _toggleAllVisibility() {
    // Check if any word is revealed
    bool hasRevealedWord = false;
    for (int i = 0; i < tokens.length; i++) {
      if (!_isPunctuation(tokens[i]) && tokenStates[i]) {
        hasRevealedWord = true;
        break;
      }
    }

    setState(() {
      for (int i = 0; i < tokenStates.length; i++) {
        if (!_isPunctuation(tokens[i])) {
          // If any word is revealed, mask all. Else reveal all.
          tokenStates[i] = !hasRevealedWord;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Control Buttons Column
        Padding(
          padding: const EdgeInsets.only(right: 12.0, top: 4.0),
          child: Column(
            children: [
              _buildControlButton(Icons.visibility_outlined, _toggleAllVisibility),
              const SizedBox(height: 12),
              _buildControlButton(Icons.volume_up_outlined, () {}),
            ],
          ),
        ),
        // Sentence Content
        Expanded(
          child: Wrap(
            spacing: 4,
            runSpacing: 10,
            children: List.generate(tokens.length, (index) {
              return _buildTokenWidget(index);
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onTap) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Icon(icon, size: 16, color: Colors.grey[700]),
        ),
      ),
    );
  }

  Widget _buildTokenWidget(int index) {
    final token = tokens[index];
    final isPunc = _isPunctuation(token);
    final isRevealed = tokenStates[index];

    if (isPunc) {
      // Punctuation should also match the height and alignment of tokens for consistency,
      // though typically they render fine as plain text. 
      // Adding padding to match token wrapper
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(
          token,
          style: const TextStyle(fontSize: 18, color: Colors.black87, height: 1.5),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (!isRevealed) {
          setState(() {
            tokenStates[index] = true;
          });
        } else {
          // Show popup menu
          _showWordMenu(context, token);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), // Constant padding
        margin: const EdgeInsets.only(top: 2),
        decoration: BoxDecoration(
          color: isRevealed ? Colors.transparent : const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          token,
          style: TextStyle(
            color: isRevealed ? Colors.black87 : Colors.transparent,
            fontSize: 18,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  void _showWordMenu(BuildContext context, String word) {
    // We can use a PopupMenuButton logic programmatically or a simple dialog/bottom sheet
    // For a small popup next to the word, RenderBox calculation is needed for OverlayEntry.
    // For simplicity and standard mobile UX, we'll use showMenu which positions based on tap box if possible,
    // or just a small dialog. showMenu requires a position.
    // Let's use a ModalBottomSheet or Dialog for simpler implementation without RenderBox boilerplate,
    // OR just standard PopupMenu logic on the widget itself.
    // Updated requirement: "generate a widget, has 3 options".
    
    // To keep it simple but functional:
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx, 
        offset.dy + 50, // rough estimate, hard to perfect without specific tap details
        offset.dx + 100, 
        offset.dy
      ),
      elevation: 8,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: [
        PopupMenuItem(
          height: 32,
          child: Row(
            children: const [Text('👂'), SizedBox(width: 8), Text('再听一遍', style: TextStyle(fontSize: 14))],
          ),
        ),
        PopupMenuItem(
           height: 32,
          child: Row(
            children: const [Text('⭐'), SizedBox(width: 8), Text('收藏单词', style: TextStyle(fontSize: 14))],
          ),
        ),
        PopupMenuItem(
           height: 32,
          child: Row(
            children: const [Text('📖'), SizedBox(width: 8), Text('详细解释', style: TextStyle(fontSize: 14))],
          ),
        ),
      ],
    );
  }
}


class AudioPlayerWidget extends StatelessWidget {
  const AudioPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Slider Row
          Row(
            children: [
              Text('01:10', style: TextStyle(color: Colors.grey[400], fontSize: 12, fontWeight: FontWeight.w500)),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFFC2B280), // Dark Beige
                    inactiveTrackColor: const Color(0xFFFCF6E3), // Light Beige  FFC2B280   FFF5F5DC  FFF7EED3   FFFCF6E3
                    thumbColor: const Color(0xFFC2B280), // Dark Beige
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                    trackShape: const RoundedRectSliderTrackShape(),
                  ),
                  child: Slider(
                    value: 0.3, 
                    onChanged: (v) {},
                  ),
                ),
              ),
              Text('03:45', style: TextStyle(color: Colors.grey[400], fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 16),
          // Controls Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Speed
              Container(
                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                 decoration: BoxDecoration(
                   color: const Color(0xFFF9F9F9),
                   borderRadius: BorderRadius.circular(20),
                   border: Border.all(color: const Color(0xFFEEEEEE)),
                 ),
                 child: const Text('1.0x', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF000000))), // SaddleBrown text
              ),
              
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.replay_10_rounded),
                    iconSize: 28,
                    color: const Color(0xFFC2B280),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 20),
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFCF6E3), // Beige bg
                      boxShadow: [
                         BoxShadow(
                          color: const Color(0xFFC2B280).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.play_arrow_rounded, color: Color(0xFFC2B280), size: 38), // SaddleBrown icon
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.forward_10_rounded),
                    iconSize: 28,
                    color: const Color(0xFFC2B280),
                    onPressed: () {},
                  ),
                ],
              ),
              
              // Balance spacing
              const SizedBox(width: 45), 
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Other Placeholder Pages
// ---------------------------------------------------------------------------

enum SortOption { timeAsc, timeDesc, alphaAsc, alphaDesc }

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final List<String> _originalItems = [
    'cohesive',
    'precedent',
    'Bird of a feather flock together.',
    'come up with',
    'OEG'
  ];

  SortOption _currentSort = SortOption.timeAsc;
  final TextEditingController _searchController = TextEditingController();

  List<String> _getSortedItems() {
    List<String> items = List.from(_originalItems);
    
    // Simple filter if search text exists (optional based on prompt but good UX)
    if (_searchController.text.isNotEmpty) {
      items = items.where((item) => 
        item.toLowerCase().contains(_searchController.text.toLowerCase())
      ).toList();
    }

    switch (_currentSort) {
      case SortOption.timeAsc:
        // Default order
        break;
      case SortOption.timeDesc:
        items = items.reversed.toList();
        break;
      case SortOption.alphaAsc:
        items.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
        break;
      case SortOption.alphaDesc:
        items.sort((a, b) => b.toLowerCase().compareTo(a.toLowerCase()));
        break;
    }
    return items;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayItems = _getSortedItems();

    return Scaffold(
      appBar: AppBar(
        title: const Text('收藏'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Toolbar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                // Sort Button
                PopupMenuButton<SortOption>(
                  icon: const Icon(Icons.sort_rounded, color: Color(0xFF333333)),
                  onSelected: (SortOption result) {
                    setState(() {
                      _currentSort = result;
                    });
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOption>>[
                    const PopupMenuItem<SortOption>(
                      value: SortOption.timeAsc,
                      child: Text('添加时间 (最早-最新)'),
                    ),
                    const PopupMenuItem<SortOption>(
                      value: SortOption.timeDesc,
                      child: Text('添加时间 (最新-最早)'),
                    ),
                    const PopupMenuItem<SortOption>(
                      value: SortOption.alphaAsc,
                      child: Text('名称 (A-Z)'),
                    ),
                    const PopupMenuItem<SortOption>(
                      value: SortOption.alphaDesc,
                      child: Text('名称 (Z-A)'),
                    ),
                  ],
                ),
                // Filter Button (Placeholder)
                IconButton(
                  icon: const Icon(Icons.filter_list_rounded, color: Color(0xFF333333)),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('筛选功能开发中')),
                    );
                  },
                ),
                const SizedBox(width: 8),
                // Search Bar
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(() {}),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: const InputDecoration(
                        hintText: '搜索',
                        hintStyle: TextStyle(color: Color(0xFF999999)),
                        prefixIcon: Icon(Icons.search, color: Color(0xFF999999), size: 20),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        isCollapsed: true,
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // List
          Expanded(
            child: ListView.separated(
              itemCount: displayItems.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
              itemBuilder: (context, index) {
                final item = displayItems[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  title: Text(
                    item,
                    style: const TextStyle(fontSize: 16, color: Color(0xFF333333)),
                  ),
                  onTap: () => _showDetailDialog(context, item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailDialog(BuildContext context, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(24),
            constraints: const BoxConstraints(minHeight: 150),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333)
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Blank placeholder widget
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFEEEEEE)),
                  ),
                  child: const Center(
                    child: Text(
                      '详细信息',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('探索'),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.explore_outlined, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text(
              '发现更多',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}