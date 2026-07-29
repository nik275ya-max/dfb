import 'package:flutter/material.dart';
import '../utils/app_icons.dart';

class AppIconWidget extends StatelessWidget {
  final AppIconData appIcon;
  final VoidCallback? onTap;

  const AppIconWidget({
    super.key,
    required this.appIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: appIcon.color.withValues(alpha: 0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: appIcon.color.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                appIcon.icon,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            appIcon.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
