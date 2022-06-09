import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sampleproject/controller/file_controller.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:sampleproject/widget/button_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:sampleproject/global/globals.dart' as globals;

import '../main.dart';

class CheckListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CheckListPage();
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

class _CheckListPage extends State<CheckListPage> {
  List<String> unchecedBikes = globals.actualCheckBikesList;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width;

    return new Container(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 50.0, 0.0, 0.0),
            child: new Text(
              "Nie sprawdzone rowery:",
              style: new TextStyle(
                  fontSize: 28.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 32),
          new Expanded(
            child: Container(
              child: Center(
                child: new SingleChildScrollView(
                  scrollDirection: Axis.vertical, //.horizontal
                  child: new Text(
                    globals.actualCheckBikesList.toString(),
                    style: new TextStyle(
                      fontSize: 26.0,
                      backgroundColor: Colors.white,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 0.0),
                child: ButtonWidget(
                  text: 'Akceptuj',
                  onClicked: () => stopScanQRCode(context),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 0.0),
                child: ButtonWidget(
                  text: 'Główna',
                  onClicked: () => goBackMain(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> stopScanQRCode(BuildContext context) async {
    String listA = context.read<FileController>().readText().toString();
    globals.completeListOfCheckedBikes == (listA.split(','));

    globals.completeListOfCheckedBikes.addAll(globals.actualCheckBikesList);
    globals.actualCheckBikesList = [];
    unchecedBikes.clear();
    context.read<FileController>().writeText();

    globals.actualCheckBikesList = [];
    globals.newStationList = [];
    unchecedBikes.clear();

    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            MainPage(title: "Czy wszystko sprawdziłem ?")));
  }

  Future<void> goBackMain(BuildContext context) async {
    globals.actualCheckBikesList = [];
    globals.newStationList = [];
    unchecedBikes.clear();

    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            MainPage(title: "Czy wszystko sprawdziłem ?")));
  }
}
