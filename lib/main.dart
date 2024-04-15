import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/Notes.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotesProvider(),
      child: MaterialApp(
        onGenerateRoute: (settings) {
          if (settings.name == '/') {
            return MaterialPageRoute(builder: (context) => HomeScreen());
          } else if (settings.name == '/add') {
            return MaterialPageRoute(builder: (context) => AddNoteScreen());
          }
        },
        initialRoute: '/',
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Заметки'),
        backgroundColor: Color.fromARGB(255, 188, 225, 167),
      ),
      body: ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final movedNote = notesProvider.notes.removeAt(oldIndex);
          notesProvider.notes.insert(newIndex, movedNote);
        },
        children: notesProvider.notes
            .map(
              (note) => Dismissible(
                key: ValueKey(note.id),
                background: Container(
                  color: Colors.red,
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  notesProvider.deleteNote(note.id);
                },
                child: ListTile(
                    visualDensity: VisualDensity.comfortable,
                    title: _buildNote(context, note.text, note.id),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditNoteScreen(note: note),
                        ),
                      );
                    },
                    trailing: Wrap(// space between two icons
                        children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditNoteScreen(note: note),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: RawMaterialButton(
                          onPressed: () {
                            notesProvider.deleteNote(note.id);
                          },
                          shape: const CircleBorder(),
                          child: const Icon(
                            Icons.delete,
                          ),
                        ),
                      )
                    ])),
              ),
            )
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/add');
        },
        backgroundColor: Color.fromRGBO(100, 176, 110, 55),
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddNoteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Note? note = ModalRoute.of(context)?.settings.arguments as Note?;
    final textController = TextEditingController(text: note?.text);

    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить Заметку'),
        backgroundColor: Color.fromARGB(255, 188, 225, 167),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
                controller: textController,
                decoration: InputDecoration(labelText: 'Текст заметки'),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(15),
                ]),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 124, 100, 98)),
              ),
              onPressed: () {
                final text = textController.text;
                if (note == null) {
                  Provider.of<NotesProvider>(context, listen: false)
                      .addNote(text);
                } else {
                  Provider.of<NotesProvider>(context, listen: false)
                      .updateNote(note.id, text);
                }
                Navigator.of(context).pop();
              },
              child: Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildNote(BuildContext context, String text, String id) {
  final notesProvider = Provider.of<NotesProvider>(context);

  return Container(
    decoration: const BoxDecoration(
        color: Color.fromARGB(58, 91, 109, 81),
        borderRadius: BorderRadius.all(Radius.circular(40))),
    height: 100,
    child: (Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          textAlign: TextAlign.left,
        ),
      ],
    )),
  );
}

class NotesProvider extends ChangeNotifier {
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  void addNote(String text) {
    final newNote = Note(DateTime.now().toString(), text);
    _notes.add(newNote);
    notifyListeners();
  }

  void updateNote(String id, String newText) {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      _notes[index].text = newText;
      notifyListeners();
    }
  }

  void deleteNote(String id) {
    _notes.removeWhere((note) => note.id == id);
    notifyListeners();
  }
}

class EditNoteScreen extends StatefulWidget {
  final Note note;

  EditNoteScreen({required this.note});

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.note.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 188, 225, 167),
        title: Text('Редактировать Заметку'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
                controller: _textController,
                decoration: InputDecoration(labelText: 'Текст заметки'),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(20),
                ]),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 124, 100, 98)),
              ),
              onPressed: () {
                final text = _textController.text;
                Provider.of<NotesProvider>(context, listen: false)
                    .updateNote(widget.note.id, text);
                Navigator.of(context).pop();
              },
              child: Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
