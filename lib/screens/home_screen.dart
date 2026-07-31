import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import '../models/force_list.dart';
import '../services/storage_service.dart';
import '../utils/app_icons.dart';
import 'desktop_screen.dart';
import 'apps_notes_screen.dart';

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
    StorageService.loadBackgroundPath();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onSwipeDetected(int position, bool isTensScreen) {
    if (isTensScreen) {
      _tensDigit = position;
      _tensSelected = true;
    } else {
      _unitsDigit = position;
      _unitsSelected = true;
    }

    _checkAndShowResult();
  }

  void _checkAndShowResult() {
    if (_tensSelected && _unitsSelected) {
      final number = _tensDigit * 10 + _unitsDigit;
      StorageService.saveLastSwipeNumber(number);

      if (number > 0) {
        Vibration.vibrate(duration: 100);
      }

      setState(() {
        _tensSelected = false;
        _unitsSelected = false;
      });
    }
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
                if (index == 0) {
                  _unitsSelected = false;
                }
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
                onListsChanged: widget.onListsChanged,
                onActiveListChanged: widget.onActiveListChanged,
              ),
            ],
          ),
          _buildPageIndicator(),
        ],
      ),
    );
  }
}
