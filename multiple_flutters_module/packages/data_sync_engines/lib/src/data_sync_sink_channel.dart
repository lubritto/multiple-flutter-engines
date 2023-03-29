import 'package:flutter/services.dart';

class DataSyncSinkChannel {
  static const channel = MethodChannel('data-sync-event-sink');

  static Future<T?> call<T>(String method, [dynamic arguments]) async {
    return await channel.invokeMethod<T>(method, arguments);
  }
}
