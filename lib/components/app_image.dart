import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.path,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    this.color,
  });

  final String path;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Color? color;

  bool get _isNetworkImage =>
      path.startsWith('http://') || path.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    if (_isNetworkImage) {
      return FutureBuilder<bool>(
        future: _isReachable(path),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: height,
              width: width,
              child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }

          if (snapshot.data != true) {
            return Icon(Icons.image_not_supported, size: height ?? 32);
          }

          return Image.network(
            path,
            height: height,
            width: width,
            fit: fit,
            color: color,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.image_not_supported, size: height ?? 32);
            },
          );
        },
      );
    }

    return Image.asset(
      path,
      height: height,
      width: width,
      fit: fit,
      color: color,
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.image_not_supported, size: height ?? 32);
      },
    );
  }

  Future<bool> _isReachable(String url) async {
    try {
      final response = await http.get(Uri.parse(url)).timeout(
            const Duration(seconds: 5),
          );
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (_) {
      return false;
    }
  }
}
