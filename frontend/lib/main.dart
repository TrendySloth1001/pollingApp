import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Backend Hello',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Backend Hello'),
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
  String _message = 'Press the button to say hello!';

  Future<void> _fetchHello() async {
    try {
      String url = 'http://localhost:3000/hello';
      // Android emulator localhost is 10.0.2.2
      // We use a simple check here. For a robust app, use simple logic or kIsWeb from foundation.
      // Trying to import dart:io safely or just check logic.
      // Since this is a simple demo, I'll attempt to catch the error and retry with 10.0.2.2 or simply default to checking platform if possible.
      // However, dart:io is not available on web, so we must be careful if we want this to run on web too.
      // Given the user is likely on emulator now, let's just try the Android IP if localhost fails, or better yet, use a helper.

      if (!kIsWeb && Platform.isAndroid) {
        url = 'http://10.0.2.2:3000/hello';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _message = data['message'];
        });
      } else {
        setState(() {
          _message = 'Failed to load: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _message,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchHello,
        tooltip: 'Say Hello',
        child: const Icon(Icons.message),
      ),
    );
  }
}
