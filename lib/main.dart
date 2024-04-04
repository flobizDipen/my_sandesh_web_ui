import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_sandesh_web_ui/config.dart';
import 'package:my_sandesh_web_ui/preview.dart';

import 'block_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mySandesh UI Builder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey _containerKey = GlobalKey();
  File? _pickedImage;
  Uint8List webImage = Uint8List(8);
  bool _isTextAdded = false;
  Offset _textPosition = Offset(0, 0);
  double _textSize = 14.0;
  Color _textColor = Colors.white; // Default text color
  TextEditingController _textEditingController = TextEditingController(text: "Company Name");
  String _fontName = 'Roboto'; // Default font family

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              verticalDirection: VerticalDirection.down,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isTextAdded = true;
                      });
                      _showTextOptionsDialog();
                    },
                    child: const Text("Add Company Name")),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(onPressed: () {}, child: const Text("Add Phone Number")),
                const SizedBox(
                  height: 60,
                ),
                ElevatedButton(
                    onPressed: () {
                      _showColorPicker();
                    },
                    child: const Text("Change Text Color")),
              ],
            ),
            const SizedBox(
              width: 160,
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: 500,
                    height: 500,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          _textPosition += details.delta;
                        });
                      },
                      child: Stack(
                        children: [
                          Container(
                            key: _containerKey,
                            color: Colors.blueGrey,
                            child: _pickedImage == null
                                ? null
                                : kIsWeb
                                    ? Image.memory(
                                        webImage,
                                        fit: BoxFit.fill,
                                      )
                                    : Image.file(
                                        _pickedImage!,
                                        fit: BoxFit.fill,
                                      ),
                          ),
                          Positioned(
                            left: _textPosition.dx,
                            top: _textPosition.dy,
                            child: Text(
                              _textEditingController.text,
                              style: TextStyle(
                                fontFamily: _fontName,
                                fontSize: _textSize,
                                color: _textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Slider(
                    min: 14,
                    max: 100,
                    divisions: 86,
                    value: _textSize,
                    label: _textSize.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        _textSize = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _pickImage();
                      },
                      child: const Text("Upload Frame")),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        generateConfig();
                      },
                      child: const Text("Generate Config")),
                ],
              ),
            ),
            const SizedBox(
              width: 30,
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _pickedImage = selected;
        });
      } else {
        print("No Image has been picked");
      }
    } else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
          _pickedImage = File('a');
        });
      } else {
        print("No Image has been picked");
      }
    } else {
      print("Something went wrong");
    }
  }

  void _showTextOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Text Options'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _textEditingController,
                  decoration: const InputDecoration(
                    labelText: 'Company Name',
                  ),
                  onChanged: (value) {
                    setState(() {
                      // Update the text as user types
                    });
                  },
                ),
                // Example for changing font color, similar implementation can be done for font size and font family
                ElevatedButton(
                  onPressed: () {
                    _showColorPicker();
                  },
                  child: const Text('Change Font Color'),
                ),
                // Add sliders for font size and dropdown for font family selection
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showColorPicker() {
    // Open a dialog or modal bottom sheet to select color
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose a color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: _textColor, // Use current text color
              onColorChanged: (color) {
                setState(() {
                  _textColor = color;
                });
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void generateConfig() {
    final RenderBox containerRenderBox = _containerKey.currentContext!.findRenderObject() as RenderBox;

    // This position is already relative to its parent, so no need to adjust with globalToLocal.
    // However, make sure this position does not go negative by clamping it to 0 or above.
    final double clampedX = max(0, _textPosition.dx);
    final double clampedY = max(0, _textPosition.dy);

    final configuration = createConfiguration(
      containerWidth: containerRenderBox.size.width,
      containerHeight: containerRenderBox.size.height,
      textPosition: Offset(clampedX, clampedY),
      fontStyle: 'normal',
      // Adjust based on your logic or UI controls
      fontName: _fontName,
      fontSize: _textSize,
      fontColor: _textColor,
      textContent: _textEditingController.text,
    );

    final String jsonConfig = jsonEncode(configuration.toJson());
    print(jsonConfig);

    Clipboard.setData(ClipboardData(text: jsonConfig)).then((_) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PreviewScreen(
            imageBytes: webImage,
            config: configuration,
            containerSize: 800,
          ),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to copy configuration: $error')));
    });
  }
}
