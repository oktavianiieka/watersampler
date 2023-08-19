// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:water_sampler/ReceiverDataPage.dart';
import 'package:water_sampler/SelectBluetoothDevice.dart';
import 'package:water_sampler/styles.dart';

import 'components/custom_appbar.dart';
import 'provider/StatusConnectionProvider.dart';

class BotolSensorPage extends StatefulWidget {
  const BotolSensorPage({Key? key}) : super(key: key);

  @override
  State<BotolSensorPage> createState() => _BotolSensorPageState();
}

class _BotolSensorPageState extends State<BotolSensorPage> {
  bool? isSwitched = false;

  void toggleSwitch(bool value) async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      isSwitched = value;
    });

    if (isSwitched!) {
      onPress();
    } else {
      Provider.of<StatusConectionProvider>(context, listen: false)
          .setDevice(null);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          settings: const RouteSettings(name: '/botolSensor'),
          builder: (context) => const BotolSensorPage()));
    }
  }

  void onPress() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        settings: const RouteSettings(name: 'selectDevice'),
        builder: (context) => const SelectBluetoothDevice(
              isSensor: true,
            )));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(
        title: "Botol Sensor",
        titleStyle: AppTextStyle.primary.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: AppColor.cardPrimary,
        useLeading: true,
        iconColor: AppColor.primary,
        elevation: 2,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
          child: Consumer<StatusConectionProvider>(
              builder: (context, value, widget) {
            return (value.device == null
                ? Column(
                    children: [blueToothConnection(size, context, false)],
                  )
                : Column(
                    children: [
                      blueToothConnection(size, context, true),
                      ReceiverDataPage(server: value.device),
                    ],
                  ));
          }),
        ),
      ),
    );
  }

  Widget blueToothConnection(dynamic size, BuildContext context, bool? state) {
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
                  GFToggle(
                    onChanged: (val) async => toggleSwitch(val!),
                    value: state! ? true : false,
                    enabledThumbColor: AppColor.secondary,
                    enabledTrackColor: AppColor.primary,
                    type: GFToggleType.ios,
                  )
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
