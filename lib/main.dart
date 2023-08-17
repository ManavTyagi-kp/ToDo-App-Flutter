import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/pages/NavigatonBar.dart';
import 'package:to_do_list/pages/list-view.dart';
import 'package:to_do_list/pages/list.dart';
import 'package:to_do_list/pages/swapableList.dart';
import 'package:to_do_list/pages/timerList.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const MyHomePage(
        title: 'TODO List',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 19, 18, 18),
        title: Text(
          widget.title,
          style: const TextStyle(
              color: Color.fromARGB(255, 228, 221, 221),
              fontWeight: FontWeight.bold),
        ),
      ),
      // body: ListViewer(),
      // body: MyList(),
      // body: ListViewerSwap(),
      // body: ListViewerTimer(),
      body: const BottomNav(),
    );
  }
}
