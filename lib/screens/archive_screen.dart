import 'package:flutter/material.dart';
import '../models/notes_store.dart';
import '../theme.dart';
import '../widgets/note_card.dart';
import 'note_detail_screen.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
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

  @override
  Widget build(BuildContext context) {
    final notes = notesStore.archived;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Arsip',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            const Text('Catatan yang kamu simpan di luar beranda',
                style: TextStyle(fontSize: 13, color: AppColors.muted)),
            const SizedBox(height: 14),
            Expanded(
              child: notes.isEmpty
                  ? const Center(
                      child: Text('Arsip masih kosong',
                          style: TextStyle(color: AppColors.muted, fontSize: 14)))
                  : ListView.separated(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: notes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) => NoteCard(
                        note: notes[i],
                        onMore: () => notesStore.toggleArchive(notes[i]),
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
}
