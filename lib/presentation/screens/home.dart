// Presentation home exports
import 'package:daily_tracker/shared/widgets/HorizontalWeekView.dart';
import 'package:flutter/material.dart';
import 'package:daily_tracker/shared/widgets/index.dart';
import 'package:daily_tracker/shared/widgets/SidebarDrawer.dart';
import 'package:daily_tracker/data/repositories/note_repository.dart';
import 'package:daily_tracker/presentation/screens/note_editor.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();
  final NoteRepository _noteRepository = NoteRepository();

  List<DateTime> _notesDates = [];
  bool _isLoadingDates = true;

  Key _weekViewKey = UniqueKey();
  int _refreshCounter = 0;

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
      // Lấy userId từ Firebase Auth - BẮT BUỘC phải có (kể cả anonymous)
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (mounted) {
          setState(() {
            _notesDates = [];
            _isLoadingDates = false;
          });
        }
        return;
      }
      
      final userId = user.uid; // Luôn có uid, kể cả anonymous user
      final dates = await _noteRepository.getNotesDates(userId: userId);
      
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

    if (pickedDate == null) return;

    final normalizedDate = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
    );

    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NoteEditorScreen(
          selectedDate: normalizedDate,
        ),
      ),
    );

    if (result == true && mounted) {
      await _loadNotesDates();
      setState(() {
        _weekViewKey = UniqueKey();
        _refreshCounter++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const SidebarDrawer(),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 75,
        leadingWidth: 100,
        backgroundColor: Colors.white,
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
                          key: _weekViewKey,
                          selectedDate: _selectedDate,
                          onDateSelected: _onDateSelected,
                          notesDates: _notesDates,
                          refreshCounter: _refreshCounter,
                          onRefresh: () async {
                            await _loadNotesDates();
                            setState(() {
                              _refreshCounter++;
                            });
                          },
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