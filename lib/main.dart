import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_reader/helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Read sqflite Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Read sqflite Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Press on button "Open SQLite DB file"',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles();

          if (result != null) {
            File file = File(result.files.single.path!);
            SqlHelper sqlhelper = SqlHelper();
            Database db = await sqlhelper.openDB(file.path);
            // (await db.query('sqlite_master', columns: ['type', 'name']))
            //     .forEach((row) {
            //   print(row.values);
            // });
            List<String> tableNames = (await db.query('sqlite_master',
                    where: 'type = ?', whereArgs: ['table']))
                .map((row) => row['name'] as String)
                .toList(growable: false);
            print(tableNames);
            String table = tableNames.first;
            List<String> columnNames = (await db
                    .rawQuery("SELECT name FROM PRAGMA_TABLE_INFO ('$table')"))
                .map((row) => row['name'] as String)
                .toList(growable: false);
            print(columnNames);

            // await db.rawInsert( 'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)');
          } else {
            print('User canceled the picker');
          }
        },
        tooltip: 'Open SQLite DB file',
        child: const Icon(Icons.file_open),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
