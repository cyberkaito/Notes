import 'package:flutter/material.dart';
import 'package:prakt5/models/note.dart';
import 'package:provider/provider.dart';

class EditPage extends StatelessWidget {
  final Note note;

  EditPage(this.note);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    _titleController.text = note.title;
    _descriptionController.text = note.description;
    return Scaffold(
      appBar: AppBar(
        title: Text('Редактирование записи'),
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
                final itemList =
                    Provider.of<NoteListProvider>(context, listen: false);
                itemList.editItem(
                    note, _titleController.text, _descriptionController.text);
                Navigator.pop(context);
              },
              child: Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}