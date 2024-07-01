import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:homez/core/theming/colors.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    super.key,
    required this.image,
    this.fit = BoxFit.contain,
    this.radius = 8,
    this.height = 200,
    this.filterQuality = FilterQuality.low,
  });

  final String image;
  final BoxFit fit;
  final double radius, height;
  final FilterQuality filterQuality;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CachedNetworkImage(
        filterQuality: filterQuality,
        fit: fit,
        imageUrl: image,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(
          Icons.error_outline,
          color: ColorManager.red,
        ),
      ),
    );
  }
}
