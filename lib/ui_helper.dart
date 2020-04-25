import 'package:flutter/material.dart';
import 'decorator.dart';

class UIHelper {
  static Text text(
    String text, {
    String family,
    FontWeight weight,
    bool bold = false,
    double size,
    Color color,
    int maxLines,
    TextOverflow overflow,
    TextAlign align,
  }) {
    // check
    if (text == null) {
      return null;
    }

    // weight
    if (weight == null && bold == true) {
      weight = FontWeight.bold;
    }

    // done
    return Text(
      text,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontFamily: family,
        fontSize: size,
        fontWeight: weight,
        color: color,
      ),
    );
  }

  static Scaffold scaffold({
    @required String title,
    Color appBarColor,
    @required Widget widget,
    Widget leading,
    List<Widget> actions,
    Color backgroundColor = Colors.white,
    Color underlineColor,
    double paddingAll = 8,
    double paddingHoriz = -1,
    double paddingVert = -1,
    double paddingLeft = -1,
    double paddingTop = -1,
    double paddingRight = -1,
    double paddingBottom = -1,
    bool scroll = false,
    ScrollPhysics scrollPhysics,
    Widget bottomBar,
  }) {
    // add padding
    Widget result = Padding(
      padding: UIHelper.calcEdgeInsets(
        paddingAll,
        paddingHoriz,
        paddingVert,
        paddingLeft,
        paddingTop,
        paddingRight,
        paddingBottom,
      ),
      child: widget,
    );

    // scroll
    if (scroll) {
      result = SingleChildScrollView(
        physics: scrollPhysics,
        child: result,
      );
    }

    // done
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: UIHelper.appBar(
        title: title,
        backgroundColor: appBarColor,
        leading: leading,
        actions: actions,
        lineColor: underlineColor,
      ),
      body: result,
      bottomNavigationBar: bottomBar,
    );
  }

  static Widget appBar({
    @required String title,
    Color backgroundColor,
    Widget leading,
    List<Widget> actions,
    Color lineColor,
  }) {
    return AppBar(
      title: UIHelper.text(title),
      centerTitle: true,
      leading: leading,
      actions: actions,
      backgroundColor: backgroundColor,
      elevation: (lineColor == null
          ? null
          : (lineColor == Colors.transparent ? 0 : 0.6)),
      shape: lineColor == null
          ? null
          : Border(
              bottom: BorderSide(
                color: lineColor,
              ),
            ),
    );
  }

  static Widget appBarAction({
    String label,
    Function onTap,
  }) {
    return Center(
      child: Decorator(
        child: UIHelper.text(
          label,
          size: 20,
        ),
        paddingHoriz: 16,
        onTap: onTap,
      ),
    );
  }

  static Widget appBarIcon({
    IconData icon,
    Function onTap,
  }) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onTap,
    );
  }

  static EdgeInsets calcEdgeInsets(
    double edgeAll,
    double edgeHoriz,
    double edgeVert,
    double edgeLeft,
    double edgeTop,
    double edgeRight,
    double edgeBottom,
  ) {
    // paddding
    double left = edgeAll;
    double top = edgeAll;
    double right = edgeAll;
    double bottom = edgeAll;
    if (edgeHoriz != -1) {
      left = edgeHoriz;
      right = edgeHoriz;
    }
    if (edgeVert != -1) {
      top = edgeVert;
      bottom = edgeVert;
    }
    if (edgeLeft != -1) {
      left = edgeLeft;
    }
    if (edgeTop != -1) {
      top = edgeTop;
    }
    if (edgeRight != -1) {
      right = edgeRight;
    }
    if (edgeBottom != -1) {
      bottom = edgeBottom;
    }

    // done
    return EdgeInsets.fromLTRB(
      left,
      top,
      right,
      bottom,
    );
  }
}
