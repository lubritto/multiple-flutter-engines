import 'package:flutter/services.dart';

class DataSyncChannel {
  static DataSyncChannel? _instance;
  static const channel = MethodChannel('data-sync');

  final Map<String, DataSyncHandler> handlers;

  factory DataSyncChannel({required List<DataSyncHandler> handlers}) {
    return _instance ??
        DataSyncChannel._(
          Map.fromEntries(handlers.map((e) => MapEntry(e.name, e))),
        );
  }

  DataSyncChannel._(this.handlers) {
    channel.setMethodCallHandler(
      (call) async {
        // ui less engine
        if (handlers.containsKey(call.method)) {
          return await handlers[call.method]!.handle(call.arguments);
        } else {
          throw Exception('flutter: not implemented ${call.method}');
        }
      },
    );
  }

  static Future<T?> call<T>(String method, [dynamic arguments]) async {
    return await channel.invokeMethod<T>(method, arguments);
  }

  static Future x() async {
    final x = await call('jwt', 123);
  }
}

abstract class DataSyncHandler {
  String get name;

  Future handle(dynamic arguments);
}
