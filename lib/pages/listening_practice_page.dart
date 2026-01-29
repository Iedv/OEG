import 'package:flutter/material.dart';

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
        title: const Text('听力练习'),
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
                    inactiveTrackColor: const Color(0xFFFCF6E3), // Light Beige
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
                 child: const Text('1.0x', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF000000))), 
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
                    child: const Icon(Icons.play_arrow_rounded, color: Color(0xFFC2B280), size: 38),
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