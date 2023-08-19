import 'package:flutter/cupertino.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class StatusConectionProvider extends ChangeNotifier {
  BluetoothDevice? device;

  BluetoothDevice? get getDevice => device;

  setDevice(BluetoothDevice? deviceReceived) {
    device = deviceReceived;
  }
}
