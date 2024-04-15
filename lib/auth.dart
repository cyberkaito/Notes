import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  @override
  AuthPageState createState() {
    return new AuthPageState();
  }
}

class AuthPageState extends State<AuthPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _validateLogin = false;
  bool _validatePassword = false;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      final login = prefs.getString('login');
      final password = prefs.getString('password');
      if (login != null && password != null && login!.isNotEmpty && password!.isNotEmpty) {
        Navigator.of(context).pushNamed('/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Авторизация'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _loginController,
              decoration: InputDecoration(
                labelText: 'Имя пользователя',
                errorText: _validateLogin
                    ? "Имя пользователя не может быть пустым"
                    : null,
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Пароль',
                errorText:
                    _validatePassword ? "Пароль не может быть пустым" : null,
              ),
            ),
            ElevatedButton(
              child: Text("Нет аккаунта?"),
              onPressed: () {
                Navigator.of(context).pushNamed('/reg');
              },
            ),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                setState(() {
                  _validateLogin = _loginController.text.isEmpty;
                  _validatePassword = _passwordController.text.isEmpty;
                  prefs.setString('login', _loginController.text);
                  prefs.setString('password', _passwordController.text);

                  if (_validateLogin != true && _validatePassword != true) {
                    Navigator.of(context).pushNamed('/');
                  }
                });
              },
              child: Text('Войти'),
            ),
          ],
        ),
      ),
    );
  }
}
