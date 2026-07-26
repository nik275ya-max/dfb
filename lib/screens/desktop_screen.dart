import 'package:flutter/material.dart';
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

  int? _getPositionFromGlobal(Offset globalPosition) {
    final RenderBox? gridBox =
        _gridKey.currentContext?.findRenderObject() as RenderBox?;
    if (gridBox == null) return null;
    final localPos = gridBox.globalToLocal(globalPosition);
    final size = gridBox.size;
    final contentW = size.width - 48;
    final contentH = size.height - 32;
    final px = localPos.dx - 24;
    final py = localPos.dy - 16;
    if (px < 0 || py < 0 || px >= contentW || py >= contentH) return null;
    final col = (px / contentW * 3).floor().clamp(0, 2);
    final row = (py / contentH * 3).floor().clamp(0, 2);
    return row * 3 + col + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        _swipeStart = event.position;
        _swiping = true;
      },
      onPointerMove: (event) {
        if (_swipeStart == null || !_swiping) return;

        final delta = event.position - _swipeStart!;

        if (delta.distance > 50 && delta.dy.abs() > delta.dx.abs()) {
          _swiping = false;
          final position = _getPositionFromGlobal(_swipeStart!);
          if (position != null && position >= 1 && position <= 9) {
            widget.onSwipeDetected(position);
          }
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
      child: Container(
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
              _buildStatusBar(context),
              Expanded(
                child: DesktopGrid(
                  key: _gridKey,
                  icons: widget.icons,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${TimeOfDay.now().hour.toString().padLeft(2, '0')}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Row(
            children: [
              Icon(Icons.signal_cellular_4_bar, color: Colors.white, size: 16),
              SizedBox(width: 4),
              Icon(Icons.wifi, color: Colors.white, size: 16),
              SizedBox(width: 4),
              Icon(Icons.battery_full, color: Colors.white, size: 16),
            ],
          ),
        ],
      ),
    );
  }
}
