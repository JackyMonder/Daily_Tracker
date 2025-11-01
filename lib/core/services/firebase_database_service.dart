import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

/// Service quản lý Firebase Realtime Database
/// Database URL: asia-southeast1 (gần Việt Nam)
class FirebaseDatabaseService {
  static const String _databaseURL = 
      'https://daily-tracker-55976-default-rtdb.asia-southeast1.firebasedatabase.app';
  
  static FirebaseDatabase? _instance;
  
  /// Lấy instance của Firebase Database với URL đúng region
  static FirebaseDatabase get instance {
    if (_instance == null) {
      _instance = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: _databaseURL,
      );
    }
    return _instance!;
  }
  
  /// Tạo reference đến một path trong database
  static DatabaseReference ref(String path) {
    return instance.ref(path);
  }
  
  /// Reset instance (dùng cho testing)
  static void reset() {
    _instance = null;
  }
}

