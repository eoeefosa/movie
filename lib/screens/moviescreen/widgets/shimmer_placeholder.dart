import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPlaceholder extends StatelessWidget {
  const ShimmerPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView(
        padding: EdgeInsets.all(8.w),
        children: [
          Container(
            height: 200.h,
            width: double.infinity,
            color: Colors.grey,
          ),
          const SizedBox(height: 10),
          ...List.generate(5, (index) => shimmerRow(context)),
        ],
      ),
    );
  }

  Widget shimmerRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Container(
        height: 20.h,
        width: double.infinity,
        color: Colors.grey,
      ),
    );
  }
}
