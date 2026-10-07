import 'package:flutter/material.dart';

class ImageUrlHelper {
  const ImageUrlHelper._();

  static String withSize(String url, {int width = 600, int height = 600}) {
    if (url.isEmpty) return url;
    final uri = Uri.parse(url);
    final query = <String, String>{
      ...uri.queryParameters,
      'w': width.toString(),
      'h': height.toString(),
    };
    return uri.replace(queryParameters: query).toString();
  }
}

class SafeNetworkImage extends StatelessWidget {
  const SafeNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return placeholder ??
          const SizedBox(
            width: 64,
            height: 64,
            child: Center(child: Icon(Icons.image_not_supported_outlined)),
          );
    }

    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) =>
          placeholder ?? const Center(child: Icon(Icons.broken_image_outlined)),
    );
  }
}
