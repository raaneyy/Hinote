import 'package:flutter/material.dart';
import '../theme.dart';
import 'add_note_screen.dart';
import 'archive_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _pages = [HomeScreen(), ArchiveScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: IndexedStack(index: _index, children: _pages),
      floatingActionButton: _index == 0
          ? FloatingActionButton(
              backgroundColor: AppColors.sage,
              foregroundColor: Colors.white,
              elevation: 3,
              shape: const CircleBorder(),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AddNoteScreen()),
              ),
              child: const Icon(Icons.add, size: 26),
            )
          : null,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _index,
            onTap: (i) => setState(() => _index = i),
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.forest,
            unselectedItemColor: AppColors.muted,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded, size: 24), label: 'Beranda'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.inventory_2_outlined, size: 24),
                  label: 'Arsip'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline, size: 24), label: 'Profil'),
            ],
          ),
        ),
      ),
    );
  }
}
