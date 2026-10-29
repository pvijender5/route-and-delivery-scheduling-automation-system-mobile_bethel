/// \[AppBarTitle\] is a stateless widget that displays a text title
/// in the app bar. The text is centered and can be customized
/// by passing a string to the \[text\] parameter.

import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  final String text;

  const AppBarTitle({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        // style: pageTitleStyle,
        textAlign: TextAlign.center);
  }
}
