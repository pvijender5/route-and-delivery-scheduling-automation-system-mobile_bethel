/// \[IconTextWidget\] is a stateless widget that displays either an icon or an image
/// alongside a text value. It supports customization of size, color, and dimensions
/// for both the icon and image. If neither an icon nor an image is provided, a default
/// unsupported image icon is displayed.

import 'package:bethel_farm/core/app_values/app_values.dart';
import 'package:bethel_farm/core/widgets/asset_image_view.dart';
import 'package:flutter/material.dart';

class IconTextWidget extends StatelessWidget {
  const IconTextWidget({
    Key? key,
    this.fileName,
    this.icon,
    this.value,
    this.height,
    this.width,
    this.size,
    this.color,
  }) : super(key: key);

  final String? fileName;
  final IconData? icon;
  final String? value;
  final double? height;
  final double? width;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (fileName != null) {
      return _getImage(fileName!);
    } else if (icon != null) {
      return _getIcon(icon!);
    } else {
      return _getIcon(Icons.image_not_supported_outlined);
    }
  }

  Widget _getIcon(IconData iconData) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: size, color: color),
          const SizedBox(width: AppValues.margin_2),
          if (value != null) Text(value!, style: TextStyle(color: color)),
        ],
      ),
    );
  }

  Widget _getImage(String fileName) {
    return Expanded(
      child: Row(
        children: [
          AssetImageView(
            fileName: fileName,
            height: height,
            width: width,
            color: color,
          ),
          const SizedBox(width: AppValues.margin_2),
          if (value != null) Text(value!, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
