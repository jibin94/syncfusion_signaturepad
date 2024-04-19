import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

void main() {
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Signature Pad",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: SfSignaturePad(
                  key: signatureGlobalKey,
                  backgroundColor: Colors.white,
                  strokeColor: Colors.black,
                  minimumStrokeWidth: 1.0,
                  maximumStrokeWidth: 4.0),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  _handleSaveButtonPressed(context);
                },
                child: const Text('Save As Image'),
              ),
              TextButton(
                onPressed: _handleClearButtonPressed,
                child: const Text('Clear'),
              )
            ],
          )
        ],
      ),
    );
  }

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
  }

  void _handleSaveButtonPressed(BuildContext context) async {
    final data =
        await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await data.toByteData(format: ui.ImageByteFormat.png);
    if (!mounted) return;
    navigate(context, bytes);
  }

  void navigate(BuildContext context, ByteData? bytes) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Container(
                color: Colors.grey[300],
                child: Image.memory(bytes!.buffer.asUint8List()),
              ),
            ),
          );
        },
      ),
    );
  }
}
