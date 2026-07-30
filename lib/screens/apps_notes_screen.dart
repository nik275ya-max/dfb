import 'dart:io';
import 'package:flutter/material.dart';
import '../models/force_list.dart';
import '../services/storage_service.dart';
import '../utils/app_icons.dart';
import '../widgets/desktop_grid.dart';
import 'notes_screen.dart';

class AppsNotesScreen extends StatefulWidget {
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
  State<AppsNotesScreen> createState() => _AppsNotesScreenState();
}

class _AppsNotesScreenState extends State<AppsNotesScreen> {
  @override
  void initState() {
    super.initState();
    StorageService.backgroundPathNotifier.addListener(_onBackgroundChanged);
  }

  @override
  void dispose() {
    StorageService.backgroundPathNotifier.removeListener(_onBackgroundChanged);
    super.dispose();
  }

  void _onBackgroundChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bgPath = StorageService.getCachedBackgroundPath();

    Widget background;
    if (bgPath != null && File(bgPath).existsSync()) {
      background = Image.file(
        File(bgPath),
        fit: BoxFit.cover,
      );
    } else {
      background = const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
          ),
        ),
      );
    }

    return Stack(
      children: [
        Positioned.fill(child: background),
        Positioned.fill(
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
                              lists: widget.lists,
                              activeListId: widget.activeListId,
                              onListsChanged: widget.onListsChanged,
                              onActiveListChanged:
                                  widget.onActiveListChanged,
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
        ),
      ],
    );
  }
}