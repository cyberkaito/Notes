import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

part 'note.g.dart';

@HiveType(typeId: 1)
class Note {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  Note({required this.title, required this.description});
}

class NoteNotifier extends ValueNotifier<Note> {
  NoteNotifier(Note value) : super(value);
}

class NoteListProvider with ChangeNotifier {
  late Box<Note> _notesBox;

  List<NoteNotifier> _items = [];

  List<NoteNotifier> get items => _items;

  NoteListProvider() {
    initHive();
  }

  Future<void> initHive() async {
    await Hive.initFlutter();
    _notesBox = await Hive.openBox<Note>('noteBox');
    loadDataFromHive();
  }

  void loadDataFromHive() {
    _items = _notesBox.values.map((item) => NoteNotifier(item)).toList();
    notifyListeners();
  }

  Future<void> addItem(String title, String description) async {
    final newItem = Note(title: title, description: description);
    final myItem = NoteNotifier(newItem);
    await _notesBox.add(newItem);
    _items.add(myItem);
    notifyListeners();
  }

  void editItem(Note note, String newTitle, String newDescription) {
    final index = _items.indexWhere((notifier) => notifier.value == note);
    if (index != -1) {
      final updatedItem = note
        ..title = newTitle
        ..description = newDescription;
      final updatedNotifier = NoteNotifier(updatedItem);
      _items[index] = updatedNotifier;
      _notesBox.putAt(index, updatedItem);
      notifyListeners();
    }
  }

  void deleteItem(Note note) {
    final notifier = _items.firstWhere((notifier) => notifier.value == note);
    final index = _items.indexOf(notifier);

    if (index != -1) {
      _items.removeAt(index);
      _notesBox.deleteAt(index);
      notifyListeners();
    }
  }

  void reorderItems(int oldIndex, int newIndex) {
    if (oldIndex < 0 ||
        oldIndex >= items.length ||
        newIndex < 0 ||
        newIndex >= items.length) {
      return;
    }

    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);

    notifyListeners();
  }
}
