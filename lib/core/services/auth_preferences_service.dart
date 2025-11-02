import 'package:shared_preferences/shared_preferences.dart';

/// Service quản lý auth preferences (logout state, etc.)
class AuthPreferencesService {
  static const String _keyUserLoggedOut = 'user_logged_out';
  static const String _keyAnonymousUserId = 'anonymous_user_id';

  /// Lưu trạng thái user đã logout
  /// 
  /// Khi user logout, lưu flag này để ngăn Firebase Auth tự động restore session
  Future<void> setUserLoggedOut(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyUserLoggedOut, value);
    } catch (e) {
      print('Error saving logout state: $e');
    }
  }

  /// Kiểm tra xem user đã logout hay chưa
  /// 
  /// Nếu true, nghĩa là user đã chủ động logout và không muốn tự động đăng nhập lại
  Future<bool> isUserLoggedOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyUserLoggedOut) ?? false;
    } catch (e) {
      print('Error reading logout state: $e');
      return false;
    }
  }

  /// Xóa logout state (khi user đăng nhập thành công)
  Future<void> clearLogoutState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyUserLoggedOut);
    } catch (e) {
      print('Error clearing logout state: $e');
    }
  }

  /// Lưu anonymous user ID để có thể reuse sau khi logout
  Future<void> saveAnonymousUserId(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyAnonymousUserId, userId);
    } catch (e) {
      print('Error saving anonymous user ID: $e');
    }
  }

  /// Lấy anonymous user ID đã lưu
  Future<String?> getAnonymousUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyAnonymousUserId);
    } catch (e) {
      print('Error reading anonymous user ID: $e');
      return null;
    }
  }

  /// Xóa anonymous user ID (khi user đăng nhập với account thực hoặc tạo anonymous mới)
  Future<void> clearAnonymousUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyAnonymousUserId);
    } catch (e) {
      print('Error clearing anonymous user ID: $e');
    }
  }
}

