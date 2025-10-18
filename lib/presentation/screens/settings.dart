import 'package:flutter/material.dart';

/// Settings Screen - Màn hình cài đặt với các tùy chọn Contact, How to Use, Privacy
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  
  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 24,
          ),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Settings menu items
            _buildMenuItem(
              icon: Icons.mail_outline,
              title: 'Contact',
              onTap: () {
                // Handle Contact tap
                _showComingSoon(context, 'Contact');
              },
            ),
            const Divider(
              height: 1,
              thickness: 0.5,
              color: Color(0xFFE0E0E0),
            ),
            _buildMenuItem(
              icon: Icons.help_outline,
              title: 'How to Use',
              onTap: () {
                // Handle How to Use tap
                _showComingSoon(context, 'How to Use');
              },
            ),
            const Divider(
              height: 1,
              thickness: 0.5,
              color: Color(0xFFE0E0E0),
            ),
            _buildMenuItem(
              icon: Icons.verified_user_outlined,
              title: 'Privacy',
              onTap: () {
                // Handle Privacy tap
                _showComingSoon(context, 'Privacy');
              },
            ),
            const Divider(
              height: 1,
              thickness: 0.5,
              color: Color(0xFFE0E0E0),
            ),
            _buildMenuItem(
              icon: Icons.logout,
              title: 'Logout',
              onTap: () {
                Navigator.of(context).pushNamed('/auth-intro');
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Xây dựng từng menu item với icon, title và arrow
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              // Icon
              Icon(
                icon,
                color: Colors.black,
                size: 24,
              ),
              const SizedBox(width: 16),
              
              // Title
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              
              // Arrow
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Hiển thị thông báo "Coming Soon" cho các tính năng chưa implement
  void _showComingSoon(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coming Soon'),
        content: Text('$feature feature will be available soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
