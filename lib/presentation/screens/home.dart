// Presentation home exports
import 'package:daily_tracker/shared/widgets/HorizontalWeekView.dart';
import 'package:flutter/material.dart';
import 'package:daily_tracker/core/services/firebase_database_service.dart';
import 'package:daily_tracker/shared/widgets/index.dart';
import 'package:daily_tracker/shared/widgets/SidebarDrawer.dart';
import 'package:daily_tracker/data/repositories/note_repository.dart';
import 'package:daily_tracker/presentation/screens/note_editor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();
  final NoteRepository _noteRepository = NoteRepository();
  
  // Dates có notes - sẽ được load từ Firebase
  List<DateTime> _notesDates = [];
  bool _isLoadingDates = true;

  @override
  void initState() {
    super.initState();
    _loadNotesDates();
  }

  /// Load danh sách các ngày có notes từ Firebase
  Future<void> _loadNotesDates() async {
    setState(() {
      _isLoadingDates = true;
    });

    try {
      // Lấy userId từ Firebase Auth (nếu có)
      final userId = FirebaseAuth.instance.currentUser?.uid;
      
      // Thêm timeout để tránh block UI quá lâu
      final dates = await _noteRepository.getNotesDates(userId: userId).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          print('⚠ Timeout loading notes dates - returning empty list');
          return <DateTime>[];
        },
      );
      
      if (mounted) {
        setState(() {
          _notesDates = dates;
          _isLoadingDates = false;
        });
      }
    } catch (e) {
      print('Error loading notes dates: $e');
      if (mounted) {
        setState(() {
          _notesDates = [];
          _isLoadingDates = false;
        });
      }
    }
  }

  /// Refresh notes dates (gọi khi có thay đổi notes)
  Future<void> refreshNotes() async {
    await _loadNotesDates();
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  /// Xử lý khi tạo note mới
  Future<void> _handleNewNote() async {
    // Hiển thị date picker để chọn ngày ghi note
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Chọn ngày ghi note',
      cancelText: 'Hủy',
      confirmText: 'Chọn',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF6BB6DF),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    // Nếu người dùng hủy, không làm gì
    if (pickedDate == null) return;

    // Chuẩn hóa ngày về 00:00:00 để đảm bảo filter chính xác
    final normalizedDate = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
    );

    // Chuyển sang màn hình tạo note với ngày đã chọn
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NoteEditorScreen(
          selectedDate: normalizedDate,
        ),
      ),
    );

    // Nếu note được tạo/cập nhật thành công, refresh dates
    if (result == true && mounted) {
      await _loadNotesDates();
    }
  }

  // Hàm test kết nối Firebase
  Future<void> _testFirebaseConnection() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    try {
      // Hiển thị loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Kiểm tra Firebase đã được khởi tạo
      final firebaseApp = Firebase.app();

      // Test kết nối Realtime Database với URL đúng region
      final ref = FirebaseDatabaseService.ref('test/connection_test');
      
      // Thử ghi dữ liệu test
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      await ref.set({
        'timestamp': timestamp,
        'message': 'Test kết nối Firebase thành công',
        'device': 'Flutter App',
        'createdAt': timestamp,
      });

      // Đợi một chút để đảm bảo dữ liệu được ghi
      await Future.delayed(const Duration(milliseconds: 500));

      // Thử đọc dữ liệu vừa ghi
      final snapshot = await ref.get();
      
      // Đóng loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Hiển thị kết quả thành công
      if (context.mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '✅ Kết nối Firebase thành công!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Project ID: ${firebaseApp.options.projectId}',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
                Text(
                  'Data: ${snapshot.exists ? snapshot.value : 'No data'}',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      // Đóng loading dialog nếu có lỗi
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Hiển thị lỗi
      if (context.mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '❌ Lỗi kết nối Firebase!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Chi tiết: $e',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const SidebarDrawer(), // Thêm drawer vào Scaffold
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 75,
        leadingWidth: 100,
        backgroundColor: Colors.white, // Keep AppBar stable color when scrolling
        leading: Padding (
          padding: const EdgeInsets.only(left: 20.0, top: 20), 
          child: Row (
            children: [
              CommonWidgets().menuIconButton,
            ],
          )
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 20),
            child: Row(
              children: [
                CommonWidgets().mailIconButton,
                SizedBox(width: 10),
                CommonWidgets().settingIconButton,
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: _isLoadingDates
                  ? const Center(child: CircularProgressIndicator())
                  : HorizontalWeekView(
                      selectedDate: _selectedDate,
                      onDateSelected: _onDateSelected,
                      notesDates: _notesDates,
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleNewNote,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: CommonWidgets().newNote,
      ),
    );
  }
}