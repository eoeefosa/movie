import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DownloadButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const DownloadButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.grey.shade200,
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
