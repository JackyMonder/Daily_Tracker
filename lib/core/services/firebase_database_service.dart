import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

/// Service quản lý Firebase Realtime Database
/// Database URL: tự động lấy từ Firebase app hoặc dùng URL mặc định
class FirebaseDatabaseService {
  // URL mặc định - sẽ được override nếu có trong Firebase config
  static const String? _defaultDatabaseURL = null; // Sẽ dùng default từ Firebase app
  
  // Hoặc nếu cần chỉ định cụ thể, dùng URL này:
  // static const String _databaseURL = 
  //     'https://daily-tracker-fc325-default-rtdb.firebaseio.com/';
  
  static FirebaseDatabase? _instance;
  
  /// Lấy instance của Firebase Database với URL đúng region
  /// Nếu không chỉ định URL, sẽ dùng default database URL từ Firebase app
  static FirebaseDatabase get instance {
    if (_instance == null) {
      if (_defaultDatabaseURL != null) {
        _instance = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL: _defaultDatabaseURL!,
        );
      } else {
        // Dùng default database URL từ Firebase app
        _instance = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL: 'https://daily-tracker-fc325-default-rtdb.firebaseio.com/',
        );
      }
      print('Firebase Database initialized with URL: ${_instance!.databaseURL ?? "default"}');
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

