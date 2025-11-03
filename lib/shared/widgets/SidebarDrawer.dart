import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:daily_tracker/core/routes/routes.dart';
import 'package:daily_tracker/data/repositories/note_repository.dart';
import 'package:daily_tracker/data/repositories/user_repository.dart';
import 'package:daily_tracker/data/models/user_model.dart';

/// Sidebar drawer widget theo thiết kế Figma
/// Hiển thị thông tin stats, upgrade options và các tính năng Pro
class SidebarDrawer extends StatelessWidget {
  const SidebarDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userId = currentUser?.uid;

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
                
                // User info section
                if (userId != null) _buildUserSection(context, userId),
                if (userId != null) const SizedBox(height: 30),
                
                // Stats section
                if (userId != null) _buildStatsSection(context, userId),

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

  /// Xây dựng phần user info với avatar, tên và email
  Widget _buildUserSection(BuildContext context, String userId) {
    final userRepository = UserRepository();
    
    return FutureBuilder<UserModel?>(
      future: userRepository.getUserProfile(userId),
      builder: (context, snapshot) {
        final firebaseUser = FirebaseAuth.instance.currentUser;

        // Name
        final String userName = snapshot.data?.name ?? (firebaseUser?.displayName ?? 'Guest User');

        // Email
        final String rawEmail = snapshot.data?.email ?? (firebaseUser?.email ?? '');
        final String userEmail = rawEmail.trim().isEmpty ? '<None Identified>' : rawEmail.trim();

        // Avatar
        final String? avatarUrlStr = snapshot.data?.avatarUrl ?? firebaseUser?.photoURL;
        final bool hasAvatar = (avatarUrlStr != null && avatarUrlStr.trim().isNotEmpty);

        return Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFFC8B9F4),
              backgroundImage: hasAvatar ? NetworkImage(avatarUrlStr) : null,
              child: !hasAvatar
                  ? Text(
                      userName[0].toUpperCase(),
                      style: const TextStyle(
                        // color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            // User info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userEmail,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  /// Xây dựng phần stats với các số liệu
  Widget _buildStatsSection(BuildContext context, String userId) {
    final noteRepository = NoteRepository();

    return StreamBuilder<int>(
      stream: noteRepository.watchNotes(userId: userId).map((notes) => notes.length),
      builder: (context, notesSnapshot) {
        final noteCount = notesSnapshot.hasData ? (notesSnapshot.data ?? 0) : 0;

        return StreamBuilder<int>(
          stream: noteRepository.watchDeletedNotesCount(userId: userId),
          builder: (context, deletedSnapshot) {
            final deletedCount = deletedSnapshot.hasData ? (deletedSnapshot.data ?? 0) : 0;

            return Column(
              children: [
                _buildStatItem(
                  icon: Icons.note_alt,
                  iconColor: const Color(0xFFF09AA2),
                  title: 'Note List',
                  value: noteCount.toString(),
                ),
                const SizedBox(height: 16),
                _buildStatItem(
                  icon: Icons.checklist,
                  iconColor: const Color(0xFF4CAF50),
                  title: 'Note Created',
                  value: noteCount.toString(),
                ),
                const SizedBox(height: 16),
                _buildTrashBinItem(deletedCount),
              ],
            );
          },
        );
      },
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
  Widget _buildTrashBinItem(int deletedCount) {
    return _buildStatItem(
      icon: Icons.delete_outline,
      iconColor: const Color(0xFF6BB6DF),
      title: 'Trash Bin',
      value: deletedCount.toString(),
    );
  }
}
