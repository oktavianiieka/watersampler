import 'package:flutter/material.dart'
    show BuildContext, MaterialApp, StatelessWidget, Widget, runApp;
import 'package:flutter/src/foundation/key.dart';
import 'package:provider/provider.dart';
import 'package:water_sampler/BotolNiskinPage.dart';
import 'package:water_sampler/BotolSensorPage.dart';
import 'package:water_sampler/SelectBluetoothDevice.dart';
import 'package:water_sampler/how_to_use.dart';
import 'package:water_sampler/main_page.dart';

import 'provider/StatusConnectionProvider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<StatusConectionProvider>.value(
            value: StatusConectionProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Watersampler',
        initialRoute: '/main',
        routes: {
          '/botolNiskin': (context) => const BotolNiskinPage(),
          '/botolSensor': (context) => const BotolSensorPage(),
          '/main': (context) => const MainPage(),
          '/howToUse': (context) => const HowToUsePage(),
          '/selectDevice': (context) => const SelectBluetoothDevice(),
        },
      ),
    );
  }
}
