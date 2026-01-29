import 'package:flutter/material.dart';

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
    
    // Simple filter if search text exists
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