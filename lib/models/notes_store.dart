import 'package:flutter/foundation.dart';
import 'note.dart';

/// Penyimpanan catatan sederhana (in-memory).
/// Ganti dengan SQLite/Hive nanti kalau mau data tetap tersimpan.
class NotesStore extends ChangeNotifier {
  final List<Note> _notes = [
    Note(
      id: '1',
      title: 'Rencana Mingguan',
      body: 'design ui/ux, implementasi',
      category: 'Kerja',
      icon: '📅',
      priority: Priority.tinggi,
      important: true,
      createdAt: DateTime(2026, 10, 18),
    ),
    Note(
      id: '2',
      title: 'Catatan Kuliah',
      body: 'deadline progres',
      category: 'Kuliah',
      icon: '📝',
      priority: Priority.sedang,
      createdAt: DateTime(2026, 10, 17),
    ),
    Note(
      id: '3',
      title: 'Hal yang Perlu Dibeli',
      body: 'binder, kopi,',
      category: 'Pribadi',
      icon: '🛒',
      priority: Priority.rendah,
      createdAt: DateTime(2026, 10, 16),
    ),
    Note(
      id: '4',
      title: 'Ide Aplikasi',
      body:
          'Ide untuk membuat aplikasi catatan sederhana dengan fitur kategori, warna, dan prioritas. Aplikasi ini digunakan untuk mencatat ide, rencana, dan hal penting sehari-hari.',
      category: 'Pribadi',
      icon: '💡',
      priority: Priority.tinggi,
      important: true,
      createdAt: DateTime(2026, 10, 19, 9, 30),
      checklist: [
        ChecklistItem('Buat wireframe & desain UI', done: true),
        ChecklistItem('Setup project Flutter & dependencies'),
        ChecklistItem('Implementasi local storage SQLite/Hive'),
      ],
      tags: ['Ide', 'Flutter', 'Produktif'],
    ),
    Note(
      id: '5',
      title: 'Belajar Dart',
      body: 'Latihan async & stream',
      category: 'Kuliah',
      icon: '🎯',
      priority: Priority.sedang,
      archived: true,
      createdAt: DateTime(2026, 10, 12),
    ),
  ];

  List<Note> get all => List.unmodifiable(_notes);
  List<Note> get active => _notes.where((n) => !n.archived).toList();
  List<Note> get archived => _notes.where((n) => n.archived).toList();
  int get total => _notes.length;
  int get importantCount => _notes.where((n) => n.important).length;

  void add(Note n) {
    _notes.insert(0, n);
    notifyListeners();
  }

  void remove(Note n) {
    _notes.remove(n);
    notifyListeners();
  }

  void toggleArchive(Note n) {
    n.archived = !n.archived;
    notifyListeners();
  }

  void toggleCompleted(Note n) {
    n.completed = !n.completed;
    notifyListeners();
  }

  void toggleChecklist(Note n, int index) {
    n.checklist[index].done = !n.checklist[index].done;
    notifyListeners();
  }
}

/// Instance global sederhana (cukup untuk tugas/prototipe)
final notesStore = NotesStore();
