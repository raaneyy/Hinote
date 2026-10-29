import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';
import '../models/notes_store.dart';
import '../theme.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note note;
  const NoteDetailScreen({super.key, required this.note});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  Note get n => widget.note;

  static const _tagColors = [
    (bg: Color(0xFFE6EBD8), fg: Color(0xFF53613A)),
    (bg: Color(0xFFDDEBE8), fg: Color(0xFF2F6B63)),
    (bg: Color(0xFFF3E6D8), fg: Color(0xFF7A5A2E)),
  ];

  Future<void> _confirmDelete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus catatan?'),
        content: const Text('Catatan ini akan dihapus permanen.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus',
                  style: TextStyle(color: AppColors.danger))),
        ],
      ),
    );
    if (ok == true && mounted) {
      notesStore.remove(n);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = n.checklist.length;
    final done = n.doneCount;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 22),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Detail Catatan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note_rounded,
                color: AppColors.sage, size: 24),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded,
                color: AppColors.danger, size: 22),
            onPressed: _confirmDelete,
          ),
          const SizedBox(width: 4),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.border),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        children: [
          // Kartu judul
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: _card(),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAE3D6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(n.icon, style: const TextStyle(fontSize: 22)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(n.title,
                          style: AppTheme.serif(size: 18, weight: FontWeight.w700)),
                    ),
                    if (n.important)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBF0C2),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFF2DD86)),
                        ),
                        child: const Text('Penting',
                            style: TextStyle(
                                color: Color(0xFF9A4A0B),
                                fontSize: 11,
                                fontWeight: FontWeight.w600)),
                      ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(height: 1, color: AppColors.border),
                ),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 16, color: AppColors.muted),
                    const SizedBox(width: 6),
                    Text(
                      '${DateFormat('d MMMM yyyy', 'id_ID').format(n.createdAt)}'
                      ' • ${DateFormat('HH.mm').format(n.createdAt)} WIB',
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.ink),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          _section('DESKRIPSI'),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: _card(),
            child: Text(
              n.body.isEmpty ? '-' : n.body,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ),
          const SizedBox(height: 16),

          // Checklist
          if (total > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: _card(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_box_outlined,
                          size: 18, color: AppColors.sage),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text('Checklist Tugas / Item Terkait',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE4EBD6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('$done/$total Selesai',
                            style: const TextStyle(
                                color: AppColors.forest,
                                fontSize: 11,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: done / total,
                      minHeight: 6,
                      backgroundColor: const Color(0xFFEFE8DD),
                      valueColor:
                          const AlwaysStoppedAnimation(AppColors.sage),
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (int i = 0; i < total; i++) _checkItem(i),
                ],
              ),
            ),
          if (total > 0) const SizedBox(height: 16),

          if (n.tags.isNotEmpty) ...[
            _section('LABEL KATEGORI'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (int i = 0; i < n.tags.length; i++)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: _tagColors[i % _tagColors.length].bg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text('#${n.tags[i]}',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _tagColors[i % _tagColors.length].fg)),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 16),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        decoration: const BoxDecoration(
          color: AppColors.bg,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      notesStore.toggleCompleted(n);
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.sage,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    icon: Icon(n.completed ? Icons.undo : Icons.check, size: 18),
                    label: Text(
                        n.completed ? 'Tandai Belum Selesai' : 'Tandai Selesai',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.forest,
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    icon: const Icon(Icons.share_outlined, size: 18),
                    label: const Text('Bagikan',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _checkItem(int i) {
    final item = n.checklist[i];
    return GestureDetector(
      onTap: () {
        notesStore.toggleChecklist(n, i);
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: item.done ? const Color(0xFFF6F2EA) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: item.done ? AppColors.forest : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                    color: item.done ? AppColors.forest : AppColors.muted,
                    width: 1.5),
              ),
              child: item.done
                  ? const Icon(Icons.check, size: 15, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                item.text,
                style: TextStyle(
                  fontSize: 14,
                  color: item.done ? AppColors.muted : AppColors.ink,
                  decoration:
                      item.done ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(t,
            style: const TextStyle(
                fontSize: 13,
                letterSpacing: .6,
                fontWeight: FontWeight.w600,
                color: AppColors.muted)),
      );

  BoxDecoration _card() => BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      );
}
