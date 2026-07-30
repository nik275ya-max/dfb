import 'dart:io';
import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../utils/app_icons.dart';
import '../widgets/desktop_grid.dart';

class DesktopScreen extends StatefulWidget {
  final List<AppIconData> icons;
  final bool isTensScreen;
  final Function(int position) onSwipeDetected;

  const DesktopScreen({
    super.key,
    required this.icons,
    required this.isTensScreen,
    required this.onSwipeDetected,
  });

  @override
  State<DesktopScreen> createState() => _DesktopScreenState();
}

class _DesktopScreenState extends State<DesktopScreen> {
  final GlobalKey _gridKey = GlobalKey();
  Offset? _swipeStart;
  bool _swiping = false;

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

  int _getPositionFromGlobal(Offset globalPosition) {
    final RenderBox? gridBox =
        _gridKey.currentContext?.findRenderObject() as RenderBox?;
    if (gridBox == null) return 0;
    final localPos = gridBox.globalToLocal(globalPosition);
    final size = gridBox.size;

    const padX = 12.0;
    const padY = 8.0;
    const crossSpacing = 16.0;
    const mainSpacing = 24.0;
    const aspectRatio = 0.85;

    final contentW = size.width - padX * 2;
    if (contentW <= 0) return 0;

    final cellW = (contentW - crossSpacing * 2) / 3;
    final cellH = cellW / aspectRatio;

    final px = localPos.dx - padX;
    final py = localPos.dy - padY;
    if (px < 0 || py < 0) return 0;

    final slotW = cellW + crossSpacing;
    final slotH = cellH + mainSpacing;

    final col = (px / slotW).floor().clamp(0, 2);
    final row = (py / slotH).floor().clamp(0, 2);

    return row * 3 + col + 1;
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

    return Listener(
      onPointerDown: (event) {
        _swipeStart = event.position;
        _swiping = true;
      },
      onPointerMove: (event) {
        if (_swipeStart == null || !_swiping) return;
        final delta = event.position - _swipeStart!;
        if (delta.distance > 25 && delta.dx.abs() > delta.dy.abs()) {
          _swiping = false;
          final position = _getPositionFromGlobal(_swipeStart!);
          widget.onSwipeDetected(position);
          _swipeStart = null;
        }
      },
      onPointerUp: (event) {
        _swipeStart = null;
        _swiping = false;
      },
      onPointerCancel: (event) {
        _swipeStart = null;
        _swiping = false;
      },
      child: Stack(
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
                      key: _gridKey,
                      icons: widget.icons,
                    ),
                  ),
                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}