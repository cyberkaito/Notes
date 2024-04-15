import 'package:flutter/material.dart';
import 'package:prakt5/models/note.dart';
import 'package:provider/provider.dart';

class AddPage extends StatefulWidget {
  @override
  AddPageState createState() {
    return new AddPageState();
  }
}

class AddPageState extends State<AddPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавление записи'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                errorText:
                    _validate ? "Заголовок не может быть пустым!!!" : null,
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                errorText:
                    _validate ? "Описание не может быть пустым!!!" : null,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _validate = _descriptionController.text.isEmpty &&
                      _titleController.text.isEmpty;
                  if (_validate != true) {
                    final provider =
                        Provider.of<NoteListProvider>(context, listen: false);
                    provider.addItem(
                        _titleController.text, _descriptionController.text);
                    Navigator.of(context).pop();
                  }
                });
              },
              child: Text('Добавить'),
            ),
          ],
        ),
      ),
    );
  }
}