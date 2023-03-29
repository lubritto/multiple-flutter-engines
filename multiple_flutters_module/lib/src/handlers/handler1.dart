import 'dart:async';

import 'package:data_sync_engines/data_sync_engines.dart';

class Handler1 implements DataSyncHandler {
  static int numberOfTaps = 0;

  @override
  String get name => 'test';

  @override
  Future handle(dynamic arguments) async {
    numberOfTaps++;
    await DataSyncSinkChannel.call<dynamic>('handler1', numberOfTaps);
    return numberOfTaps;
  }
}

class StreamHandler1 implements DataSyncHandler {
  static final numberOfTapsStreamController = StreamController<int>();
  static StreamSink<int> get sink => numberOfTapsStreamController.sink;
  static Stream<int> get stream => numberOfTapsStreamController.stream;

  @override
  String get name => 'handler1';

  @override
  Future handle(dynamic arguments) async {
    numberOfTapsStreamController.sink.add(arguments as int);
  }

  void dispose() {
    sink.close();
  }
}
