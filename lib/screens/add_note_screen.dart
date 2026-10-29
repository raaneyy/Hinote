import 'package:flutter/material.dart';
import '../models/note.dart';
import '../models/notes_store.dart';
import '../theme.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  static const _icons = ['💡', '📅', '📝', '🛒', '🎯', '⭐'];
  static const _categories = ['Kerja', 'Kuliah', 'Pribadi'];

  final _title = TextEditingController();
  final _body = TextEditingController();
  final List<TextEditingController> _todoCtrls = [TextEditingController()];

  int _iconIndex = 0;
  bool _todoMode = false;
  String? _category;
  Priority _priority = Priority.sedang;

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    for (final c in _todoCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    if (_title.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul catatan tidak boleh kosong')),
      );
      return;
    }
    final items = _todoMode
        ? _todoCtrls
            .where((c) => c.text.trim().isNotEmpty)
            .map((c) => ChecklistItem(c.text.trim()))
            .toList()
        : <ChecklistItem>[];

    notesStore.add(Note(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: _title.text.trim(),
      body: _body.text.trim(),
      icon: _icons[_iconIndex],
      category: _category ?? 'Pribadi',
      priority: _priority,
      important: _priority == Priority.tinggi,
      checklist: items,
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Tambah Catatan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.border),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('Tambah Ikon'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              decoration: fieldBox(color: AppColors.bg),
              child: Row(
                children: List.generate(_icons.length, (i) {
                  final sel = i == _iconIndex;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _iconIndex = i),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: sel ? const Color(0xFFEAE3D6) : null,
                          borderRadius: BorderRadius.circular(12),
                          border: sel
                              ? Border.all(color: AppColors.forest, width: 2)
                              : null,
                        ),
                        child: Text(_icons[i],
                            style: const TextStyle(fontSize: 20)),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),

            _label('Judul Catatan'),
            Container(
              decoration: fieldBox(),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: TextField(
                controller: _title,
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Masukkan judul catatan...',
                  hintStyle: TextStyle(color: AppColors.muted, fontSize: 14),
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Toggle to-do list
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: fieldBox(),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                        color: const Color(0xFFE6E8D8),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.task_alt,
                        size: 18, color: AppColors.forest),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text('Format To-Do List',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                  Switch(
                    value: _todoMode,
                    activeTrackColor: AppColors.sage,
                    activeThumbColor: Colors.white,
                    onChanged: (v) => setState(() => _todoMode = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _label(_todoMode ? 'Daftar Tugas' : 'Isi Catatan'),
            if (!_todoMode)
              Container(
                decoration: fieldBox(color: Colors.white),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: TextField(
                  controller: _body,
                  maxLines: 4,
                  minLines: 3,
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Tulis catatan Anda di sini...',
                    hintStyle: TextStyle(color: AppColors.muted, fontSize: 14),
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              )
            else
              Column(
                children: [
                  for (int i = 0; i < _todoCtrls.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        decoration: fieldBox(color: Colors.white),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            const Icon(Icons.check_box_outline_blank,
                                size: 18, color: AppColors.muted),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _todoCtrls[i],
                                style: const TextStyle(fontSize: 14),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  hintText: 'Tugas ${i + 1}',
                                  hintStyle:
                                      const TextStyle(color: AppColors.muted, fontSize: 14),
                                ),
                              ),
                            ),
                            if (_todoCtrls.length > 1)
                              IconButton(
                                icon: const Icon(Icons.close,
                                    color: AppColors.muted, size: 18),
                                onPressed: () => setState(() {
                                  _todoCtrls.removeAt(i).dispose();
                                }),
                              ),
                          ],
                        ),
                      ),
                    ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => setState(
                          () => _todoCtrls.add(TextEditingController())),
                      icon: const Icon(Icons.add, size: 18, color: AppColors.forest),
                      label: const Text('Tambah tugas',
                          style: TextStyle(color: AppColors.forest, fontSize: 13)),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),

            _label('Kategori'),
            Container(
              decoration: fieldBox(),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _category,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  hint: const Row(
                    children: [
                      Icon(Icons.folder_open, size: 18, color: AppColors.muted),
                      SizedBox(width: 10),
                      Text('Pilih Kategori...',
                          style: TextStyle(
                              color: AppColors.ink,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  items: _categories
                      .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c, style: const TextStyle(fontSize: 14))))
                      .toList(),
                  onChanged: (v) => setState(() => _category = v),
                ),
              ),
            ),
            const SizedBox(height: 16),

            _label('Tingkat Prioritas'),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFEAE6DE),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  _prio(Priority.rendah, AppColors.low),
                  _prio(Priority.sedang, AppColors.mid),
                  _prio(Priority.tinggi, AppColors.high),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.forest,
                foregroundColor: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.check, size: 20),
              label: const Text('Simpan Catatan',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(t,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
      );

  Widget _prio(Priority p, Color dot) {
    final sel = _priority == p;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _priority = p),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 38,
          decoration: BoxDecoration(
            color: sel ? AppColors.forest : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(color: dot, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text(p.label,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: sel ? FontWeight.w600 : FontWeight.w500,
                      color: sel ? Colors.white : AppColors.muted)),
            ],
          ),
        ),
      ),
    );
  }
}
