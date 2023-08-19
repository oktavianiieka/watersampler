import 'package:flutter/material.dart';
import 'package:water_sampler/components/custom_appbar.dart';
import 'package:water_sampler/styles.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: CustomAppBar(
        title: "Aplikasi Water Sampler",
        titleStyle: AppTextStyle.primary.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: AppColor.cardPrimary,
        useLeading: true,
        iconColor: AppColor.cardPrimary,
        elevation: 0,
      ),
      body: SafeArea(
          child: SizedBox(
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 50),
                width: size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                          color: AppColor.primary,
                          width: 3.0,
                        )),
                      ),
                      child: Text(
                        "Pilih Pengaturan Botol:",
                        style: AppTextStyle.primary.copyWith(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          child: botolNiskin(size),
                          onTap: () {
                            Navigator.pushNamed(context, '/botolNiskin');
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/botolSensor');
                          },
                          child: botolSensor(size),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          child: howToUseButton(size),
                          onTap: () {
                            Navigator.pushNamed(context, '/howToUse');
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget howToUseButton(dynamic size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.only(
            top: 4,
            bottom: 0,
            left: 0,
            right: 6,
          ),
          width: size.width * 0.35,
          height: size.height * 0.05,
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
              color: AppColor.primary,
              width: 1.0,
            )),
          ),
          child: const ClipRRect(
            child: Padding(
              padding: EdgeInsets.all(9.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'How To Use',
                  ),
                  Icon(Icons.question_mark_outlined),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget botolNiskin(dynamic size) {
    return Container(
      height: 200,
      width: size.width / 2.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColor.primary, // Ubah warna sesuai kebutuhan Anda
          width: 2.0, // Ubah ketebalan sesuai kebutuhan Anda
          style: BorderStyle.solid, // Ubah jenis garis sesuai kebutuhan Anda
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey
                .withOpacity(0.5), // Ubah warna sesuai kebutuhan Anda
            spreadRadius: 2, // Ubah jarak penyebaran sesuai kebutuhan Anda
            blurRadius: 4, // Ubah jarak blur sesuai kebutuhan Anda
            offset: const Offset(
                0, 2), // Ubah posisi bayangan sesuai kebutuhan Anda
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(17),
                  topRight: Radius.circular(17),
                ),
              ),
              width: double.infinity,
              child: Image.asset(
                'assets/niskin.png',
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: const Center(
                child: Text(
                  "Botol Niskin",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              decoration: BoxDecoration(
                color: AppColor.cardPrimary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(17),
                  bottomRight: Radius.circular(17),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget botolSensor(dynamic size) {
    return Container(
      height: 200,
      width: size.width / 2.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColor.primary, // Ubah warna sesuai kebutuhan Anda
          width: 2.0, // Ubah ketebalan sesuai kebutuhan Anda
          style: BorderStyle.solid, // Ubah jenis garis sesuai kebutuhan Anda
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey
                .withOpacity(0.5), // Ubah warna sesuai kebutuhan Anda
            spreadRadius: 2, // Ubah jarak penyebaran sesuai kebutuhan Anda
            blurRadius: 4, // Ubah jarak blur sesuai kebutuhan Anda
            offset: const Offset(
                0, 2), // Ubah posisi bayangan sesuai kebutuhan Anda
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(17),
                  topRight: Radius.circular(17),
                ),
              ),
              width: double.infinity,
              child: Image.asset(
                'assets/BotolSensor.png',
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: const Center(
                child: Text(
                  "Botol Sensor",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              decoration: BoxDecoration(
                color: AppColor.cardPrimary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(17),
                  bottomRight: Radius.circular(17),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
