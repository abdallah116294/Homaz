import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleImageWidget extends StatelessWidget {
  const CircleImageWidget({
    super.key,
    required this.image,
    this.size = 60,
  });
  final String image;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.h,
      width: size.h,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Image.network(
        image,
        fit: BoxFit.cover,
      ),
    );
  }
}
