import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';
import '../theme.dart';

/// Warna chip kategori
({Color bg, Color fg}) categoryColors(String category) {
  switch (category) {
    case 'Kerja':
      return (bg: const Color(0xFFE6EBD8), fg: AppColors.forest);
    case 'Kuliah':
      return (bg: const Color(0xFFE8E6F2), fg: const Color(0xFF5B5780));
    case 'Pribadi':
      return (bg: const Color(0xFFF6E4DC), fg: const Color(0xFFB0553A));
    default:
      return (bg: const Color(0xFFEFEADF), fg: AppColors.muted);
  }
}

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback? onMore;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    final c = categoryColors(note.category);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: c.bg.withOpacity(.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(note.icon, style: const TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          note.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: c.bg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(note.category,
                            style: TextStyle(
                                color: c.fg,
                                fontSize: 11,
                                fontWeight: FontWeight.w600)),
                      ),
                      GestureDetector(
                        onTap: onMore,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Icon(Icons.more_vert,
                              color: AppColors.muted, size: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(note.body,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.muted)),
                  const SizedBox(height: 3),
                  Text(
                    DateFormat('d MMM yyyy', 'id_ID').format(note.createdAt),
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.muted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
