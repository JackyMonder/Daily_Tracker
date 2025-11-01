import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/home.dart';
import '../screens/auth_intro.dart';
import '../../core/services/auth_preferences_service.dart';

/// Widget wrapper để quản lý routing dựa trên auth state
/// 
/// Firebase Auth tự động persist session trên thiết bị, nhưng cần đợi
/// thời gian để restore session khi app khởi động lại
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _hasCheckedInitialAuth = false;
  final AuthPreferencesService _authPreferences = AuthPreferencesService();

  @override
  void initState() {
    super.initState();
    // Kiểm tra auth state ngay khi widget được khởi tạo
    _checkInitialAuth();
  }

  /// Kiểm tra auth state ban đầu - đợi Firebase restore session
  /// Nếu user đã logout, không tự động đăng nhập lại
  /// Lưu ý: Đối với anonymous user, không force signOut để giữ session và cho phép reuse
  Future<void> _checkInitialAuth() async {
    // Đợi một chút để Firebase Auth có thời gian restore session từ persistent storage
    // Firebase Auth tự động persist session trên thiết bị, nhưng cần thời gian để restore
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Kiểm tra xem user đã logout hay chưa
    final isLoggedOut = await _authPreferences.isUserLoggedOut();
    
    // Nếu user đã logout, force sign out để đảm bảo không có session nào
    // NHƯNG: Nếu là anonymous user, KHÔNG signOut để giữ session và cho phép reuse
    if (isLoggedOut) {
      final currentUser = FirebaseAuth.instance.currentUser;
      
      // Chỉ signOut nếu KHÔNG phải anonymous user
      // Anonymous user không có logout state nên sẽ không vào đây, nhưng để an toàn vẫn check
      if (currentUser == null || !currentUser.isAnonymous) {
        try {
          await FirebaseAuth.instance.signOut();
        } catch (e) {
          print('Error signing out: $e');
        }
      }
    }
    
    if (mounted) {
      setState(() {
        _hasCheckedInitialAuth = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Nếu chưa check initial auth, hiển thị loading
    if (!_hasCheckedInitialAuth) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return FutureBuilder<bool>(
      future: _authPreferences.isUserLoggedOut(),
      builder: (context, logoutSnapshot) {
        // Nếu đang kiểm tra logout state, hiển thị loading
        if (logoutSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Nếu user đã logout, luôn chuyển đến auth intro (không tự động đăng nhập)
        if (logoutSnapshot.hasData && logoutSnapshot.data == true) {
          return const AuthIntroScreen();
        }

        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
        // Xử lý lỗi trong stream
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD55C6A).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.error_outline_rounded,
                          size: 48,
                          color: const Color(0xFFD55C6A),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Lỗi xác thực',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          snapshot.error?.toString() ?? 
                          'Đã xảy ra lỗi không xác định khi kiểm tra trạng thái đăng nhập.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Reload app - quay lại auth intro
                          Navigator.of(context).pushReplacementNamed('/auth-intro');
                        },
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Thử lại'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6BB6DF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/auth-intro');
                        },
                        child: Text(
                          'Quay lại màn hình đăng nhập',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        // Kiểm tra currentUser trực tiếp để tránh vấn đề khi stream chưa emit
        final currentUser = FirebaseAuth.instance.currentUser;

        // Nếu đã đăng nhập (có user hoặc anonymous), chuyển đến home
        if (currentUser != null) {
          return const HomeScreen();
        }

        // Nếu stream có data và data không null, cũng check
        if (snapshot.hasData && snapshot.data != null) {
          return const HomeScreen();
        }

        // Đang kiểm tra auth state từ stream
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Nếu chưa đăng nhập, chuyển đến auth intro
        return const AuthIntroScreen();
          },
        );
      },
    );
  }
}

