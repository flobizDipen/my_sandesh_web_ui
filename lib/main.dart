import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_sandesh_web_ui/aspect_ratio_option.dart';
import 'package:my_sandesh_web_ui/business_name.dart';
import 'package:my_sandesh_web_ui/component/font_properties_dialog.dart';
import 'package:my_sandesh_web_ui/component/text_element.dart';
import 'package:my_sandesh_web_ui/config.dart';
import 'package:my_sandesh_web_ui/preview.dart';

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
  List<TextElement> textElements = [];

  Uint8List? _frameImage;
  FontProperties businessNameFontProperty = FontProperties();
  FontProperties phoneNumberFontProperty = FontProperties();
  FontProperties addressFontProperty = FontProperties();
  FontProperties taglineFontProperty = FontProperties();
  Logo? businessLogo = Logo();

  AspectRatioOption _selectedAspectRatio = AspectRatioOption.oneToOne;

  @override
  void initState() {
    super.initState();
    _initializeTextElements(); // Initialize text elements
  }

  void _initializeTextElements() {
    // Initialize your text elements with default values or from a data source
    textElements.add(TextElement(
      buttonText: "Add Company Name",
      controller: TextEditingController(text: "Company Name"),
      fontProperties: businessNameFontProperty,
    ));
    textElements.add(TextElement(
      buttonText: "Add Phone Number",
      controller: TextEditingController(text: "+919725955985"),
      fontProperties: phoneNumberFontProperty,
    ));
    textElements.add(TextElement(
      buttonText: "Add Address",
      controller: TextEditingController(text: "FloBiz, Bengaluru, Karnataka"),
      fontProperties: addressFontProperty,
    ));
    textElements.add(TextElement(
      buttonText: "Add Tagline",
      controller: TextEditingController(text: "Business Karneka Naya tareeka"),
      fontProperties: taglineFontProperty,
    ));
    // Add other text elements as needed
  }

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
                      ...textElements.where((element) => element.isAdded).map((element) {
                        return _textContainer(element);
                      }),
                      if (businessLogo?.selectedLogo != null) _businessLogoContainer(),
                    ],
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

  void generateConfig() {
    final RenderBox containerRenderBox = _containerKey.currentContext!.findRenderObject() as RenderBox;

    final configuration = createConfiguration(
      containerWidth: containerRenderBox.size.width,
      containerHeight: containerRenderBox.size.height,
      businessName: businessNameFontProperty,
      phoneNumber: phoneNumberFontProperty,
      address: addressFontProperty,
      tagline: taglineFontProperty,
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
            smallSize: _selectedAspectRatio.sizeSmall,
            largeSize: _selectedAspectRatio.sizeLarge,
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
          _textElementButton(),
          divider(),
          ElevatedButton(
            onPressed: () {
              _pickLogoImage();
            },
            child: const Text("Add Image"),
          ),
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

  Widget _addTextFieldButton(TextElement element) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          element.isAdded = true;
        });
        showTextOptionsDialog(
          context: context,
          controller: element.controller,
          fontStyle: element.fontProperties,
          onTextUpdate: (String textChange) {
            // This can be kept empty if the controller is directly updating the model
          },
          onFontWeight: (FontWeight fontWeight) {
            setState(() {
              element.fontProperties.fontWeight = fontWeight;
            });
          },
          onTextSize: (double fontSize) {
            setState(() {
              element.fontProperties.textSize = fontSize;
            });
          },
          onColorChange: (Color fontColor) {
            setState(() {
              element.fontProperties.textColor = fontColor;
            });
          },
          onFontFamily: (String fontFamily) {
            setState(() {
              element.fontProperties.fontFamily = fontFamily;
            });
          },
        );
      },
      child: Text(element.buttonText),
    );
  }

  Widget _textContainer(TextElement element) {
    Widget child = Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
      ),
      child: Text(
        element.controller.text,
        style: TextStyle(
          fontFamily: element.fontProperties.fontFamily,
          fontSize: element.fontProperties.textSize,
          color: element.fontProperties.textColor,
          fontWeight: element.fontProperties.fontWeight,
        ),
      ),
    );

    return Positioned(
      left: element.fontProperties.textPosition.dx,
      top: element.fontProperties.textPosition.dy,
      child: Draggable(
        feedback: Material(
          type: MaterialType.transparency,
          child: child,
        ),
        childWhenDragging: Opacity(
          opacity: 0.5,
          child: child,
        ),
        onDragEnd: (details) {
          final RenderBox renderBox = _containerKey.currentContext!.findRenderObject() as RenderBox;
          final Offset localOffset = renderBox.globalToLocal(details.offset);
          setState(() {
            element.fontProperties.textPosition = localOffset;
          });
        },
        child: child,
      ),
    );
  }

  Widget _textElementButton() {
    // Example for Company Name, repeat for others as needed
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: textElements.map((element) {
          return _addTextFieldButton(element);
        }).toList(),
      ),
    );
  }
}
