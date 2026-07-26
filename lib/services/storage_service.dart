import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/force_list.dart';

class StorageService {
  static const String _listsKey = 'force_lists';
  static const String _activeListIdKey = 'active_list_id';

  static int? _cachedLastSwipeNumber;

  static Future<List<ForceList>> loadLists() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_listsKey);
    if (jsonString == null) return _defaultLists();

    final List<dynamic> jsonList = jsonDecode(jsonString);
    final loaded = jsonList.map((j) => ForceList.fromJson(j)).toList();

    // Подставляем дефолтные forcedWord для списков без него
    final defaults = _defaultLists();
    bool changed = false;
    for (final list in loaded) {
      if (list.forcedWord.isEmpty) {
        try {
          final def = defaults.firstWhere((d) => d.id == list.id);
          list.forcedWord = def.forcedWord;
          changed = true;
        } catch (_) {}
      }
    }
    if (changed) await saveLists(loaded);

    return loaded;
  }

  static Future<void> saveLists(List<ForceList> lists) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(lists.map((l) => l.toJson()).toList());
    await prefs.setString(_listsKey, jsonString);
  }

  static Future<String?> loadActiveListId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeListIdKey);
  }

  static Future<void> saveActiveListId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeListIdKey, id);
  }

  static Future<void> saveLastSwipeNumber(int number) async {
    _cachedLastSwipeNumber = number;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_swipe_number', number);
  }

  static int? getLastSwipeNumberSync() {
    return _cachedLastSwipeNumber;
  }

  static Future<int?> loadLastSwipeNumber() async {
    if (_cachedLastSwipeNumber != null) return _cachedLastSwipeNumber;
    final prefs = await SharedPreferences.getInstance();
    _cachedLastSwipeNumber = prefs.getInt('last_swipe_number');
    return _cachedLastSwipeNumber;
  }

  static List<ForceList> _defaultLists() {
    return [
      ForceList(
        id: 'animals',
        name: 'Животные',
        words: [
          'Кот', 'Собака', 'Лошадь', 'Корова', 'Свинья',
          'Курица', 'Утка', 'Коза', 'Овца', 'Кролик',
          'Лев', 'Тигр', 'Медведь', 'Волк', 'Лиса',
          'Заяц', 'Еж', 'Белка', 'Ёж', 'Мышь',
          'Слон', 'Носорог', 'Жираф', 'Зебра', 'Обезьяна',
          'Дельфин', 'Кит', 'Акула', 'Черепаха', 'Крокодил',
          'Орёл', 'Ворона', 'Голубь', 'Сова', 'Павлин',
          'Рыба', 'Лягушка', 'Змея', 'Паук', 'Бабочка',
          'Жук', 'Муравей', 'Пчела', 'Оса', 'Стрекоза',
          'Улитка', 'Червь', 'Креветка', 'Краб', 'Осьминог',
          'Бегемот', 'Бизон', 'Лама', 'Аллигатор', 'Кенгуру',
          'Панда', 'Коала', 'Сурикат', 'Енот', 'Выдра',
          'Верблюд', 'Олень', 'Лось', 'Кабан', 'Барсук',
          'Сова', 'Фламинго', 'Пеликан', 'Гриф', 'Ястреб',
          'Ласточка', 'Синица', 'Воробей', 'Кукушка', 'Дятел',
          'Угорь', 'Сом', 'Щука', 'Окунь', 'Карась',
          'Полоск', 'Дракон', 'Феникс', 'Единорог', 'Грифон',
          'Дракон', 'Тролль', 'Гном', 'Эльф', 'Орк',
          'Вампир', 'Оборотень', 'Зомби', 'Призрак', 'Привидение',
          'Робот', 'Алмаз', 'Звезда', 'Луна', 'Солнце',
        ],
        forcedWord: 'ФОРС',
      ),
      ForceList(
        id: 'cities',
        name: 'Города',
        words: [
          'Москва', 'Питер', 'Казань', 'Новосибирск', 'Екатеринбург',
          'Нижний Новгород', 'Красноярск', 'Самара', 'Омск', 'Ростов',
          'Уфа', 'Краснодар', 'Челябинск', 'Тюмень', 'Саратов',
          'Волгоград', 'Тольятти', 'Ижевск', 'Барнаул', 'Иркутск',
          'Хабаровск', 'Владивосток', 'Махачкала', 'Томск', 'Оренбург',
          'Кемерово', 'Новокузнецк', 'Рязань', 'Астрахань', 'Набережные Челны',
          'Пенза', 'Липецк', 'Калининград', 'Тула', 'Киров',
          'Сочи', 'Пермь', 'Брянск', 'Мурманск', 'Сургут',
          'Владимир', 'Смоленск', 'Воронеж', 'Самара', 'Ярославль',
          'Тверь', 'Магнитогорск', 'Саратов', 'Вологда', 'Курск',
          'Санкт-Петербург', 'Киев', 'Минск', 'Алматы', 'Тбилиси',
          'Баку', 'Ереван', 'Душанбе', 'Бишкек', 'Ашхабад',
          'Рига', 'Вильнюс', 'Таллин', 'Хельсинки', 'Стокгольм',
          'Осло', 'Копенгаген', 'Варшава', 'Прага', 'Будапешт',
          'Бухарест', 'София', 'Белград', 'Загреб', 'Любляна',
          'Братислава', 'Вена', 'Берлин', 'Мюнхен', 'Гамбург',
          'Франкфурт', 'Кёльн', 'Дюссельдорф', 'Штутгарт', 'Дрезден',
          'Париж', 'Лyon', 'Марсель', 'Тулуза', 'Бордо',
          'Лондон', 'Манчестер', 'Бирмингем', 'Ливерпуль', 'Эдинбург',
          'Рим', 'Милан', 'Неаполь', 'Турин', 'Флоренция',
        ],
        forcedWord: 'ГОРОД',
      ),
      ForceList(
        id: 'professions',
        name: 'Профессии',
        words: [
          'Программист', 'Врач', 'Учитель', 'Инженер', 'Адвокат',
          'Продавец', 'Водитель', 'Повар', 'Полицейский', 'Пожарный',
          'Сварщик', 'Электрик', 'Плотник', 'Маляр', 'Сантехник',
          'Архитектор', 'Дизайнер', 'Журналист', 'Писатель', 'Актёр',
          'Режиссёр', 'Музыкант', 'Певец', 'Танцор', 'Художник',
          'Фотограф', 'Журналист', 'Репортёр', 'Ведущий', 'Диктор',
          'Бухгалтер', 'Аудитор', 'Экономист', 'Финансист', 'Менеджер',
          'Директор', 'Руководитель', 'Начальник', 'Продюсер', 'Координатор',
          'Психолог', 'Социолог', 'Философ', 'Историк', 'Лингвист',
          'Переводчик', 'Учёный', 'Исследователь', 'Лаборант', 'Аналитик',
          'Химик', 'Физик', 'Математик', 'Биолог', 'Географ',
          'Эколог', 'Геолог', 'Агроном', 'Зоолог', 'Ботаник',
          'Ветеринар', 'Фермер', 'Агроном', 'Садовод', 'Огородник',
          'Строитель', 'Штукатур', 'Каменщик', 'Кровельщик', 'Монтажник',
          'Крановщик', 'Экскаваторщик', 'Бульдозерист', 'Тракторист', 'Комбайнёр',
          'Лётчик', 'Пилот', 'Штурман', 'Диспетчер', 'Космонавт',
          'Моряк', 'Капитан', 'Матрос', 'Лоцман', 'Шкипер',
          'Военный', 'Солдат', 'Офицер', 'Генерал', 'Адмирал',
          'Спортсмен', 'Тренер', 'Судья', 'Арбитр', 'Комментатор',
          'Шеф-повар', 'Кондитер', 'Бармен', 'Официант', 'Хостес',
        ],
        forcedWord: 'ЦЕЛЬ',
      ),
    ];
  }
}
