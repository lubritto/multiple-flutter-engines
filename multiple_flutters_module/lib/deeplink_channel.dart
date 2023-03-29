import 'package:flutter/services.dart';

abstract class RouteHandler {
  bool canOpen(String deeplink);
}

class MockedRouteHandler implements RouteHandler {
  @override
  bool canOpen(String deeplink) {
    print('flutter: MockedRouteHandler.canOpen($deeplink)');
    return true;
  }
}

class DeeplinkChannel {
  static DeeplinkChannel? _instance;
  static const MethodChannel channel = MethodChannel('deeplink-navigation');

  factory DeeplinkChannel(RouteHandler routeHandler) {
    return _instance ?? DeeplinkChannel._(routeHandler);
  }

  DeeplinkChannel._(this.routeHandler) {
    channel.setMethodCallHandler((call) async {
      print('flutter: DeeplinkChannel.setMethodCallHandler');
      if (call.method == 'canOpenDeeplink') {
        return routeHandler.canOpen(call.arguments.toString());
      } else {
        throw Exception('flutter: not implemented ${call.method}');
      }
    });
  }

  RouteHandler routeHandler;

  static Future navigate() async {
    return await channel.invokeMethod<dynamic>('navigate');
  }
}
