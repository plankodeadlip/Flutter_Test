
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgHelper {
  /// Decode Base64 string to SVG string
  static String decodeBase64ToSvg(String base64String) {
    try {
      final bytes = base64.decode(base64String);
      return utf8.decode(bytes);
    } catch (e) {
      print('❌ Error decoding Base64: $e');
      return '';
    }
  }

  /// Build SVG widget from Base64 string
  static Widget buildSvgFromBase64({
    required String base64String,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
  }) {
    try {
      final svgString = decodeBase64ToSvg(base64String);

      if (svgString.isEmpty) {
        return _buildErrorIcon(width, height);
      }

      return SvgPicture.string(
        svgString,
        width: width,
        height: height,
        fit: fit,
        colorFilter: color != null
            ? ColorFilter.mode(color, BlendMode.srcIn)
            : null,
      );
    } catch (e) {
      print('❌ Error building SVG: $e');
      return _buildErrorIcon(width, height);
    }
  }

  /// Fallback icon when SVG fails to load
  static Widget _buildErrorIcon(double? width, double? height) {
    return Icon(
      Icons.image_not_supported,
      size: width ?? height ?? 24,
      color: Colors.grey,
    );
  }

  /// Build circular avatar with SVG icon
  static Widget buildCircleAvatar({
    required String base64String,
    double radius = 20,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? Colors.grey.shade200,
      child: buildSvgFromBase64(
        base64String: base64String,
        width: radius * 1.2,
        height: radius * 1.2,
        color: iconColor,
      ),
    );
  }
}