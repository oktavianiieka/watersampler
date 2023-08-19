// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';
import 'package:water_sampler/BotolNiskinPage.dart';
import 'package:water_sampler/BotolSensorPage.dart';
import 'package:water_sampler/ListaBluetooth.dart';
import 'package:water_sampler/provider/StatusConnectionProvider.dart';
import 'package:water_sampler/styles.dart';

import 'components/custom_appbar.dart';

class SelectBluetoothDevice extends StatefulWidget {
  final bool checkAvailability;
  final bool? isSensor;

  const SelectBluetoothDevice(
      {Key? key, this.checkAvailability = true, this.isSensor})
      : super(key: key);

  @override
  _SelectBluetoothDevice createState() => _SelectBluetoothDevice();
}

enum _DeviceAvailability {
  maybe,
  yes,
}

class _DeviceWithAvailability extends BluetoothDevice {
  BluetoothDevice? device;
  _DeviceAvailability? availability;
  int? rssi;

  _DeviceWithAvailability(this.device, this.availability)
      : super(address: device!.address);
}

class _SelectBluetoothDevice extends State<SelectBluetoothDevice> {
  List<_DeviceWithAvailability> devices = <_DeviceWithAvailability>[];

  // Availability
  StreamSubscription<BluetoothDiscoveryResult>? _discoveryStreamSubscription;
  bool? _isDiscovering;

  _SelectBluetoothDevice();

  @override
  void initState() {
    super.initState();

    _isDiscovering = widget.checkAvailability;

    if (_isDiscovering!) {
      _startDiscovery();
    }

    // Setup a list of the bonded devices
    FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((List<BluetoothDevice> bondedDevices) {
      setState(() {
        devices = bondedDevices
            .map(
              (device) => _DeviceWithAvailability(
                device,
                widget.checkAvailability
                    ? _DeviceAvailability.maybe
                    : _DeviceAvailability.yes,
              ),
            )
            .toList();
      });
    });
  }

  void _startDiscovery() {
    _discoveryStreamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        Iterator i = devices.iterator;
        while (i.moveNext()) {
          var _device = i.current;
          if (_device.device == r.device) {
            _device.availability = _DeviceAvailability.yes;
            _device.rssi = r.rssi;
          }
        }
      });
    });

    _discoveryStreamSubscription!.onDone(() {
      setState(() {
        _isDiscovering = false;
      });
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery
    _discoveryStreamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    List<ListaBluetoothPage> list = devices
        .map(
          (_device) => ListaBluetoothPage(
            device: _device.device,
            onTap: () {
              Provider.of<StatusConectionProvider>(context, listen: false)
                  .setDevice(_device.device!);
              widget.isSensor!
                  ? Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        settings: const RouteSettings(name: '/botolSensor'),
                        builder: (context) => const BotolSensorPage(),
                      ),
                    )
                  : Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        settings: const RouteSettings(name: '/botolNiskin'),
                        builder: (context) => const BotolNiskinPage(),
                      ),
                    );
            },
          ),
        )
        .toList();
    return Scaffold(
      appBar: CustomAppBar(
        title: "BLUETOOTH",
        titleStyle: AppTextStyle.primary.copyWith(
          fontSize: 20,
        ),
        backgroundColor: AppColor.cardPrimary,
        useLeading: true,
        iconColor: AppColor.primary,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
          child: Column(
            children: [
              headerListBluetooth(size),
              ListView(
                shrinkWrap: true,
                children: list,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget headerListBluetooth(dynamic size) {
    return Column(
      children: [
        SizedBox(
          height: size.width * 0.04,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.bluetooth,
                        color: AppColor.primary,
                        size: 35,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Bluetooth",
                        style: AppTextStyle.primary.copyWith(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  // GFToggle(
                  //   onChanged: (val) async => toggleSwitch(val!),
                  //   value: isSwitched!,
                  //   enabledThumbColor: AppColor.secondary,
                  //   enabledTrackColor: AppColor.primary,
                  //   type: GFToggleType.ios,
                  // )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Divider(
                thickness: 3,
                color: AppColor.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
