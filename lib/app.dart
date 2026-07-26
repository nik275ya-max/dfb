import 'package:flutter/material.dart';
import 'models/force_list.dart';
import 'services/storage_service.dart';
import 'screens/home_screen.dart';

class DFBApp extends StatefulWidget {
  const DFBApp({super.key});

  @override
  State<DFBApp> createState() => _DFBAppState();
}

class _DFBAppState extends State<DFBApp> {
  List<ForceList> _lists = [];
  String? _activeListId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final lists = await StorageService.loadLists();
    final activeId = await StorageService.loadActiveListId();
    setState(() {
      _lists = lists;
      _activeListId = activeId;
      _isLoading = false;
    });
  }

  void _onListsChanged(List<ForceList> lists) {
    setState(() {
      _lists = lists;
    });
    StorageService.saveLists(lists);
  }

  void _onActiveListChanged(String id) {
    setState(() {
      _activeListId = id;
    });
    StorageService.saveActiveListId(id);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'DFB - Digital Force Bag',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0088CC),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: HomeScreen(
        lists: _lists,
        activeListId: _activeListId,
        onListsChanged: _onListsChanged,
        onActiveListChanged: _onActiveListChanged,
      ),
    );
  }
}
