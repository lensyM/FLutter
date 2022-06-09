import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sampleproject/controller/file_controller.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:sampleproject/widget/button_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:sampleproject/global/globals.dart' as globals;
import 'package:sampleproject/page/check_list.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../main.dart';

class QRScanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScanPageState();
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/Lista_Rowerow.txt');
}

Future<File> writeList(String num) async {
  try {
    final file = await _localFile;

    // Read the file
    final contents = await file.readAsString();
    final whole_data = contents + '$num' + '\n';
    return file.writeAsString('$whole_data');
  } catch (e) {
    // If encountering an error, return 0
    final file = await _localFile;
    return file.writeAsString('$num\n');
  }

  // Write the file
}

class _QRScanPageState extends State<QRScanPage> {
  String qrCode = '';
  List<String> newStationList = [];
  List<String> uncheckedList = ["\n"];
  String ScanTxt = '';
  List<String> listOfNewBikes = [''];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(MyApp.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '$ScanTxt',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '$qrCode',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 72),
              ButtonWidget(
                text: 'Kolejny',
                onClicked: () => scanQRCode(),
              ),
              SizedBox(height: 22),
              ButtonWidget(
                text: 'Stop',
                onClicked: () => stopScanQRCode(context),
              ),
              SizedBox(height: 22),
              Text(
                '$newStationList',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.red),
              )
            ],
          ),
        ),
      );

  Future<void> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      this.ScanTxt = 'Scan Result';

      if (newStationList.length < 1) {
        String text = DateFormat('h:mm:ss').format(DateTime.now());
        this.newStationList.add('$text');
      }

      if (qrCode.length > 15) {
        String data_to_send = qrCode.substring(14, qrCode.length);
        if (newStationList.contains('$data_to_send') == false) {
          this.newStationList.add('$data_to_send');
        }
      }

      if (!mounted) return;

      setState(() {
        this.qrCode = qrCode;
      });
    } on PlatformException {
      qrCode = 'Failed to get platform version.';
    }
  }

  Future<void> stopScanQRCode(BuildContext context) async {
    globals.newStationList = this.newStationList;
    context.read<FileController>().readText().toString();
    String listA = globals.read_data;
    listA = listA
        .replaceAll(new RegExp(r"[^\s\w]"), "")
        .replaceAll(new RegExp(r"[^\s\w]"), '');
    List<String> logs = (listA.split(' '));

    for (String bike in newStationList) {
      if (logs.contains('$bike') == false) {
        globals.actualCheckBikesList.add('$bike');
      }
    }
    this.newStationList = [];
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => CheckListPage()));
  }
}
