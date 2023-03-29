import 'package:data_sync_engines/src/data_sync_channel.dart';
import 'package:flutter/services.dart';

class DataSyncEventChannel {
  static DataSyncEventChannel? _instance;
  static const channel = EventChannel('data-sync-event');

  final Map<String, DataSyncHandler> handlers;

  factory DataSyncEventChannel({required List<DataSyncHandler> handlers}) {
    return _instance ??
        DataSyncEventChannel._(
          Map.fromEntries(handlers.map((e) => MapEntry(e.name, e))),
        );
  }

  DataSyncEventChannel._(this.handlers) {
    channel.receiveBroadcastStream().listen(
      (arguments) async {
        final args = arguments as Map<dynamic, dynamic>;
        if (handlers.containsKey(args.entries.first.key)) {
          return await handlers[args.entries.first.key]!.handle(
            args.entries.first.value,
          );
        } else {
          throw Exception('flutter: not implemented ${args.entries.first.key}');
        }
      },
    );
  }
}
