import 'package:flutter/material.dart';

abstract class MexiContent {
  const MexiContent();

  List<Widget> getContents(BuildContext context);
}
