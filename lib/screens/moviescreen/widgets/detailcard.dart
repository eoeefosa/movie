import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:torihd/provider/profile_manager.dart';

class DetailCard extends StatelessWidget {
  const DetailCard({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileManager>(builder: (context, profileManager, child) {
      return Card(
        color: profileManager.darkMode
            ? Colors.grey.shade700
            : Colors.grey.shade200,
        shape: const RoundedRectangleBorder(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            title,
            style: TextStyle(
              color: profileManager.darkMode
                  ? Colors.grey.shade100
                  : Colors.grey.shade900,
            ),
          ),
        ),
      );
    });
  }
}
