import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_sandesh_web_ui/aspect_ratio_option.dart';
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

  File? _pickedFrame;
  Uint8List webFrame = Uint8List(8);

  File? _pickedLogo;
  Uint8List logoImage = Uint8List(8);

  bool _isTextAdded = false;
  Offset _textPosition = const Offset(0, 0);
  double _textSize = 14.0;
  Color _textColor = Colors.white; // Default text color
  final TextEditingController _textEditingController = TextEditingController(text: "Company Name");
  final String _fontName = 'Roboto';
  AspectRatioOption _selectedAspectRatio = AspectRatioOption.oneToOne;

  Offset _additionalImagePosition = Offset(0, 0);
  Size _additionalImageSize = Size(100, 100);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: 30,
          ),
          Column(
            verticalDirection: VerticalDirection.down,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              aspectRatioButtons(),
              SizedBox(
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
                    setState(() {
                      _isTextAdded = true;
                    });
                    _showTextOptionsDialog();
                  },
                  child: const Text("Add Company Name")),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  _pickLogoImage();
                },
                child: const Text("Add Image"),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(onPressed: () {}, child: const Text("Add Phone Number")),
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
                  width: _selectedAspectRatio.size.width,
                  height: _selectedAspectRatio.size.height,
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
                          child: _pickedFrame == null
                              ? null
                              : Image.memory(
                                  webFrame,
                                  fit: BoxFit.fill,
                                ),
                        ),
                        if(_isTextAdded != false)
                        Positioned(
                          left: _textPosition.dx,
                          top: _textPosition.dy,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red),
                            ),
                            child: Text(
                              _textEditingController.text,
                              style: TextStyle(
                                fontFamily: _fontName,
                                fontSize: _textSize,
                                color: _textColor,
                              ),
                            ),
                          ),
                        ),
                        if (_pickedLogo != null)
                          Positioned(
                            left: _additionalImagePosition.dx,
                            top: _additionalImagePosition.dy,
                            child: Draggable(
                              feedback: Material(
                                type: MaterialType.transparency,
                                child: Image.memory(logoImage, width: _additionalImageSize.width, height: _additionalImageSize.height),
                              ),

                              childWhenDragging: Opacity(
                                opacity: 0.5,
                                child: Image.memory(logoImage, width: _additionalImageSize.width, height: _additionalImageSize.height),
                              ),
                              onDragEnd: (details) {
                                // Calculate the new position relative to the container
                                final RenderBox renderBox = _containerKey.currentContext!.findRenderObject() as RenderBox;
                                final Offset localOffset = renderBox.globalToLocal(details.offset);
                                setState(() {
                                  _additionalImagePosition = localOffset;
                                });
                              },
                              child: Image.memory(logoImage, width: _additionalImageSize.width, height: _additionalImageSize.height),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 30,
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          webFrame = f;
          _pickedFrame = File('a');
        });
      } else {
        print("No Image has been picked");
      }
    } else {
      print("Something went wrong");
    }
  }

  // Method to pick and set the additional image
  Future<void> _pickLogoImage() async {

    if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          logoImage = f;
          _additionalImageSize = Size(100, 100);
          _pickedLogo = File('a');
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
                    setState(() {});
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                BlockPicker(
                  pickerColor: _textColor, // Use current text color
                  onColorChanged: (color) {
                    setState(() {
                      _textColor = color;
                    });
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Slider(
                  min: 14,
                  max: 50,
                  divisions: 86,
                  value: _textSize,
                  label: _textSize.round().toString(),
                  onChanged: (value) {
                    setState(() {
                      _textSize = value;
                    });
                  },
                )
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

  void generateConfig() {
    final RenderBox containerRenderBox = _containerKey.currentContext!.findRenderObject() as RenderBox;

    // This position is already relative to its parent, so no need to adjust with globalToLocal.
    // However, make sure this position does not go negative by clamping it to 0 or above.

    print("Dx :: ${_textPosition.dx} and Dy :: ${_textPosition.dy}");

    final double clampedX = max(0, _textPosition.dx);
    final double clampedY = max(0, _textPosition.dy);

    final double clampedIX = max(0, _additionalImagePosition.dx);
    final double clampedIY = max(0, _additionalImagePosition.dy);

    final configuration = createConfiguration(
      containerWidth: containerRenderBox.size.width,
      containerHeight: containerRenderBox.size.height,
      textPosition: Offset(clampedX, clampedY),
      imagePosition: Offset(clampedIX, clampedIY),
      fontStyle: 'normal',
      // Adjust based on your logic or UI controls
      fontName: _fontName,
      fontSize: _textSize,
      fontColor: _textColor,
      textContent: _textEditingController.text,
      imageSize: _additionalImageSize
    );

    final String jsonConfig = jsonEncode(configuration.toJson());
    print(jsonConfig);

    Clipboard.setData(ClipboardData(text: jsonConfig)).then((_) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PreviewScreen(
            frame: webFrame,
            image: logoImage,
            config: configuration,
            containerWidth: 1000,
            containerHeight: 800,
          ),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to copy configuration: $error')));
    });
  }

  Widget aspectRatioButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: AspectRatioOption.values.map((aspectRatio) {
        return ElevatedButton(
          onPressed: () => _changeAspectRatio(aspectRatio),
          child: Text(aspectRatio.name.replaceFirstMapped(RegExp(r'^.'), (match) => match.group(0)!.toUpperCase())),
        );
      }).toList(),
    );
  }

  // Function to handle aspect ratio change
  void _changeAspectRatio(AspectRatioOption newAspectRatio) {
    setState(() {
      _selectedAspectRatio = newAspectRatio;
      _pickedFrame = null; // Remove the image if aspect ratio changes after selection
    });
  }
}
