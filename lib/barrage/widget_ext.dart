import 'package:flutter/cupertino.dart';

extension SQWidgetExt on Widget {
  sq_corner(double corner) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(corner),
        child: this,
      ),
    );
  }

  sq_hide(bool hide) {
    return Offstage(
      offstage: hide,
      child: this,
    );
  }
}

extension SQDropNull on String {
  dropNull({String defaultStr = ''}) {
    if (this == 'null') {
      return defaultStr;
    }
    return this;
  }
}
