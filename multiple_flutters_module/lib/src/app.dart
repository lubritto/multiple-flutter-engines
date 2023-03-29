import 'package:flutter/material.dart';
import 'package:multiple_flutters_module/src/screens/screen1.dart';

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/': (_) => Container(color: Colors.yellow),
        '/empty': (_) => Container(color: Colors.transparent),
        '/screen1': (_) => Screen1(),
        'test': (_) => Container(color: Colors.red),
      },
    );
  }
}
