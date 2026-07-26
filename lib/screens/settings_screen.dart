import 'package:flutter/material.dart';
import '../models/force_list.dart';

class SettingsScreen extends StatefulWidget {
  final List<ForceList> lists;
  final String? activeListId;
  final Function(List<ForceList>) onListsChanged;
  final Function(String) onActiveListChanged;

  const SettingsScreen({
    super.key,
    required this.lists,
    required this.activeListId,
    required this.onListsChanged,
    required this.onActiveListChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late List<ForceList> _lists;
  String? _activeListId;

  @override
  void initState() {
    super.initState();
    _lists = List.from(widget.lists);
    _activeListId = widget.activeListId;
  }

  @override
  void didUpdateWidget(SettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lists != widget.lists) {
      _lists = List.from(widget.lists);
    }
    if (oldWidget.activeListId != widget.activeListId) {
      _activeListId = widget.activeListId;
    }
  }

  void _saveChanges() {
    widget.onListsChanged(_lists);
    if (_activeListId != null) {
      widget.onActiveListChanged(_activeListId!);
    }
  }

  void _addNewList() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Новый список'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Название списка',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  final newList = ForceList(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: controller.text,
                    words: List.generate(100, (i) => 'Слово ${i + 1}'),
                  );
                  _lists.add(newList);
                });
                _saveChanges();
                Navigator.pop(context);
              }
            },
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }

  void _editList(ForceList list) {
    final nameController = TextEditingController(text: list.name);
    final wordsController = TextEditingController(
      text: list.words.join('\n'),
    );
    final forcedWordController = TextEditingController(text: list.forcedWord);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Редактировать: ${list.name}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Название',
                ),
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
              const Text(
                'Слова (каждое с новой строки):',
                style: TextStyle(fontWeight: FontWeight.bold),
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
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              final words = wordsController.text
                  .split('\n')
                  .where((w) => w.trim().isNotEmpty)
                  .map((w) => w.trim())
                  .toList();
              if (words.length < 100) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Список содержит ${words.length} слов. '
                      'Для корректной работы нужно 100 слов.',
                    ),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
              setState(() {
                list.name = nameController.text;
                list.forcedWord = forcedWordController.text;
                list.words = words;
              });
              _saveChanges();
              Navigator.pop(context);
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void _deleteList(ForceList list) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить список?'),
        content: Text('Вы уверены, что хотите удалить "${list.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _lists.remove(list);
                if (_activeListId == list.id) {
                  _activeListId = _lists.isNotEmpty ? _lists.first.id : null;
                }
              });
              _saveChanges();
              Navigator.pop(context);
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки DFB'),
        backgroundColor: const Color(0xFF1a1a2e),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFF0f0f1a),
      body: _lists.isEmpty
          ? const Center(
              child: Text(
                'Нет списков.\nНажмите + чтобы создать.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _lists.length,
              itemBuilder: (context, index) {
                final list = _lists[index];
                final isActive = list.id == _activeListId;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: isActive
                      ? const Color(0xFF2d2d44)
                      : const Color(0xFF1a1a2e),
                  child: ListTile(
                    leading: Icon(
                      isActive ? Icons.check_circle : Icons.circle_outlined,
                      color: isActive ? Colors.green : Colors.white54,
                    ),
                    title: Text(
                      list.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight:
                            isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      '${list.length} слов',
                      style: const TextStyle(color: Colors.white54),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white54),
                          onPressed: () => _editList(list),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteList(list),
                        ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        _activeListId = list.id;
                      });
                      _saveChanges();
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewList,
        backgroundColor: const Color(0xFF0088CC),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
