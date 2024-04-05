import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_sandesh_web_ui/aspect_ratio_option.dart';
import 'package:my_sandesh_web_ui/business_name.dart';
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
      title: 'mySandesh Frame Builder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
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

  Uint8List? _frameImage;
  BusinessName businessNameText = BusinessName();
  Logo? businessLogo = Logo();

  final TextEditingController _companyNameController = TextEditingController(text: "Company Name");

  AspectRatioOption _selectedAspectRatio = AspectRatioOption.oneToOne;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buttonView(),
          Expanded(
            child: Column(
              children: [
                divider(),
                SizedBox(
                  width: _selectedAspectRatio.size.width,
                  height: _selectedAspectRatio.size.height,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        businessNameText.textPosition += details.delta;
                      });
                    },
                    child: Stack(
                      children: [
                        Container(
                          key: _containerKey,
                          color: Colors.blueGrey,
                          child: _frameImage == null
                              ? null
                              : Image.memory(
                                  _frameImage!,
                                  fit: BoxFit.fill,
                                ),
                        ),
                        if (businessNameText.isTextAdded != false) _businessNameContainer(),
                        if (businessLogo?.selectedLogo != null) _businessLogoContainer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
          _frameImage = f;
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
          businessLogo?.selectedLogo = f;
          businessLogo?.imageSize = const Size(100, 100);
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
                  controller: _companyNameController,
                  decoration: const InputDecoration(
                    labelText: 'Company Name',
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                divider(),
                BlockPicker(
                  pickerColor: businessNameText.textColor, // Use current text color
                  onColorChanged: (color) {
                    setState(() {
                      businessNameText.textColor = color;
                    });
                  },
                ),
                divider(),
                Slider(
                  min: 14,
                  max: 50,
                  divisions: 86,
                  value: businessNameText.textSize,
                  label: businessNameText.textSize.round().toString(),
                  onChanged: (value) {
                    setState(() {
                      businessNameText.textSize = value;
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

    final configuration = createConfiguration(
      containerWidth: containerRenderBox.size.width,
      containerHeight: containerRenderBox.size.height,
      businessName: businessNameText,
      logo: businessLogo,
    );

    final String jsonConfig = jsonEncode(configuration.toJson());
    print(jsonConfig);

    Clipboard.setData(ClipboardData(text: jsonConfig)).then((_) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PreviewScreen(
            frame: _frameImage!,
            image: businessLogo?.selectedLogo,
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
        return Padding(
          padding: const EdgeInsets.only(right: 14),
          child: ElevatedButton(
            onPressed: () => _changeAspectRatio(aspectRatio),
            child: Text(aspectRatio.name),
          ),
        );
      }).toList(),
    );
  }

  // Function to handle aspect ratio change
  void _changeAspectRatio(AspectRatioOption newAspectRatio) {
    setState(() {
      _selectedAspectRatio = newAspectRatio;
      _frameImage = null; // Remove the image if aspect ratio changes after selection
    });
  }

  Widget _buttonView() {
    return Container(
      margin: const EdgeInsets.all(30),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black87),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          aspectRatioButtons(),
          divider(),
          ElevatedButton(
              onPressed: () {
                _pickImage();
              },
              child: const Text("Upload Frame")),
          divider(),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  businessNameText.isTextAdded = true;
                });
                _showTextOptionsDialog();
              },
              child: const Text("Add Company Name")),
          divider(),
          ElevatedButton(
            onPressed: () {
              _pickLogoImage();
            },
            child: const Text("Add Image"),
          ),
          divider(),
          ElevatedButton(onPressed: () {}, child: const Text("Add Phone Number")),
          divider(),
          ElevatedButton(
              onPressed: () {
                generateConfig();
              },
              child: const Text("Generate Config")),
        ],
      ),
    );
  }

  Widget _businessNameContainer() {
    return Positioned(
      left: businessNameText.textPosition.dx,
      top: businessNameText.textPosition.dy,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
        ),
        child: Text(
          _companyNameController.text,
          style: TextStyle(
            fontFamily: businessNameText.fontName,
            fontSize: businessNameText.textSize,
            color: businessNameText.textColor,
          ),
        ),
      ),
    );
  }

  Widget divider() => const SizedBox(
        height: 30,
      );

  Widget dividerWidth() => const SizedBox(
        width: 30,
      );

  Widget _businessLogoContainer() {
    if (businessLogo != null) {
      var memoryImage = Image.memory(businessLogo!.selectedLogo!,
          width: businessLogo?.imageSize.width, height: businessLogo?.imageSize.height);

      return Positioned(
        left: businessLogo?.imagePosition.dx,
        top: businessLogo?.imagePosition.dy,
        child: Draggable(
          feedback: Material(
            type: MaterialType.transparency,
            child: memoryImage,
          ),
          childWhenDragging: Opacity(
            opacity: 0.5,
            child: memoryImage,
          ),
          onDragEnd: (details) {
            // Calculate the new position relative to the container
            final RenderBox renderBox = _containerKey.currentContext!.findRenderObject() as RenderBox;
            final Offset localOffset = renderBox.globalToLocal(details.offset);
            setState(() {
              businessLogo?.imagePosition = localOffset;
            });
          },
          child: memoryImage,
        ),
      );
    } else {
      return Container();
    }
  }
}
