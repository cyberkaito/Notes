import 'package:flutter/material.dart';
import 'package:prakt5/models/note.dart';
import 'package:prakt5/models/theme_model.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:prakt5/add.dart';
import 'package:prakt5/edit.dart';
import 'package:prakt5/auth.dart';
import 'package:prakt5/reg.dart';
import 'package:prakt5/set.dart';

import 'package:shared_preferences/shared_preferences.dart';

late Box box;

late Note edit;

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  final provider = NoteListProvider();
  runApp(
    ChangeNotifierProvider<NoteListProvider>.value(
      value: provider,
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Consumer(
        builder: (context, ThemeModel themeNotifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeNotifier.isDark ? ThemeData.dark():ThemeData.light(),
            initialRoute: "/auth",
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case "/":
                  return MaterialPageRoute(
                    builder: (context) => MainApp(),
                  );
                case "/add":
                  return MaterialPageRoute(
                    builder: (context) => AddPage(),
                  );
                case "/edit":
                  return MaterialPageRoute(
                    builder: (context) => EditPage(edit),
                  );
                case "/reg": 
                  return MaterialPageRoute(
                    builder: (context) => RegPage(),
                  );
                case "/auth":
                  return MaterialPageRoute(
                    builder: (context) => AuthPage(),
                  );
                case "/set":
                  return MaterialPageRoute(
                    builder: (context) => SetPage(),
                  );
              }
            },
            home: HomePage(),
          );
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Главная"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/set');
              },
              icon: Icon(Icons.settings)),
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/auth');
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Consumer<NoteListProvider>(
        builder: (context, itemList, child) {
          return ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              itemList.reorderItems(oldIndex, newIndex);
            },
            children: itemList.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;

              return ReorderableDelayedDragStartListener(
                index: index,
                key: ValueKey(item),
                child: ListNoteWidget(item.value),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/add');
            },
            child: Icon(Icons.add),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class ListNoteWidget extends StatelessWidget {
  final Note item;

  ListNoteWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        key: ValueKey(item),
        title: Text(item.title),
        subtitle: Text(item.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                edit = item;
                Navigator.of(context).pushNamed("/edit", arguments: item);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                final itemList =
                    Provider.of<NoteListProvider>(context, listen: false);
                itemList.deleteItem(item);
              },
            ),
          ],
        ),
      ),
    );
  }
}
