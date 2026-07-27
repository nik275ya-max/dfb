import 'package:flutter/material.dart';
import '../models/force_list.dart';
import '../utils/app_icons.dart';
import '../widgets/desktop_grid.dart';
import 'notes_screen.dart';
import 'settings_screen.dart';

class AppsNotesScreen extends StatelessWidget {
  final List<ForceList> lists;
  final String? activeListId;
  final Function(List<ForceList>)? onListsChanged;
  final Function(String)? onActiveListChanged;

  const AppsNotesScreen({
    super.key,
    required this.lists,
    this.activeListId,
    this.onListsChanged,
    this.onActiveListChanged,
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
        child: Stack(
          children: [
            Column(
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
            Positioned(
              top: 8,
              right: 16,
              child: GestureDetector(
                onTap: () {
                  if (onListsChanged != null && onActiveListChanged != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsScreen(
                          lists: lists,
                          activeListId: activeListId,
                          onListsChanged: onListsChanged!,
                          onActiveListChanged: onActiveListChanged!,
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 20,
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
