/// \[Loading\] is a stateless widget that displays a centered loading indicator.
/// It uses the \[ElevatedContainer\] widget to provide padding and styling
/// around a \[CircularProgressIndicator\], ensuring consistent design.
import 'package:bethel_farm/core/app_colors/app_colors.dart';
import 'package:bethel_farm/core/app_values/app_values.dart';
import 'package:bethel_farm/core/widgets/elevated_container.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedContainer(
        padding: EdgeInsets.all(AppValues.margin),
        child: CircularProgressIndicator(
          color: AppColors.colorPrimary,
        ),
      ),
    );
  }
}
