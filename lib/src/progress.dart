import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Progress extends StatelessWidget {
  final Color color;
  const Progress({
    Key key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoActivityIndicator();
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
      );
    }
  }
}
