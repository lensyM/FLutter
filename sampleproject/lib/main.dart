import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sampleproject/controller/file_controller.dart';
import 'package:sampleproject/page/qr_create_page.dart';
import 'package:sampleproject/page/qr_scan_page.dart';
import 'package:sampleproject/page/show_list.dart';
import 'package:sampleproject/widget/button_widget.dart';
import 'package:provider/provider.dart';

import 'package:sampleproject/global/globals.dart' as globals;
//import 'package:path_provider/path_provider.dart';
//import 'dart:io';

void main() => runApp(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => FileController())],
        child: MyApp(),
      ),
    );

//{
///WidgetsFlutterBinding.ensureInitialized();
//SystemChrome.setPreferredOrientations([
// DeviceOrientation.portraitUp,
// DeviceOrientation.portraitDown,
// ]);

//  runApp(MyApp());
//}

class MyApp extends StatelessWidget {
  static final String title = "Czy wszystko sprawdziłem ?";

  @override
  Widget build(BuildContext context) {
    context.read<FileController>().readText();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
        primaryColor: Colors.red,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: MainPage(title: title),
    );
  }
}

class MainPage extends StatefulWidget {
  final String title;

  const MainPage({
    @required this.title,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                text: 'Sprawdź stację',
                onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => QRScanPage(),
                )),
              ),
              const SizedBox(height: 42),
              ButtonWidget(
                text: 'Wyświetl listę',
                onClicked: () => showCheckedList(context),
              ),

              const SizedBox(height: 202),
              ButtonWidget(
                text: 'Reset Listy',
                onClicked: () => resetListy(context),
              ),

              ///const SizedBox(height: 202),
              //ButtonWidget(
              //  text: 'STWORZ KOD',
              //  onClicked: () => Navigator.of(context).push(MaterialPageRoute(
              //    builder: (BuildContext context) => QRCreatePage(),
              //  )),
              //),

              const SizedBox(height: 10),
              Text(
                context.select((FileController controller) => controller.text),
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              // const SizedBox(height: 10),
              // ButtonWidget(
              //   text: 'Aktualizuj',
              //   onClicked: () => context.read<FileController>().writeText(),
              // ),
            ],
          ),
        ),
      );

  Future<void> showCheckedList(BuildContext context) async {
    String listA = context.read<FileController>().readText().toString();
    globals.completeListOfCheckedBikes == (listA.split('\n\n'));

    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => showListPage()));
  }

  Future<void> resetListy(BuildContext context) async {
    globals.completeListOfCheckedBikes.clear();
    context.read<FileController>().writeText();
  }
}
