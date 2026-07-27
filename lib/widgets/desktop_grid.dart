import 'package:flutter/material.dart';
import '../utils/app_icons.dart';
import 'app_icon.dart';

class DesktopGrid extends StatelessWidget {
  final List<AppIconData> icons;
  final Function(String iconName)? onIconTap;

  const DesktopGrid({
    super.key,
    required this.icons,
    this.onIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 24,
          crossAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: icons.length,
        itemBuilder: (context, index) {
          final appIcon = icons[index];
          return AppIconWidget(
            appIcon: appIcon,
            onTap: onIconTap != null ? () => onIconTap!(appIcon.name) : null,
          );
        },
      ),
    );
  }
}
