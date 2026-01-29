import 'package:flutter/material.dart';
import 'listening_practice_page.dart';
import 'main_page.dart';

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
      clipBehavior: Clip.hardEdge, 
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