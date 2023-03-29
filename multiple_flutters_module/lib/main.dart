// Copyright 2021 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:data_sync_engines/data_sync_engines.dart';
import 'package:flutter/material.dart';
import 'package:multiple_flutters_module/deeplink_channel.dart';
import 'package:multiple_flutters_module/src/app.dart';
import 'package:multiple_flutters_module/src/handlers/handler1.dart';

@pragma('vm:entry-point')
void uiLessMain() {
  WidgetsFlutterBinding.ensureInitialized();
  print('flutter: uiLessMain');
  DeeplinkChannel(MockedRouteHandler());
  DataSyncChannel(handlers: [
    Handler1(),
  ]);
}

@pragma('vm:entry-point')
void deeplinkMain() {
  WidgetsFlutterBinding.ensureInitialized();
  print('flutter: deeplinkMain');
  print(
    'initialRoute - ${WidgetsBinding.instance!.window.defaultRouteName}',
  );
  DataSyncEventChannel(handlers: [
    StreamHandler1(),
  ]);

  runApp(const MyApp());
}

@pragma('vm:entry-point')
void main() => runApp(const MyApp());
