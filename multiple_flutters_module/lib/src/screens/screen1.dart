import 'package:data_sync_engines/data_sync_engines.dart';
import 'package:flutter/material.dart';
import 'package:multiple_flutters_module/deeplink_channel.dart';

import '../handlers/handler1.dart';

class Screen1 extends StatefulWidget {
  const Screen1();

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  final watch = Stopwatch();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Screen 1'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StreamBuilder<int>(
            stream: StreamHandler1.stream,
            builder: (context, snapshot) {
              watch.stop();
              print('time taken - ${watch.elapsed.inMilliseconds}');
              return Text('count - ${snapshot.data ?? 'loading'}');
            },
          ),
          TextButton(
            onPressed: () async {
              await DeeplinkChannel.navigate();
            },
            child: Text('Go to screen 2'),
          ),
          TextButton(
            onPressed: () async {
              await DeeplinkChannel.navigate();
            },
            child: Text('Go to screen 2'),
          ),
          TextButton(
            onPressed: () async {
              watch.reset();
              watch.start();
              await DataSyncChannel.call<int>('test');
            },
            child: Text('Update count'),
          ),
        ],
      ),
    );
  }
}
