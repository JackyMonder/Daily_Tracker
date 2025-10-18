import 'package:flutter/material.dart';

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
                const SizedBox(height: 20),
                
                // Upgrade section
                _buildUpgradeSection(context),
                
                const Spacer(),
                
                // Bottom links
                _buildBottomLinks(context),
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
        Container(
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
        _buildTimeRemainingItem(),
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

  /// Widget cho Time Remaining với button Buy time
  Widget _buildTimeRemainingItem() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF6BB6DF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.access_time,
            color: Color(0xFF6BB6DF),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Time Remaining',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              Text(
                '9h 27s',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF09AA2), Color(0xFF6BB6DF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Text(
            'Buy time',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  /// Xây dựng phần upgrade với card Pro
  Widget _buildUpgradeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upgrade to Pro member to get unlimited notes plus other perks at discounted rate',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF666666),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),
        
        // Upgrade card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFF09AA2).withOpacity(0.3),
              width: 1,
            ),
            gradient: LinearGradient(
              colors: [
                Colors.white,
                const Color(0xFFF09AA2).withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFeatureItem(
                icon: Icons.all_inclusive,
                text: 'Unlimited lecture recordings, notes, and flashcards',
                iconColor: const Color(0xFFF09AA2),
              ),
              const SizedBox(height: 12),
              _buildFeatureItem(
                icon: Icons.play_circle,
                text: 'Summarize any Youtube video',
                iconColor: Colors.red,
              ),
              const SizedBox(height: 12),
              _buildFeatureItem(
                icon: Icons.language,
                text: '100+ languages supported',
                iconColor: const Color(0xFF4CAF50),
              ),
              const SizedBox(height: 12),
              _buildFeatureItem(
                icon: Icons.flash_on,
                text: 'Priority servers for faster speeds',
                iconColor: Colors.amber,
              ),
              const SizedBox(height: 12),
              _buildFeatureItem(
                icon: Icons.headset_mic,
                text: 'Priority support',
                iconColor: const Color(0xFF6BB6DF),
              ),
              const SizedBox(height: 20),
              
              // Upgrade button
              Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF09AA2), Color(0xFF6BB6DF)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () {
                      // Handle upgrade action
                      Navigator.pop(context);
                    },
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Upgrade',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Widget cho từng feature item trong upgrade card
  Widget _buildFeatureItem({
    required IconData icon,
    required String text,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 14,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF333333),
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  /// Xây dựng các link ở bottom
  Widget _buildBottomLinks(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Privacy Policy',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF666666),
            decoration: TextDecoration.underline,
          ),
        ),
        Text(
          'Term of Service',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF666666),
            decoration: TextDecoration.underline,
          ),
        ),
      ],
    );
  }
}
