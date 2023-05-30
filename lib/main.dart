import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: const TextTheme(
          headline6: TextStyle(
            color: Colors.yellow,
          ),
        ),
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Screenshot Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Screenshot(
              controller: screenshotController,
              child: Container(
                padding: const EdgeInsets.all(30.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent, width: 2.0),
                  color: Colors.amberAccent,
                ),
                child: Column(
                  children: const [
                    Text("This widget will be captured as an image"),
                    Text("This widget will be captured as an image"),
                    Text("This widget will be captured as an image"),
                  ],
                ),
                // Stack(
                //   children: [
                //     Image.asset(
                //       'assets/flutter_logo.png',
                //     ),
                //     const Text("This widget will be captured as an image"),
                //   ],
                // ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
              child: const Text(
                'Capture Above Widget',
              ),
              onPressed: () async {
                screenshotController
                    .capture(delay: const Duration(milliseconds: 10))
                    .then((capturedImage) async {
                  // await showCapturedWidget(context, capturedImage!);
                  await saveImage(capturedImage!);
                }).catchError((onError) {
                  log(onError);
                });
              },
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              child: const Text(
                'Capture An Invisible Widget',
              ),
              onPressed: () {
                var container = Container(
                    padding: const EdgeInsets.all(30.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent, width: 5.0),
                      color: Colors.redAccent,
                    ),
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/flutter_logo.png',
                        ),
                        Text(
                          "This is an invisible widget",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ));
                screenshotController
                    .captureFromWidget(
                  InheritedTheme.captureAll(
                    context,
                    Material(child: container),
                  ),
                  delay: const Duration(seconds: 1),
                )
                    .then((capturedImage) {
                  showCapturedWidget(context, capturedImage);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> showCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text("Captured widget screenshot"),
        ),
        body: Center(
          child:
              capturedImage != null ? Image.memory(capturedImage) : Container(),
        ),
      ),
    );
  }

  Future<dynamic> saveImage(Uint8List capturedImage) async {
    var directory = await getTemporaryDirectory();
    String filePath =
        '${directory.path}/algorithm_generation_tournament_fixture_calender.png';

    File imageFile = File(filePath);
    await imageFile.writeAsBytes(capturedImage);
    debugPrint("File Saved to Gallery: $filePath");
  }
}
