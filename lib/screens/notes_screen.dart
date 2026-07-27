import 'package:flutter/material.dart';
import '../models/force_list.dart';
import '../services/storage_service.dart';

class NotesScreen extends StatefulWidget {
  final List<ForceList> lists;
  final String? activeListId;

  const NotesScreen({
    super.key,
    required this.lists,
    this.activeListId,
  });

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  String? _selectedListId;

  @override
  void initState() {
    super.initState();
    _selectedListId = widget.activeListId;
    if (_selectedListId == null && widget.lists.isNotEmpty) {
      _selectedListId = widget.lists.first.id;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  int? get _lastSwipeNumber => StorageService.getLastSwipeNumberSync();

  ForceList? get _selectedList {
    if (_selectedListId == null) return null;
    try {
      return widget.lists.firstWhere((l) => l.id == _selectedListId);
    } catch (_) {
      return widget.lists.isNotEmpty ? widget.lists.first : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = _selectedList;
    final number = _lastSwipeNumber;
    final forcedWord = list?.forcedWord ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Заметки'),
        backgroundColor: const Color(0xFF1a1a2e),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFF0f0f1a),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: number != null && forcedWord.isNotEmpty
                ? const Color(0xFF0088CC)
                : const Color(0xFF444444),
            child: Text(
              number != null && forcedWord.isNotEmpty
                  ? 'Форс: №$number → «$forcedWord»'
                  : 'Номер не задан (был: $number)',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          _buildListSelector(),
          Expanded(
            child: list != null
                ? _buildWordsList(list)
                : _buildEmptyState(),
          ),
        ],
      ),
    );
  }

  Widget _buildListSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF1a1a2e),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Выберите список:',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.lists.length,
              itemBuilder: (context, index) {
                final list = widget.lists[index];
                final isSelected = list.id == _selectedListId;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(list.name),
                    selected: isSelected,
                    selectedColor: const Color(0xFF0088CC),
                    backgroundColor: const Color(0xFF2d2d44),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _selectedListId = list.id;
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordsList(ForceList list) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.words.length,
      itemBuilder: (context, index) {
        final word = list.words[index];
        final position = index + 1;
        final displayWord = list.forcedWord.isNotEmpty && position == _lastSwipeNumber
            ? list.forcedWord
            : word;

        return Container(
          margin: const EdgeInsets.only(bottom: 4),
          child: ListTile(
            dense: true,
            title: Text(
              '$position. $displayWord',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_add,
            color: Colors.white24,
            size: 64,
          ),
          SizedBox(height: 16),
          Text(
            'Выберите список\nдля просмотра',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
