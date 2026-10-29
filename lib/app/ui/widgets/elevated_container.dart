/// \[ElevatedContainer\] is a stateless widget that wraps its child widget
/// with a container that has customizable padding, background color, border radius,
/// and an elevated shadow effect. It is designed to enhance the visual appearance
/// of its child widget.

import 'package:bethel_farm/core/app_colors/app_colors.dart';
import 'package:bethel_farm/core/app_values/app_values.dart';
import 'package:flutter/material.dart';

class ElevatedContainer extends StatelessWidget {
  final Widget child;
  final Color bgColor;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const ElevatedContainer({
    Key? key,
    required this.child,
    this.bgColor = AppColors.pageBackground,
    this.padding,
    this.borderRadius = AppValues.smallRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
                color: AppColors.elevatedContainerColorOpacity,
                spreadRadius: 3,
                blurRadius: 8,
                offset: const Offset(0, 3) // changes position of shadow
                ),
          ],
          color: AppColors.pageBackground),
      child: child,
    );
  }
}
