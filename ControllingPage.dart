// ignore_for_file: file_names
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:water_sampler/styles.dart';

class ControllingPage extends StatefulWidget {
  final BluetoothDevice? server;
  const ControllingPage({Key? key, this.server}) : super(key: key);

  @override
  _ControllingPage createState() => _ControllingPage();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ControllingPage extends State<ControllingPage> {
  static const clientID = 0;
  BluetoothConnection? connection;
  String? language;

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

      connection!.input!.listen(_onDataReceived).onDone(() {
        if (isDisconnecting) {
          print('Disconnected localy!');
        } else {
          print('Disconnected remote!');
        }
        if (mounted) {
          setState(() {});
        }
      });
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
      child: bukaTutupInput(size),
    ));
  }

  Widget bukaTutupInput(size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Buka Tutup Pengait Tali",
          style: AppTextStyle.primary.copyWith(
            fontSize: 18,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          width: size.width,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
            border: Border(
              bottom: BorderSide(
                color: AppColor.primary,
                width: 3.0,
              ),
              right: BorderSide(
                color: AppColor.primary,
                width: 3.0,
              ),
              left: BorderSide(
                color: AppColor.primary,
                width: 3.0,
              ),
              top: BorderSide(
                color: AppColor.primary,
                width: 3.0,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () async {
                  setState(() {
                    isOpened = !isOpened!;
                  });
                  try {
                    connection!.output
                        .add(Uint8List.fromList(utf8.encode("buka" "\r\n")));
                    await connection!.output.allSent;
                    print("Sukses terkirim buka");
                  } catch (e) {
                    print("Try Catch error : $e");
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isOpened! ? const Color(0xffcbd7c8) : Colors.white,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 25,
                  ),
                  child: Center(
                    child: Text(
                      "Buka",
                      style: AppTextStyle.primary.copyWith(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  setState(() {
                    isOpened = !isOpened!;
                  });
                  try {
                    connection!.output
                        .add(Uint8List.fromList(utf8.encode("tutup" "\r\n")));
                    await connection!.output.allSent;
                    print("Sukses terkirim tutup");
                  } catch (e) {
                    print("Try Catch error : $e");
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isOpened! ? Colors.white : const Color(0xffcbd7c8),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 25,
                  ),
                  child: Center(
                    child: Text(
                      "Tutup",
                      style: AppTextStyle.primary.copyWith(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          "Input Kedalaman (Meter)",
          style: AppTextStyle.primary.copyWith(
            fontSize: 18,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          width: size.width,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
            border: Border(
              bottom: BorderSide(
                color: AppColor.primary,
                width: 3.0,
              ),
              right: BorderSide(
                color: AppColor.primary,
                width: 3.0,
              ),
              left: BorderSide(
                color: AppColor.primary,
                width: 3.0,
              ),
              top: BorderSide(
                color: AppColor.primary,
                width: 3.0,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: const BoxDecoration(
                    color: Color(0xffcbd7c8),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                  ),
                  child: TextFormField(
                    controller: inputanNumber,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  try {
                    connection!.output.add(Uint8List.fromList(
                        utf8.encode(inputanNumber.text + "\r\n")));
                    await connection!.output.allSent;
                    print("Sukses terkirim ${inputanNumber.text}");
                  } catch (e) {
                    print("Try Catch error : $e");
                  }
                  inputanNumber.clear();
                },
                child: Column(
                  children: [
                    const Icon(
                      Icons.input_outlined,
                    ),
                    Text(
                      "Input",
                      style: AppTextStyle.primary.copyWith(
                        fontSize: 18,
                      ),
                    
                    ),
                  ],
                ),
              )
              
            ],
          ),
        ),
      ],
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
