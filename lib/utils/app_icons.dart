import 'package:flutter/material.dart';

class AppIconData {
  final String name;
  final IconData icon;
  final Color color;
  final int position; // 1-9 for grid position

  const AppIconData({
    required this.name,
    required this.icon,
    required this.color,
    required this.position,
  });
}

// Screen 1: Tens (3x3 grid)
const List<AppIconData> screen1Icons = [
  AppIconData(name: 'WhatsApp', icon: Icons.chat, color: Color(0xFF25D366), position: 1),
  AppIconData(name: 'Telegram', icon: Icons.send, color: Color(0xFF0088CC), position: 2),
  AppIconData(name: 'VK', icon: Icons.group, color: Color(0xFF4C75A3), position: 3),
  AppIconData(name: 'Instagram', icon: Icons.camera_alt, color: Color(0xFFE1306C), position: 4),
  AppIconData(name: 'YouTube', icon: Icons.play_circle, color: Color(0xFFFF0000), position: 5),
  AppIconData(name: 'TikTok', icon: Icons.music_note, color: Color(0xFF000000), position: 6),
  AppIconData(name: 'Spotify', icon: Icons.headphones, color: Color(0xFF1DB954), position: 7),
  AppIconData(name: 'Netflix', icon: Icons.movie, color: Color(0xFFE50914), position: 8),
  AppIconData(name: 'Phone', icon: Icons.phone, color: Color(0xFF4CAF50), position: 9),
];

// Screen 2: Units (3x3 grid)
const List<AppIconData> screen2Icons = [
  AppIconData(name: 'Gmail', icon: Icons.email, color: Color(0xFFEA4335), position: 1),
  AppIconData(name: 'Chrome', icon: Icons.language, color: Color(0xFF4285F4), position: 2),
  AppIconData(name: 'Maps', icon: Icons.map, color: Color(0xFF34A853), position: 3),
  AppIconData(name: 'Camera', icon: Icons.photo_camera, color: Color(0xFF607D8B), position: 4),
  AppIconData(name: 'Calendar', icon: Icons.calendar_today, color: Color(0xFF4285F4), position: 5),
  AppIconData(name: 'Clock', icon: Icons.access_time, color: Color(0xFF039BE5), position: 6),
  AppIconData(name: 'Notes', icon: Icons.note, color: Color(0xFFFBBC04), position: 7),
  AppIconData(name: 'Weather', icon: Icons.wb_sunny, color: Color(0xFFFF9800), position: 8),
  AppIconData(name: 'Calculator', icon: Icons.calculate, color: Color(0xFF78909C), position: 9),
];

// Screen 3: Extra apps for distraction
const List<AppIconData> screen3Icons = [
  AppIconData(name: 'Files', icon: Icons.folder, color: Color(0xFF4285F4), position: 1),
  AppIconData(name: 'Photos', icon: Icons.photo_library, color: Color(0xFFEA4335), position: 2),
  AppIconData(name: 'Music', icon: Icons.music_note, color: Color(0xFFFF5722), position: 3),
  AppIconData(name: 'Settings', icon: Icons.settings, color: Color(0xFF607D8B), position: 4),
  AppIconData(name: 'Contacts', icon: Icons.contacts, color: Color(0xFF2196F3), position: 5),
  AppIconData(name: 'Translate', icon: Icons.translate, color: Color(0xFF4285F4), position: 6),
  AppIconData(name: 'Notes', icon: Icons.note, color: Color(0xFFFBBC04), position: 7),
  AppIconData(name: 'Podcast', icon: Icons.podcasts, color: Color(0xFF8E24AA), position: 8),
  AppIconData(name: 'Wallet', icon: Icons.account_balance_wallet, color: Color(0xFF43A047), position: 9),
];
