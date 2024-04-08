import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_sandesh_web_ui/component/aspect_ratio_button.dart';
import 'package:my_sandesh_web_ui/component/custom_button.dart';
import 'package:my_sandesh_web_ui/component/font_properties_dialog.dart';
import 'package:my_sandesh_web_ui/component/logo_size_configurator.dart';
import 'package:my_sandesh_web_ui/component/text_field_type.dart';
import 'package:my_sandesh_web_ui/config/config_generator.dart';
import 'package:my_sandesh_web_ui/model/logo_image.dart';
import 'package:my_sandesh_web_ui/model/text_element.dart';
import 'package:my_sandesh_web_ui/screen/preview.dart';
import 'package:my_sandesh_web_ui/theme/ms_colors.dart';
import 'package:my_sandesh_web_ui/utility/aspect_ratio_option.dart';
import 'package:my_sandesh_web_ui/utility/widget_extension.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey _containerKey = GlobalKey();
  List<TextElement> textElements = [];

  String? _frameName;
  Uint8List? _frameImage;
  LogoImage? businessLogo;

  AspectRatioOption _selectedAspectRatio = AspectRatioOption.values.first;

  @override
  void initState() {
    super.initState();
    _initializeTextElements(); // Initialize text elements
  }

  void _initializeTextElements() {
    // Initialize your text elements with default values or from a data source
    textElements.add(TextElement(
      type: TextFieldType.companyName,
      buttonText: "Add Company Name",
      controller: TextEditingController(text: "Company Name"),
      fontProperties: FontProperties(),
    ));
    textElements.add(TextElement(
      type: TextFieldType.phoneNumber,
      buttonText: "Add Phone Number",
      controller: TextEditingController(text: "+919725955985"),
      fontProperties: FontProperties(),
    ));
    textElements.add(TextElement(
      type: TextFieldType.address,
      buttonText: "Add Address",
      controller: TextEditingController(text: "FloBiz, Bengaluru, Karnataka"),
      fontProperties: FontProperties(),
    ));
    textElements.add(TextElement(
      type: TextFieldType.tagline,
      buttonText: "Add Tagline",
      controller: TextEditingController(text: "Business Karneka Naya tareeka"),
      fontProperties: FontProperties(),
    ));
    // Add other text elements as needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _actionView(),
          _canvas(),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // Updated to use a generic function for picking images
  Future<void> pickImageAndUpdateState(Function(Uint8List, String) updateStateCallback) async {
    if (kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var imageBytes = await image.readAsBytes();
        setState(() {
          updateStateCallback(imageBytes, image.name);
        });
      } else {
        print("No Image has been picked");
      }
    } else {
      print("Image picking is only supported on web in this context");
    }
  }

  void generateConfig() {
    final RenderBox containerRenderBox = _containerKey.currentContext!.findRenderObject() as RenderBox;

    final configuration = createConfiguration(
      fileName: _frameName ?? "",
      aspectRatio: _selectedAspectRatio.name,
      containerWidth: containerRenderBox.size.width,
      containerHeight: containerRenderBox.size.height,
      textElements: textElements,
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
            largeSize: _selectedAspectRatio.sizeExtraLarge,
          ),
        ),
      );
    }).catchError((error) {
      context.showSnackBar('Failed to copy configuration: $error');
    });
  }

  Widget _actionView() {
    return Container(
      color: MSColors.actionBar,
      width: MediaQuery.of(context).size.width * 0.25,
      height: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatioButtons(
              selectedAspectRatio: _selectedAspectRatio,
              onAspectRatioSelected: (aspectRatioOption) {
                setState(() {
                  _selectedAspectRatio = aspectRatioOption;
                });
              }),
          context.divider(),
          CustomButton(
            label: "Upload Frame",
            onPressed: () {
              pickImageAndUpdateState((imageBytes, fileName) {
                _frameName = fileName;
                _frameImage = imageBytes;
              });
            },
          ),
          context.divider(),
          _textElementButton(),
          context.divider(),
          _addLogo(),
          context.divider(height: 200.0),
          CustomButton(
              label: "Generate Configuration",
              onPressed: () {
                if (_frameImage != null) {
                  generateConfig();
                } else {
                  context.showSnackBar('Please Select Frame');
                }
              })
        ],
      ),
    );
  }

  Widget _addLogo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomButton(
            label: "Add Logo",
            onPressed: () {
              pickImageAndUpdateState((imageBytes, fileName) {
                businessLogo = LogoImage()..selectedLogo = imageBytes;
                businessLogo?.imageSize = const Size(100, 100); // You can adjust the size as needed
              });
            }),
        if (businessLogo?.selectedLogo != null) ...[
          LogoSizeConfigurator(
            onSizeChange: (size) {
              setState(() {
                businessLogo?.imageSize = Size(size.width, size.height);
              });
            },
          )
        ],
      ],
    );
  }

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
    return CustomButton(
      label: element.buttonText,
      onPressed: () {
        setState(() {
          element.isAdded = true;
        });

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return TextStyleOption(
                  element: element,
                  onTextUpdate: (String textChange) {
                    setState(() {});
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
                  onTextAlign: (TextAlign textAlign) {
                    setState(() {
                      element.fontProperties.textAlign = textAlign;
                    });
                  },
                  onRemove: (TextElement textElement) {
                    setState(() {
                      // Find the element in the list and update its `isAdded` status
                      final index = textElements.indexOf(textElement);
                      if (index != -1) {
                        textElements[index].isAdded = false;
                      }
                    });
                  });
            });
      },
    );
  }

  Widget _textContainer(TextElement element) {
    Widget child = Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
      ),
      child: Text(
        element.controller.text,
        textAlign: element.fontProperties.textAlign,
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // Ensure left alignment
        children: textElements.asMap().entries.map((entry) {
          int index = entry.key;
          TextElement element = entry.value;

          // Add top padding to all elements except the first one
          return Padding(
            padding: EdgeInsets.only(top: index == 0 ? 0 : 20), // Adjust the padding as needed
            child: _addTextFieldButton(element),
          );
        }).toList(),
      ),
    );
  }

  Widget _canvas() {
    return Expanded(
      child: Container(
        color: MSColors.canvas,
        alignment: Alignment.center,
        height: double.infinity,
        child: Center(
          child: Material(
            elevation: 5.0, // Add elevation
            child: SizedBox(
              width: _selectedAspectRatio.sizeExtraLarge.width,
              height: _selectedAspectRatio.sizeExtraLarge.height,
              child: Stack(
                children: [
                  Container(
                    color: Colors.blueGrey.shade200,
                    key: _containerKey,
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
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: _selectedAspectRatio.sizeExtraLarge.width / 2,
                    child: Container(
                      width: 1,
                      color: Colors.red, // Change color if needed
                    ),
                  ),
                  // Vertical center line
                  Positioned(
                    left: 0,
                    right: 0,
                    top: _selectedAspectRatio.sizeExtraLarge.height / 2,
                    child: Container(
                      height: 1,
                      color: Colors.red, // Change color if needed
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
