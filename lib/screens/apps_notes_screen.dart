import 'package:flutter/material.dart';
import '../models/force_list.dart';
import '../utils/app_icons.dart';
import '../widgets/desktop_grid.dart';
import 'notes_screen.dart';

class AppsNotesScreen extends StatelessWidget {
  final List<ForceList> lists;
  final String? activeListId;

  const AppsNotesScreen({
    super.key,
    required this.lists,
    this.activeListId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1a1a2e),
            Color(0xFF16213e),
            Color(0xFF0f3460),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            Expanded(
              flex: 8,
              child: DesktopGrid(
                icons: screen3Icons,
                onIconTap: (name) {
                  if (name == 'Заметки') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotesScreen(
                          lists: lists,
                          activeListId: activeListId,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
