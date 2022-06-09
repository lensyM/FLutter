import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sampleproject/global/globals.dart' as globals;

class FileManager {
  static FileManager _instance;

  FileManager._internal() {
    _instance = this;
  }

  factory FileManager() => _instance ?? FileManager._internal();

  Future<String> get _directoryPath async {
    Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _file async {
    final path = await _directoryPath;
    return File('$path/Lista_Rowerow.txt');
  }

  Future<String> readTextFile() async {
    String fileContent = '####';

    File file = await _file;

    if (await file.exists()) {
      try {
        fileContent = await file.readAsString();
        print('$file');
      } catch (e) {
        print(e);
      }
    }
    globals.read_data = fileContent;
    return fileContent;
  }

  Future<String> writeTextFile() async {
    // String text = DateFormat('h:mm:ss').format(DateTime.now());
    String text = globals.completeListOfCheckedBikes.toString();
    File file = await _file;
    await file.writeAsString(text);
    return text;
  }
}
