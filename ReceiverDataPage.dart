// ignore_for_file: file_names
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:water_sampler/styles.dart';

class ReceiverDataPage extends StatefulWidget {
  final BluetoothDevice? server;
  const ReceiverDataPage({Key? key, this.server}) : super(key: key);

  @override
  _ReceiverDataPage createState() => _ReceiverDataPage();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ReceiverDataPage extends State<ReceiverDataPage> {
  static const clientID = 0;
  BluetoothConnection? connection;
  String? language;
  String? dataReceive;

  // ignore: deprecated_member_use
  List<_Message> messages = <_Message>[];
  String _messageBuffer = '';

  final TextEditingController inputanNumber = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  bool isConnecting = true;
  bool get isConnected => connection != null && connection!.isConnected;

  bool isDisconnecting = false;
  bool buttonClicado = false;
  bool? isOpened = false;

  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server!.address).then((_connection) {
      print('Connected to device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      // connection!.input!.listen(_onDataReceived).onDone(() {
      //   if (isDisconnecting) {
      //     print('Disconnected localy!');
      //   } else {
      //     print('Disconnected remote!');
      //   }
      //   if (mounted) {
      //     setState(() {});
      //   }
      // });
    }).catchError((error) {
      print('Failed to connect, something is wrong!');
      print(error);
    });
  }

  @override
  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      connection!.dispose();
      connection = null;
    }

    super.dispose();
  }

  void _startListening() {
    setState(() {
      connection!.input!.listen((Uint8List data) {
        String message = utf8.decode(data);
        print('Received message: $message');
        dataReceive = message;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    messages.map((_message) {
      return Row(
        children: <Widget>[
          Container(
            child: Text(
                (text) {
                  return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
                }(_message.text.trim()),
                style: const TextStyle(color: Colors.white)),
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            width: 222.0,
            decoration: BoxDecoration(
                color:
                    _message.whom == clientID ? Colors.blueAccent : Colors.grey,
                borderRadius: BorderRadius.circular(7.0)),
          ),
        ],
        mainAxisAlignment: _message.whom == clientID
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
      );
    }).toList();

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          children: [
            const Text("test"),
            dataContainer(size),
            listFile(size),
            InkWell(
              onTap: () {
                _startListening();
              },
              child: downloadData(size),
            ),
            hapusSemuaFile(size)
          ],
        ),
      ),
    );
  }

  Widget dataContainer(dynamic size) {
    return Container(
      width: size.width,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColor.cardPrimary,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          width: 2.0, 
          style: BorderStyle.solid, 
        ),
      ),
      child: Column(
        children: [
          Text(
            "",
            style: AppTextStyle.primary.copyWith(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget listFile(dynamic size) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: AppColor.cardPrimary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          // Ubah warna sesuai kebutuhan Anda
          width: 2.0, // Ubah ketebalan sesuai kebutuhan Anda
          style: BorderStyle.solid, // Ubah jenis garis sesuai kebutuhan Anda
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "List file",
            style: AppTextStyle.primary.copyWith(
              fontSize: 18,
            ),
          ),
          const Icon(Icons.menu),
        ],
      ),
    );
  }

  Widget downloadData(dynamic size) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: AppColor.cardPrimary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 2.0, // Ubah ketebalan sesuai kebutuhan Anda
          style: BorderStyle.solid, // Ubah jenis garis sesuai kebutuhan Anda
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Download Data",
            style: AppTextStyle.primary.copyWith(
              fontSize: 18,
            ),
          ),
          const Icon(Icons.download),
        ],
      ),
    );
  }

  Widget hapusSemuaFile(dynamic size) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: AppColor.cardPrimary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 2.0, 
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Hapus semua file",
            style: AppTextStyle.primary.copyWith(
              fontSize: 18,
            ),
          ),
          const Icon(Icons.delete_forever_outlined),
        ],
      ),
    );
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    for (var byte in data) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    }
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                    0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }
}
