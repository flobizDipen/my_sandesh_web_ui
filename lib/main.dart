import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_sandesh_web_ui/aspect_ratio_option.dart';
import 'package:my_sandesh_web_ui/business_name.dart';
import 'package:my_sandesh_web_ui/component/font_style_dialog.dart';
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

  Uint8List? _frameImage;
  FontProperties businessNameFontProperty = FontProperties();
  FontProperties phoneNumberFontProperty = FontProperties();
  FontProperties addressFontProperty = FontProperties();
  FontProperties taglineFontProperty = FontProperties();
  Logo? businessLogo = Logo();

  final TextEditingController _companyNameController = TextEditingController(text: "Company Name");
  final TextEditingController _phoneNumberController = TextEditingController(text: "+919725955985");
  final TextEditingController _addressController = TextEditingController(text: "FloBiz, Bengaluru, Karnataka");
  final TextEditingController _taglineController = TextEditingController(text: "Business Karneka Naya tareeka");

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
                      if (businessNameFontProperty.isTextAdded != false) _businessNameContainer(),
                      if (phoneNumberFontProperty.isTextAdded != false) _phoneNumberContainer(),
                      if (addressFontProperty.isTextAdded != false) _addressContainer(),
                      if (taglineFontProperty.isTextAdded != false) _taglineContainer(),
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
          _addCompanyName(),
          divider(),
          _addPhoneNumber(),
          divider(),
          _addAddress(),
          divider(),
          _addTagline(),
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

  Widget _businessNameContainer() {
    Widget child = Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
      ),
      child: Text(
        _companyNameController.text,
        style: TextStyle(
          fontFamily: businessNameFontProperty.fontFamily,
          fontSize: businessNameFontProperty.textSize,
          color: businessNameFontProperty.textColor,
          fontWeight: businessNameFontProperty.fontWeight,
        ),
      ),
    );

    return Positioned(
      left: businessNameFontProperty.textPosition.dx,
      top: businessNameFontProperty.textPosition.dy,
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
          // Calculate the new position relative to the container
          final RenderBox renderBox = _containerKey.currentContext!.findRenderObject() as RenderBox;
          final Offset localOffset = renderBox.globalToLocal(details.offset);
          setState(() {
            businessNameFontProperty.textPosition = localOffset;
          });
        },
        child: child,
      ),
    );
  }

  Widget _phoneNumberContainer() {
    Widget child = Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
      ),
      child: Text(
        _phoneNumberController.text,
        style: TextStyle(
          fontFamily: phoneNumberFontProperty.fontFamily,
          fontSize: phoneNumberFontProperty.textSize,
          color: phoneNumberFontProperty.textColor,
        ),
      ),
    );

    return Positioned(
      left: phoneNumberFontProperty.textPosition.dx,
      top: phoneNumberFontProperty.textPosition.dy,
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
          // Calculate the new position relative to the container
          final RenderBox renderBox = _containerKey.currentContext!.findRenderObject() as RenderBox;
          final Offset localOffset = renderBox.globalToLocal(details.offset);
          setState(() {
            phoneNumberFontProperty.textPosition = localOffset;
          });
        },
        child: child,
      ),
    );
  }

  Widget _addressContainer() {
    Widget child = Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
      ),
      child: Text(
        _addressController.text,
        style: TextStyle(
          fontFamily: addressFontProperty.fontFamily,
          fontSize: addressFontProperty.textSize,
          color: addressFontProperty.textColor,
        ),
      ),
    );

    return Positioned(
      left: addressFontProperty.textPosition.dx,
      top: addressFontProperty.textPosition.dy,
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
          // Calculate the new position relative to the container
          final RenderBox renderBox = _containerKey.currentContext!.findRenderObject() as RenderBox;
          final Offset localOffset = renderBox.globalToLocal(details.offset);
          setState(() {
            addressFontProperty.textPosition = localOffset;
          });
        },
        child: child,
      ),
    );
  }

  Widget _taglineContainer() {
    Widget child = Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
      ),
      child: Text(
        _taglineController.text,
        style: TextStyle(
          fontFamily: taglineFontProperty.fontFamily,
          fontSize: taglineFontProperty.textSize,
          color: taglineFontProperty.textColor,
        ),
      ),
    );

    return Positioned(
      left: taglineFontProperty.textPosition.dx,
      top: taglineFontProperty.textPosition.dy,
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
          // Calculate the new position relative to the container
          final RenderBox renderBox = _containerKey.currentContext!.findRenderObject() as RenderBox;
          final Offset localOffset = renderBox.globalToLocal(details.offset);
          setState(() {
            taglineFontProperty.textPosition = localOffset;
          });
        },
        child: child,
      ),
    );
  }

  Widget _addCompanyName() {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            businessNameFontProperty.isTextAdded = true;
          });
          showTextOptionsDialog(
            context: context,
            controller: _companyNameController,
            fontStyle: businessNameFontProperty,
            onTextUpdate: (String textChange) {
              setState(() {});
            },
            onFontWeight: (FontWeight fontWeight) {
              setState(() {
                businessNameFontProperty.fontWeight = fontWeight;
              });
            },
            onTextSize: (double fontSize) {
              setState(() {
                businessNameFontProperty.textSize = fontSize;
              });
            },
            onColorChange: (Color fontColor) {
              setState(() {
                businessNameFontProperty.textColor = fontColor;
              });
            },
            onFontFamily: (String fontFamily) {
              setState(() {
                businessNameFontProperty.fontFamily = fontFamily;
              });
            },
          );
        },
        child: const Text("Add Company Name"));
  }

  Widget _addPhoneNumber() {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            phoneNumberFontProperty.isTextAdded = true;
          });
          showTextOptionsDialog(
            context: context,
            controller: _phoneNumberController,
            fontStyle: phoneNumberFontProperty,
            onTextUpdate: (String textChange) {
              setState(() {});
            },
            onFontWeight: (FontWeight fontWeight) {
              setState(() {
                phoneNumberFontProperty.fontWeight = fontWeight;
              });
            },
            onTextSize: (double fontSize) {
              setState(() {
                phoneNumberFontProperty.textSize = fontSize;
              });
            },
            onColorChange: (Color fontColor) {
              setState(() {
                phoneNumberFontProperty.textColor = fontColor;
              });
            },
            onFontFamily: (String fontFamily) {
              setState(() {
                phoneNumberFontProperty.fontFamily = fontFamily;
              });
            },
          );
        },
        child: const Text("Add Phone Number"));
  }

  Widget _addAddress() {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            addressFontProperty.isTextAdded = true;
          });
          showTextOptionsDialog(
            context: context,
            controller: _addressController,
            fontStyle: addressFontProperty,
            onTextUpdate: (String textChange) {
              setState(() {});
            },
            onFontWeight: (FontWeight fontWeight) {
              setState(() {
                addressFontProperty.fontWeight = fontWeight;
              });
            },
            onTextSize: (double fontSize) {
              setState(() {
                addressFontProperty.textSize = fontSize;
              });
            },
            onColorChange: (Color fontColor) {
              setState(() {
                addressFontProperty.textColor = fontColor;
              });
            },
            onFontFamily: (String fontFamily) {
              setState(() {
                addressFontProperty.fontFamily = fontFamily;
              });
            },
          );
        },
        child: const Text("Add Address"));
  }

  Widget _addTagline() {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            taglineFontProperty.isTextAdded = true;
          });
          showTextOptionsDialog(
            context: context,
            controller: _taglineController,
            fontStyle: taglineFontProperty,
            onTextUpdate: (String textChange) {
              setState(() {});
            },
            onFontWeight: (FontWeight fontWeight) {
              setState(() {
                taglineFontProperty.fontWeight = fontWeight;
              });
            },
            onTextSize: (double fontSize) {
              setState(() {
                taglineFontProperty.textSize = fontSize;
              });
            },
            onColorChange: (Color fontColor) {
              setState(() {
                taglineFontProperty.textColor = fontColor;
              });
            },
            onFontFamily: (String fontFamily) {
              setState(() {
                taglineFontProperty.fontFamily = fontFamily;
              });
            },
          );
        },
        child: const Text("Add Tagline"));
  }
}
