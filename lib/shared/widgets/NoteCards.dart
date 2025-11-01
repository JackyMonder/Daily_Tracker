import 'package:flutter/material.dart';
import '../../data/models/note_model.dart';
import '../../data/repositories/note_repository.dart';
import '../../utils/notesection.dart';

/// Widget hiển thị danh sách note cards
/// 
/// Tự động load notes từ Firebase và filter theo ngày được chọn
class Notecards extends StatefulWidget {
  final DateTime? selectedDate;
  final String? userId; // Optional: để filter notes theo user

  const Notecards({
    super.key,
    this.selectedDate,
    this.userId,
  });

  @override
  State<Notecards> createState() => _NotecardsState();
}

class _NotecardsState extends State<Notecards> {
  final NoteRepository _noteRepository = NoteRepository();
  List<NoteModel> _notes = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  void didUpdateWidget(Notecards oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload notes khi selectedDate thay đổi
    if (oldWidget.selectedDate != widget.selectedDate) {
      _loadNotes();
    }
  }

  /// Load notes từ Firebase
  Future<void> _loadNotes() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      List<NoteModel> notes;

      if (widget.selectedDate != null) {
        // Load notes theo ngày được chọn
        notes = await _noteRepository.getNotesByDate(
          widget.selectedDate!,
          userId: widget.userId,
        );
      } else {
        // Load tất cả notes
        notes = await _noteRepository.getAllNotes(userId: widget.userId);
      }

      if (mounted) {
        setState(() {
          _notes = notes;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  /// Refresh notes (có thể gọi từ parent)
  Future<void> refreshNotes() async {
    await _loadNotes();
  }

  List<NoteModel> get filteredNotes {
    if (widget.selectedDate == null) {
      return _notes;
    }

    // Filter notes theo ngày (đã được filter ở _loadNotes, nhưng double check)
    return _notes.where((note) {
      final noteDate = note.createdAt;
      return noteDate.year == widget.selectedDate!.year &&
             noteDate.month == widget.selectedDate!.month &&
             noteDate.day == widget.selectedDate!.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading notes',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadNotes,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final filteredData = filteredNotes;

    return SafeArea(
      child: filteredData.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.note_outlined,
                    size: 64,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.selectedDate != null
                        ? "No notes for ${_formatDate(widget.selectedDate!)}"
                        : "No Notes Available",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to create a new note',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                return Notesection(
                  note: filteredData[index],
                );
              },
            ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
