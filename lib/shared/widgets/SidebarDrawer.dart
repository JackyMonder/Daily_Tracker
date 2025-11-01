import 'package:flutter/material.dart';
import 'package:daily_tracker/core/routes/routes.dart';

/// Sidebar drawer widget theo thiết kế Figma
/// Hiển thị thông tin stats, upgrade options và các tính năng Pro
class SidebarDrawer extends StatelessWidget {
  const SidebarDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 320, // Chiều rộng drawer theo thiết kế
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header với title "Note Taker" và settings icon
                _buildHeader(context),
                const SizedBox(height: 30),
                
                // Stats section
                _buildStatsSection(context),

                const Spacer(),

              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Xây dựng header với title gradient và settings icon
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Title "Note Taker" với gradient
        Row(
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFFF09AA2), Color(0xFF6BB6DF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds),
              child: const Text(
                'Note Taker',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        
        // Settings icon với background tím
        GestureDetector(
          onTap: () {
            Navigator.pop(context); // Đóng drawer trước
            Navigator.pushNamed(context, Routes.settings); // Navigate đến Settings
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFC8B9F4),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  /// Xây dựng phần stats với các số liệu
  Widget _buildStatsSection(BuildContext context) {
    return Column(
      children: [
        _buildStatItem(
          icon: Icons.note_alt,
          iconColor: const Color(0xFFF09AA2),
          title: 'Note List',
          value: '1',
        ),
        const SizedBox(height: 16),
        _buildStatItem(
          icon: Icons.checklist,
          iconColor: const Color(0xFF4CAF50),
          title: 'Note Created',
          value: '1',
        ),
        const SizedBox(height: 16),
        _buildTrashBinItem(),
      ],
    );
  }

  /// Widget cho từng stat item
  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
      ],
    );
  }

  /// Widget cho Trash Bin với số note bị xóa
  Widget _buildTrashBinItem() {
    return _buildStatItem(
      icon: Icons.delete_outline,
      iconColor: const Color(0xFF6BB6DF),
      title: 'Trash Bin',
      value: '0',
    );
  }
}
