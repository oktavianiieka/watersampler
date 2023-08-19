import 'package:flutter/material.dart';
import 'package:water_sampler/components/custom_appbar.dart';
import 'package:water_sampler/styles.dart';

class HowToUsePage extends StatelessWidget {
  const HowToUsePage({Key? key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: CustomAppBar(
        backgroundColor: AppColor.secondary,
        title: "",
        useLeading: true,
        elevation: 0,
        iconColor: AppColor.primary,
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Langkah - Langkah\nPenggunaan",
            style: AppTextStyle.primary.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          howToUseBotolNiskin(size),
          howToUseBotolSensor(size),
        ],
      )),
    );
  }

  Widget howToUseBotolNiskin(dynamic size) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: size.height * 0.02,
              ),
              Text(
                "How To Use Botol Niskin",
                style: AppTextStyle.primary.copyWith(
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Image.asset(
                'assets/howtousebotolniskin.jpg',
                fit: BoxFit.cover,
              ),
            ],
          ),
        ));
  }

  Widget howToUseBotolSensor(dynamic size) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: size.height * 0.02,
              ),
              Text(
                "How To Use Botol Sensor",
                style: AppTextStyle.primary.copyWith(
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Image.asset(
                'assets/howtousebotolsensor.jpg',
                fit: BoxFit.cover,
              ),
            ],
          ),
        ));
  }
}
