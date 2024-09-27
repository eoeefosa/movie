import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:torihd/provider/profile_manager.dart';

class ThreeWayToggle extends StatefulWidget {
  final ThemeModeType themeMode;
  final ValueChanged<ThemeModeType> onChanged;

  const ThreeWayToggle(
      {super.key, required this.themeMode, required this.onChanged});

  @override
  State<ThreeWayToggle> createState() => _ThreeWayToggleState();
}

class _ThreeWayToggleState extends State<ThreeWayToggle> {
  late List<bool> isSelected;

  @override
  void initState() {
    super.initState();
    // Initialize the selection based on the current theme mode
    isSelected = [
      widget.themeMode == ThemeModeType.light,
      widget.themeMode == ThemeModeType.system,
      widget.themeMode == ThemeModeType.dark,
    ];
  }

  @override
  void didUpdateWidget(covariant ThreeWayToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the selection state when the widget is updated
    isSelected = [
      widget.themeMode == ThemeModeType.light,
      widget.themeMode == ThemeModeType.system,
      widget.themeMode == ThemeModeType.dark,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected: isSelected,
      onPressed: (index) {
        setState(() {
          // Set the selected toggle button to true and the others to false
          for (int i = 0; i < isSelected.length; i++) {
            isSelected[i] = i == index;
          }
        });

        // Update the theme mode based on the selected index
        ThemeModeType newMode;
        if (index == 0) {
          newMode = ThemeModeType.light;
        } else if (index == 1) {
          newMode = ThemeModeType.system;
        } else {
          newMode = ThemeModeType.dark;
        }

        widget.onChanged(newMode);
      },
      borderRadius: BorderRadius.circular(8.0),
      selectedColor: Colors.white, // Text color when selected
      fillColor: Colors.green, // Background color when selected
      borderColor: Colors.grey, // Border color for all buttons
      selectedBorderColor: Colors.green, // Border color when selected
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0.w),
          child: const Text("Light"),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0.w),
          child: const Text("System"),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0.w),
          child: const Text("Dark"),
        ),
      ],
    );
  }
}
