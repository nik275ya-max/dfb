import 'dart:convert';

class ForceList {
  final String id;
  String name;
  List<String> words;
  String forcedWord;

  ForceList({
    required this.id,
    required this.name,
    required this.words,
    this.forcedWord = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'words': words,
        'forcedWord': forcedWord,
      };

  factory ForceList.fromJson(Map<String, dynamic> json) => ForceList(
        id: json['id'] as String,
        name: json['name'] as String,
        words: List<String>.from(json['words'] as List),
        forcedWord: json['forcedWord'] as String? ?? '',
      );

  String encode() => jsonEncode(toJson());

  static ForceList decode(String json) =>
      ForceList.fromJson(jsonDecode(json) as Map<String, dynamic>);

  String getWord(int position) {
    if (words.isEmpty || position < 1) return '—';
    return words[(position - 1) % words.length];
  }

  int get length => words.length;
}
