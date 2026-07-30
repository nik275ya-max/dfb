import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/force_list.dart';
import '../services/storage_service.dart';

class NotesScreen extends StatefulWidget {
  final List<ForceList> lists;
  final String? activeListId;
  final Function(List<ForceList>)? onListsChanged;
  final Function(String)? onActiveListChanged;

  const NotesScreen({
    super.key,
    required this.lists,
    this.activeListId,
    this.onListsChanged,
    this.onActiveListChanged,
  });

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  String? _selectedListId;
  late List<ForceList> _lists;

  @override
  void initState() {
    super.initState();
    _selectedListId = widget.activeListId;
    if (_selectedListId == null && widget.lists.isNotEmpty) {
      _selectedListId = widget.lists.first.id;
    }
    _lists = List.from(widget.lists);
  }

  int? get _lastSwipeNumber => StorageService.getLastSwipeNumberSync();

  ForceList? get _selectedList {
    if (_selectedListId == null) return null;
    try {
      return _lists.firstWhere((l) => l.id == _selectedListId);
    } catch (_) {
      return _lists.isNotEmpty ? _lists.first : null;
    }
  }

  void _openSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a1a2e),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => _buildSettingsSheet(setSheetState),
      ),
    );
  }

  Widget _buildSettingsSheet(StateSetter setSheetState) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ListView(
        shrinkWrap: true,
        children: [
          // --- Background section ---
          const Text(
            'Фон',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickBackground(setSheetState),
                  icon: const Icon(Icons.image, color: Colors.white70),
                  label: const Text(
                    'Выбрать изображение',
                    style: TextStyle(color: Colors.white70),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () => _clearBackground(setSheetState),
                icon: const Icon(Icons.refresh, color: Colors.white54),
                label: const Text(
                  'Сброс',
                  style: TextStyle(color: Colors.white54),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white24),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white12),
          const SizedBox(height: 12),

          // --- List management section ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Списки',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white70, size: 20),
                onPressed: () => _addNewList(setSheetState),
              ),
            ],
          ),
          if (_lists.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Нет списков',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54),
              ),
            )
          else
            ..._lists.map((list) => _buildListTile(list, setSheetState)),
        ],
      ),
    );
  }

  Future<void> _pickBackground(StateSetter setSheetState) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      await StorageService.saveBackgroundPath(picked.path);
      setSheetState(() {});
      setState(() {});
    }
  }

  Future<void> _clearBackground(StateSetter setSheetState) async {
    await StorageService.saveBackgroundPath(null);
    setSheetState(() {});
    setState(() {});
  }

  void _addNewList(StateSetter setSheetState) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Новый список'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Название списка'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                final newList = ForceList(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: controller.text,
                  words: List.generate(100, (i) => 'Слово ${i + 1}'),
                );
                setSheetState(() => _lists.add(newList));
                _saveChanges();
                Navigator.pop(ctx);
              }
            },
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }

  void _editList(ForceList list, StateSetter setSheetState) {
    final nameController = TextEditingController(text: list.name);
    final wordsController = TextEditingController(
      text: list.words.join('\n'),
    );
    final forcedWordController = TextEditingController(text: list.forcedWord);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Редактировать: ${list.name}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Название'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: forcedWordController,
                decoration: const InputDecoration(
                  labelText: 'Форсируемое слово',
                  hintText: 'Введите слово для отображения',
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Слова (каждое с новой строки):',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[300],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Сейчас: ${wordsController.text.split('\n').where((w) => w.trim().isNotEmpty).length} слов (нужно 100)',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: wordsController,
                maxLines: 10,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Слово 1\nСлово 2\nСлово 3',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              final words = wordsController.text
                  .split('\n')
                  .where((w) => w.trim().isNotEmpty)
                  .map((w) => w.trim())
                  .toList();
              setSheetState(() {
                list.name = nameController.text;
                list.forcedWord = forcedWordController.text;
                list.words = words;
              });
              _saveChanges();
              Navigator.pop(ctx);
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void _deleteList(ForceList list, StateSetter setSheetState) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Удалить список?'),
        content: Text('Вы уверены, что хотите удалить "${list.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              setSheetState(() {
                _lists.remove(list);
                if (_selectedListId == list.id) {
                  _selectedListId = _lists.isNotEmpty ? _lists.first.id : null;
                }
              });
              _saveChanges();
              Navigator.pop(ctx);
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _saveChanges() {
    widget.onListsChanged?.call(_lists);
    if (_selectedListId != null) {
      widget.onActiveListChanged?.call(_selectedListId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = _selectedList;
    final bgPath = StorageService.getCachedBackgroundPath();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Заметки'),
        backgroundColor: const Color(0xFF1a1a2e),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white70),
            onPressed: _openSettings,
          ),
        ],
      ),
      backgroundColor: const Color(0xFF0f0f1a),
      body: Column(
        children: [
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
              itemCount: _lists.length,
              itemBuilder: (context, index) {
                final l = _lists[index];
                final isSelected = l.id == _selectedListId;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(l.name),
                    selected: isSelected,
                    selectedColor: const Color(0xFF0088CC),
                    backgroundColor: const Color(0xFF2d2d44),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                    ),
                    onSelected: (selected) {
                      setState(() => _selectedListId = l.id);
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

  Widget _buildListTile(ForceList list, StateSetter setSheetState) {
    final isActive = list.id == _selectedListId;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isActive ? const Color(0xFF2d2d44) : const Color(0xFF1a1a2e),
      child: ListTile(
        dense: true,
        leading: Icon(
          isActive ? Icons.check_circle : Icons.circle_outlined,
          color: isActive ? Colors.green : Colors.white54,
          size: 20,
        ),
        title: Text(
          list.name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          '${list.words.length} слов',
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white54, size: 18),
              onPressed: () => _editList(list, setSheetState),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red, size: 18),
              onPressed: () => _deleteList(list, setSheetState),
            ),
          ],
        ),
        onTap: () {
          setSheetState(() => _selectedListId = list.id);
          _saveChanges();
        },
      ),
    );
  }

  Widget _buildWordsList(ForceList list) {
    return ListView.builder(
      key: PageStorageKey(list.id),
      padding: const EdgeInsets.all(16),
      itemCount: list.words.length,
      itemBuilder: (context, index) {
        final word = list.words[index];
        final position = index + 1;
        final displayWord = list.forcedWord.isNotEmpty &&
                position == _lastSwipeNumber
            ? list.forcedWord
            : word;

        return Container(
          margin: const EdgeInsets.only(bottom: 4),
          child: ListTile(
            dense: true,
            title: Text(
              '$position. $displayWord',
              style: const TextStyle(color: Colors.white, fontSize: 16),
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
          Icon(Icons.note_add, color: Colors.white24, size: 64),
          SizedBox(height: 16),
          Text(
            'Выберите список\nдля просмотра',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 16),
          ),
        ],
      ),
    );
  }
}