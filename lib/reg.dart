import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegPage extends StatefulWidget {
  @override
  RegPageState createState() {
    return new RegPageState();
  }
}



class RegPageState extends State<RegPage> {
  final TextEditingController _FIOController = TextEditingController();
  final TextEditingController _DateOfBirthController = TextEditingController();
  bool _validateFIO = false;
  bool _validateDateOfBirth = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Регистрация'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _FIOController,
              decoration: InputDecoration(
                labelText: 'ФИО',
                errorText: _validateFIO ? "ФИО не может быть пустым" : null,
              ),
            ),
            TextField(
              controller: _DateOfBirthController,
              decoration: InputDecoration(
                labelText: 'Дата рождения',
                errorText: _validateDateOfBirth
                    ? "Дата рождения не может быть пустой"
                    : null,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Есть аккаунт'),
            ),
            ElevatedButton(
              onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
                setState(() {
                  _validateFIO = _FIOController.text.isEmpty;
                  _validateDateOfBirth = _DateOfBirthController.text.isEmpty;

                  if (_validateFIO != true && _validateDateOfBirth != true) {
                    prefs.setString('FIO', _FIOController.text);
                    prefs.setString('DateOfBirth', _DateOfBirthController.text);
                    Navigator.of(context).pop();
                  }
                });
              },
              child: Text('Регистрация'),
            ),
          ],
        ),
      ),
    );
  }
}
