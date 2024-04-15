import 'package:flutter/material.dart';
import 'package:prakt5/models/theme_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetPage extends StatefulWidget {
  @override
  SetStatePage createState() {
    return new SetStatePage();
  }
}

class Person {
  String? FIO;
  String? Date;

  Person(this.FIO, this.Date);
}

class SetStatePage extends State<SetPage> {
  String? fio;
  String? date;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fio = prefs.getString('FIO') ?? '';
      date = prefs.getString('DateOfBirth') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(builder: (context, themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Настройки'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text("ФИО: $fio"),
              Text("Дата рождения: $date"),
              IconButton(
                onPressed: () {
                  themeNotifier.isDark = !themeNotifier.isDark;
                },
                icon: Icon(themeNotifier.isDark ? Icons.nightlight_round : Icons.wb_sunny),
              ),
            ],
          ),
        ),
      );
    });
  }
}