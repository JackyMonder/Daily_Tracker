import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/note_model.dart';
import '../../data/repositories/note_repository.dart';
import '../../utils/notesection.dart';

class Notecards extends StatefulWidget {
  final DateTime? selectedDate;
  final String? userId;

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
  DateTime? _lastRefreshTime;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  void didUpdateWidget(Notecards oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload notes if selectedDate changes OR if widget key changes (which means parent was rebuilt)
    if (oldWidget.selectedDate != widget.selectedDate || oldWidget.key != widget.key) {
      _loadNotes();
    }
  }

  // Removed didChangeDependencies auto-refresh to avoid excessive calls
  // User can manually pull to refresh instead

  Future<void> _loadNotes() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      String? userId = widget.userId;
      if (userId == null) {
        final user = FirebaseAuth.instance.currentUser;
        userId = user?.uid;
      }

      List<NoteModel> notes;

      if (widget.selectedDate != null) {
        notes = await _noteRepository.getNotesByDate(
          widget.selectedDate!,
          userId: userId,
        );
      } else {
        notes = await _noteRepository.getAllNotes(userId: userId);
      }

      if (mounted) {
        setState(() {
          _notes = notes;
          _isLoading = false;
          _lastRefreshTime = DateTime.now();
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

  Future<void> refreshNotes() async {
    await _loadNotes();
  }

  List<NoteModel> get filteredNotes {
    if (widget.selectedDate == null) {
      return _notes;
    }

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
