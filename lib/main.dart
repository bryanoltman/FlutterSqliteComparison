import 'package:flutter/material.dart';
import 'package:sql_timing/database_manager.dart';

import 'models.dart';

const numRows = 10000;

final jobs = [
  Job(1, 'SWE', 'Writing code'),
  Job(2, 'Manager', 'Managing'),
  Job(3, 'Director', 'Managing managers'),
  Job(4, 'CEO', 'Managing managing managers'),
];

Future<void> profileDatabase(DatabaseManager db) async {
  await db.setUpDatabase();
  for (final job in jobs) {
    await db.insertJob(job);
  }
  final directors = [for (var i = 0; i < numRows; i++) i]
      .map((i) => Employee(null, 'Director $i', jobs[2]))
      .toList();

  print('inserting $numRows employees...');
  var stopwatch = Stopwatch()..start();
  for (final director in directors) {
    await db.insertEmployee(director);
  }
  stopwatch.stop();
  print('Finished insertion in ${stopwatch.elapsed}');

  print('selecting $numRows employees...');
  stopwatch = Stopwatch()..start();
  final employees = await db.allEmployees();
  stopwatch.stop();
  print('Finished selection in ${stopwatch.elapsed}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('profiling sqflite');
  await profileDatabase(SqfliteDatabaseManager());
  print('done profiling sqflite');

  print('profiling sqlite3');
  await profileDatabase(Sqlite3DatabaseManager());
  print('done profiling sqlite3');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
