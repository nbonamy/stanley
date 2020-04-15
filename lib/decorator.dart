import 'package:flutter/material.dart';
import 'ui_helper.dart';

class Decorator extends StatelessWidget {

  final Widget child;
  final double width;
  final double height;
  final double marginAll;
  final double marginHoriz;
  final double marginVert;
  final double marginLeft;
  final double marginTop;
  final double marginRight;
  final double marginBottom;
  final double paddingAll;
  final double paddingHoriz;
  final double paddingVert;
  final double paddingLeft;
  final double paddingTop;
  final double paddingRight;
  final double paddingBottom;
  final double minWidth;
  final double maxWidth;
  final double minHeight;
  final double maxHeight;
  final Color borderColor;
  final double borderWidth;
  final double borderLeft;
  final double borderTop;
  final double borderRight;
  final double borderBottom;
  final Color backgroundColor;
  final double borderRadius;
  final bool centered;
  final bool fullWidth;
  final Function onTap;

  const Decorator({
    Key key,
    @required this.child,
    this.width,
    this.height,
    this.marginAll = 0,
    this.marginHoriz = -1,
    this.marginVert = -1,
    this.marginLeft = -1,
    this.marginTop = -1,
    this.marginRight = -1,
    this.marginBottom = -1,
    this.paddingAll = 0,
    this.paddingHoriz = -1,
    this.paddingVert = -1,
    this.paddingLeft = -1,
    this.paddingTop = -1,
    this.paddingRight = -1,
    this.paddingBottom = -1,
    this.minWidth = 0.0,
    this.maxWidth = double.infinity,
    this.minHeight = 0.0,
    this.maxHeight = double.infinity,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0.0,
    this.borderLeft = 0.0,
    this.borderTop = 0.0,
    this.borderRight = 0.0,
    this.borderBottom = 0.0,
    this.backgroundColor = Colors.transparent,
    this.borderRadius = 0.0,
    this.centered = false,
    this.fullWidth = false,
    this.onTap,
  }) : super(key: key);

  Widget build(BuildContext context) {

    // start
    Widget result = child;

    // padding
    EdgeInsets padding = UIHelper.calcEdgeInsets(paddingAll, paddingHoriz, paddingVert,
        paddingLeft, paddingTop, paddingRight, paddingBottom);

    // check if container is needed
    if ((width != null || height != null) ||
        (padding.left != 0.0 ||
            padding.top != 0.0 ||
            padding.right != 0.0 ||
            padding.bottom != 0.0) ||
        (minWidth != 0.0 ||
            maxWidth != double.infinity ||
            minHeight != 0.0 ||
            maxHeight != double.infinity) ||
        (borderWidth != 0.0 ||
            borderLeft != 0.0 ||
            borderTop != 0.0 ||
            borderRight != 0.0 ||
            borderBottom != 0.0) ||
        (backgroundColor != Colors.transparent || borderRadius != 0.0)) {

      // adjust border size
      double _borderLeft = (borderLeft != 0.0 ? borderLeft : borderWidth);
      double _borderTop = (borderTop != 0.0 ? borderTop : borderWidth);
      double _borderRight = (borderRight != 0.0 ? borderRight : borderWidth);
      double _borderBottom = (borderBottom != 0.0 ? borderBottom : borderWidth);

      // wrap in container
      result = Container(
          width: width,
          height: height,
          padding: padding,
          alignment: centered ? Alignment.center : null,
          constraints: BoxConstraints(
              minWidth: minWidth,
              maxWidth: maxWidth,
              minHeight: minHeight,
              maxHeight: maxHeight),
          decoration: new BoxDecoration(
              color: backgroundColor,
              borderRadius: borderRadius == 0.0
                  ? null
                  : BorderRadius.all(Radius.circular(borderRadius)),
              border: Border(
                left: BorderSide(
                    color: _borderLeft == 0.0 ? Colors.transparent : borderColor,
                    width: _borderLeft),
                top: BorderSide(
                    color: _borderTop == 0.0 ? Colors.transparent : borderColor,
                    width: _borderTop),
                right: BorderSide(
                    color: _borderRight == 0.0 ? Colors.transparent : borderColor,
                    width: _borderRight),
                bottom: BorderSide(
                    color: _borderBottom == 0.0 ? Colors.transparent : borderColor,
                    width: _borderBottom),
              )),
          child: result);
    }

    // full width
    if (fullWidth) {
      result = SizedBox(width: double.infinity, child: result);
    }

    // tap
    if (onTap != null) {
      result = GestureDetector(onTap: onTap, child: result);
    }

    // margin
    EdgeInsets margin = UIHelper.calcEdgeInsets(marginAll, marginHoriz, marginVert, marginLeft, marginTop, marginRight, marginBottom);
    if (margin.left != 0.0 || margin.top != 0.0 || margin.right != 0.0 || margin.bottom != 0.0) {
      result = Container(
        padding: margin,
        child: result
      );
    }

    // done
    return result;
  }


}

