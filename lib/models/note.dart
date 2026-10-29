enum Priority { rendah, sedang, tinggi }

extension PriorityX on Priority {
  String get label => switch (this) {
        Priority.rendah => 'Rendah',
        Priority.sedang => 'Sedang',
        Priority.tinggi => 'Tinggi',
      };
}

class ChecklistItem {
  String text;
  bool done;
  ChecklistItem(this.text, {this.done = false});
}

class Note {
  final String id;
  String title;
  String body;
  String category; // Kerja, Kuliah, Pribadi, ...
  String icon; // emoji
  Priority priority;
  bool important;
  bool completed;
  bool archived;
  DateTime createdAt;
  List<ChecklistItem> checklist;
  List<String> tags;

  Note({
    required this.id,
    required this.title,
    this.body = '',
    this.category = 'Pribadi',
    this.icon = '💡',
    this.priority = Priority.sedang,
    this.important = false,
    this.completed = false,
    this.archived = false,
    DateTime? createdAt,
    List<ChecklistItem>? checklist,
    List<String>? tags,
  })  : createdAt = createdAt ?? DateTime.now(),
        checklist = checklist ?? [],
        tags = tags ?? [];

  int get doneCount => checklist.where((c) => c.done).length;
}
