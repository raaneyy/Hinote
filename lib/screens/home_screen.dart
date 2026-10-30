import 'package:flutter/material.dart';
import '../models/note.dart';
import '../models/notes_store.dart';
import '../theme.dart';
import '../widgets/note_card.dart';
import 'note_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Priority? _filter; 
  String _query = '';

  @override
  void initState() {
    super.initState();
    notesStore.addListener(_refresh);
  }

  @override
  void dispose() {
    notesStore.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  List<Note> get _visible {
    return notesStore.active.where((n) {
      final okPriority = _filter == null || n.priority == _filter;
      final q = _query.toLowerCase();
      final okQuery = q.isEmpty ||
          n.title.toLowerCase().contains(q) ||
          n.body.toLowerCase().contains(q);
      return okPriority && okQuery;
    }).toList();
  }

  void _openMenu(Note n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.inventory_2_outlined),
              title: const Text('Arsipkan'),
              onTap: () {
                Navigator.pop(context);
                notesStore.toggleArchive(n);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline,
                  color: AppColors.danger),
              title: const Text('Hapus',
                  style: TextStyle(color: AppColors.danger)),
              onTap: () {
                Navigator.pop(context);
                notesStore.remove(n);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notes = _visible;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Halo, Cheesy 👋',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w700)),
                      SizedBox(height: 2),
                      Text('Apa yang ingin kamu catat hari ini?',
                          style: TextStyle(
                              fontSize: 13, color: AppColors.muted)),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAE3D6),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: .08),
                              blurRadius: 6)
                        ],
                      ),
                      child: const Text('CY',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.forest)),
                    ),
                    Positioned(
                      right: 1,
                      bottom: 1,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4F8B74),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Pencarian
            Container(
              height: 46,
              decoration: fieldBox(color: AppColors.bg),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  const Icon(Icons.search, size: 20, color: AppColors.muted),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => _query = v),
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        hintText: 'Cari catatan...',
                        hintStyle:
                            TextStyle(color: AppColors.muted, fontSize: 14),
                      ),
                    ),
                  ),
                  const Icon(Icons.filter_alt_outlined,
                      size: 20, color: AppColors.muted),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Statistik
            Row(
              children: [
                Expanded(
                    child: _statCard(
                        Icons.assignment_outlined,
                        const Color(0xFFE6E8D8),
                        AppColors.forest,
                        'Total',
                        '${notesStore.total} Catatan')),
                const SizedBox(width: 10),
                Expanded(
                    child: _statCard(
                        Icons.star_rounded,
                        const Color(0xFFF1E6D2),
                        AppColors.gold,
                        'Penting',
                        '${notesStore.importantCount} Catatan')),
              ],
            ),
            const SizedBox(height: 14),

            // Filter prioritas
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _chip('Semua', _filter == null, () {
                    setState(() => _filter = null);
                  }),
                  _chip('Tinggi', _filter == Priority.tinggi, () {
                    setState(() => _filter = Priority.tinggi);
                  }),
                  _chip('Sedang', _filter == Priority.sedang, () {
                    setState(() => _filter = Priority.sedang);
                  }),
                  _chip('Rendah', _filter == Priority.rendah, () {
                    setState(() => _filter = Priority.rendah);
                  }),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Daftar catatan
            Expanded(
              child: notes.isEmpty
                  ? const Center(
                      child: Text('Belum ada catatan',
                          style: TextStyle(color: AppColors.muted, fontSize: 14)))
                  : ListView.separated(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: notes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) => NoteCard(
                        note: notes[i],
                        onMore: () => _openMenu(notes[i]),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) =>
                                  NoteDetailScreen(note: notes[i])),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(IconData icon, Color bg, Color fg, String label,
      String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: fieldBox(color: AppColors.bg),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
                color: bg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: fg, size: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: AppColors.muted, fontSize: 11)),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(value,
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.sage : AppColors.bg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
                color: selected ? AppColors.sage : AppColors.border),
          ),
          child: Text(label,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppColors.forest)),
        ),
      ),
    );
  }
}
