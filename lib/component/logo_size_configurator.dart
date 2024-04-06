import 'package:flutter/material.dart';
import 'package:my_sandesh_web_ui/utility/widget_extension.dart';

class LogoSizeConfigurator extends StatefulWidget {
  final Function(Size size) onSizeChange;

  const LogoSizeConfigurator({super.key, required this.onSizeChange});

  @override
  State<LogoSizeConfigurator> createState() => _LogoSizeConfiguratorState(onSizeChange);
}

class _LogoSizeConfiguratorState extends State<LogoSizeConfigurator> {

  TextEditingController widthController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  _LogoSizeConfiguratorState(final Function(Size size) onSizeChange);

  @override
  void initState() {
    super.initState();
    // Initialize with default sizes, if you have those
    widthController.text = "100"; // Default width
    heightController.text = "100"; // Default height
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            buildDimensionInputField(
              label: 'Width',
              controller: widthController,
            ),
            context.dividerWidth(),
            buildDimensionInputField(
              label: 'Height',
              controller: heightController,
            ),
            context.dividerWidth(),
            ElevatedButton(
              onPressed: () {
                final width = double.tryParse(widthController.text) ?? 100.0; // Provide default values as fallback
                final height = double.tryParse(heightController.text) ?? 100.0;
                widget.onSizeChange(Size(width, height));
              },
              child: const Text('Change Size'),
            )
          ],
        ),
      ],
    );
  }

  Widget buildDimensionInputField({
    required String label,
    required TextEditingController controller,
  }) {
    return SizedBox(
      width: 100,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
    );
  }
}
