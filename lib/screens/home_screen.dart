import 'package:flutter/material.dart';
import '../models/force_list.dart';
import '../services/storage_service.dart';
import '../utils/app_icons.dart';
import 'desktop_screen.dart';
import 'apps_notes_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final List<ForceList> lists;
  final String? activeListId;
  final Function(List<ForceList>) onListsChanged;
  final Function(String) onActiveListChanged;

  const HomeScreen({
    super.key,
    required this.lists,
    required this.activeListId,
    required this.onListsChanged,
    required this.onActiveListChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  int _tensDigit = 0;
  int _unitsDigit = 0;
  bool _tensSelected = false;
  bool _unitsSelected = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  ForceList? get _activeList {
    if (widget.activeListId == null) return null;
    try {
      return widget.lists.firstWhere((l) => l.id == widget.activeListId);
    } catch (_) {
      return widget.lists.isNotEmpty ? widget.lists.first : null;
    }
  }

  void _onSwipeDetected(int position, bool isTensScreen) {
    if (isTensScreen) {
      _tensDigit = position;
      _tensSelected = true;
    } else {
      _unitsDigit = position;
      _unitsSelected = true;
    }

    final screen = isTensScreen ? '10' : '1';
    final digit = isTensScreen ? _tensDigit : _unitsDigit;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Экран $screen: позиция $position → цифра $digit'),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF0088CC),
      ),
    );

    _checkAndShowResult();
  }

  void _checkAndShowResult() {
    if (_tensSelected && _unitsSelected) {
      final number = _tensDigit * 10 + _unitsDigit;
      StorageService.saveLastSwipeNumber(number);

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Число $number сохранено! Откройте Заметки.'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green.shade700,
        ),
      );

      _showResult(number);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _tensSelected = false;
            _unitsSelected = false;
          });
        }
      });
    }
  }

  void _showResult(int number) {
    final list = _activeList;
    if (list == null) return;

    final word = list.forcedWord.isNotEmpty ? list.forcedWord : list.getWord(number);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        title: Text(
          'Номер: $number',
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Слово:',
              style: TextStyle(color: Colors.white54),
            ),
            const SizedBox(height: 16),
            Text(
              word,
              style: const TextStyle(
                color: Colors.green,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          lists: widget.lists,
          activeListId: widget.activeListId,
          onListsChanged: widget.onListsChanged,
          onActiveListChanged: widget.onActiveListChanged,
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Positioned(
      bottom: 24,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index == _currentPage
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.3),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              DesktopScreen(
                icons: screen1Icons,
                isTensScreen: true,
                onSwipeDetected: (position) =>
                    _onSwipeDetected(position, true),
              ),
              DesktopScreen(
                icons: screen2Icons,
                isTensScreen: false,
                onSwipeDetected: (position) =>
                    _onSwipeDetected(position, false),
              ),
              AppsNotesScreen(
                lists: widget.lists,
                activeListId: widget.activeListId,
              ),
            ],
          ),
          _buildPageIndicator(),
          // Settings button
          Positioned(
            top: MediaQuery.of(context).padding.top + 48,
            right: 16,
            child: GestureDetector(
              onTap: _openSettings,
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
    );
  }
}
