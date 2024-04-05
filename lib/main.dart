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
  FontSupport businessName = FontSupport();
  FontSupport phoneNumber = FontSupport();
  FontSupport address = FontSupport();
  FontSupport tagline = FontSupport();
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
                      if (businessName.isTextAdded != false) _businessNameContainer(),
                      if (phoneNumber.isTextAdded != false) _phoneNumberContainer(),
                      if(address.isTextAdded != false) _addressContainer(),
                      if(tagline.isTextAdded != false) _taglineContainer(),
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

  void _showTextOptionsDialog(
    TextEditingController controller,
    FontSupport fontStyle,
    Function(String) onTextUpdate,
    Function(FontWeight) onFontWeight,
    Function(double) onTextSize,
    Function(Color) onColorChange,
    Function(String) onFontFamily,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // Use StatefulBuilder to manage state inside the dialog
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Text Options'),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        labelText: 'Input Text',
                      ),
                      onChanged: (value) {
                        onTextUpdate(value);
                      },
                    ),
                    const Divider(),
                    BlockPicker(
                      pickerColor: fontStyle.textColor, // Use current text color
                      onColorChanged: (color) {
                        setState(() {
                          fontStyle.textColor = color;
                        });
                        onColorChange(color);
                      },
                    ),
                    const Divider(),
                    Slider(
                      min: 14,
                      max: 50,
                      divisions: 36,
                      value: fontStyle.textSize,
                      label: fontStyle.textSize.round().toString(),
                      onChanged: (value) {
                        setState(() {
                          fontStyle.textSize = value;
                        });
                        onTextSize(value);
                      },
                    ),
                    const Divider(),
                    DropdownButton<FontWeight>(
                      value: fontStyle.fontWeight,
                      items: FontWeight.values.map((FontWeight value) {
                        return DropdownMenuItem<FontWeight>(
                          value: value,
                          child: Text(value.toString().split('.').last),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          fontStyle.fontWeight = value!;
                        });
                        onFontWeight(value!);
                      },
                    ),
                    const Divider(),
                    DropdownButton<String>(
                      value: fontStyle.fontFamily,
                      items: <String>['Roboto', 'Open Sans', 'Lato', 'Montserrat'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          fontStyle.fontFamily = value!;
                        });
                        onFontFamily(value!);
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
      },
    );
  }

  void generateConfig() {
    final RenderBox containerRenderBox = _containerKey.currentContext!.findRenderObject() as RenderBox;

    final configuration = createConfiguration(
      containerWidth: containerRenderBox.size.width,
      containerHeight: containerRenderBox.size.height,
      businessName: businessName,
      phoneNumber: phoneNumber,
      address: address,
      tagline: tagline,
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
          fontFamily: businessName.fontFamily,
          fontSize: businessName.textSize,
          color: businessName.textColor,
          fontWeight: businessName.fontWeight,
        ),
      ),
    );

    return Positioned(
      left: businessName.textPosition.dx,
      top: businessName.textPosition.dy,
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
            businessName.textPosition = localOffset;
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
          fontFamily: phoneNumber.fontFamily,
          fontSize: phoneNumber.textSize,
          color: phoneNumber.textColor,
        ),
      ),
    );

    return Positioned(
      left: phoneNumber.textPosition.dx,
      top: phoneNumber.textPosition.dy,
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
            phoneNumber.textPosition = localOffset;
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
          fontFamily: address.fontFamily,
          fontSize: address.textSize,
          color: address.textColor,
        ),
      ),
    );

    return Positioned(
      left: address.textPosition.dx,
      top: address.textPosition.dy,
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
            address.textPosition = localOffset;
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
          fontFamily: tagline.fontFamily,
          fontSize: tagline.textSize,
          color: tagline.textColor,
        ),
      ),
    );

    return Positioned(
      left: tagline.textPosition.dx,
      top: tagline.textPosition.dy,
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
            tagline.textPosition = localOffset;
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
            businessName.isTextAdded = true;
          });
          _showTextOptionsDialog(
            _companyNameController,
            businessName,
            (String textChange) {
              setState(() {});
            },
            (FontWeight fontWeight) {
              setState(() {
                businessName.fontWeight = fontWeight;
              });
            },
            (double fontSize) {
              setState(() {
                businessName.textSize = fontSize;
              });
            },
            (Color fontColor) {
              setState(() {
                businessName.textColor = fontColor;
              });
            },
            (String fontFamily) {
              setState(() {
                businessName.fontFamily = fontFamily;
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
            phoneNumber.isTextAdded = true;
          });
          _showTextOptionsDialog(
            _phoneNumberController,
            phoneNumber,
            (String textChange) {
              setState(() {});
            },
            (FontWeight fontWeight) {
              setState(() {
                phoneNumber.fontWeight = fontWeight;
              });
            },
            (double fontSize) {
              setState(() {
                phoneNumber.textSize = fontSize;
              });
            },
            (Color fontColor) {
              setState(() {
                phoneNumber.textColor = fontColor;
              });
            },
            (String fontFamily) {
              setState(() {
                phoneNumber.fontFamily = fontFamily;
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
            address.isTextAdded = true;
          });
          _showTextOptionsDialog(
            _addressController,
            address,
                (String textChange) {
              setState(() {});
            },
                (FontWeight fontWeight) {
              setState(() {
                address.fontWeight = fontWeight;
              });
            },
                (double fontSize) {
              setState(() {
                address.textSize = fontSize;
              });
            },
                (Color fontColor) {
              setState(() {
                address.textColor = fontColor;
              });
            },
                (String fontFamily) {
              setState(() {
                address.fontFamily = fontFamily;
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
            tagline.isTextAdded = true;
          });
          _showTextOptionsDialog(
            _taglineController,
            tagline,
                (String textChange) {
              setState(() {});
            },
                (FontWeight fontWeight) {
              setState(() {
                tagline.fontWeight = fontWeight;
              });
            },
                (double fontSize) {
              setState(() {
                tagline.textSize = fontSize;
              });
            },
                (Color fontColor) {
              setState(() {
                tagline.textColor = fontColor;
              });
            },
                (String fontFamily) {
              setState(() {
                tagline.fontFamily = fontFamily;
              });
            },
          );
        },
        child: const Text("Add Tagline"));
  }
}
