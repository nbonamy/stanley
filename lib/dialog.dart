import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stanley/stanley.dart';
import 'decorator.dart';
import 'i18n.dart';
import 'ui_helper.dart';

class AlertDialogAction {
  final String label;
  final Color color;
  final bool noUpperCase;
  final bool isDefault;
  final bool autoDismiss;
  final Function onTap;

  AlertDialogAction({
    @required this.label,
    this.color,
    this.noUpperCase = false,
    this.isDefault = false,
    this.autoDismiss = true,
    this.onTap,
  });

  static AlertDialogAction cancel({
    String label,
    bool isDefault = false,
    bool autoDismiss = true,
    Function onTap,
  }) {
    // default value
    if (label == null) {
      label = I18nUtils.t('cancel');
    }

    // fallback
    return AlertDialogAction(
      label: label,
      color: NativeDialog.alertCancelColor,
      isDefault: isDefault,
      autoDismiss: autoDismiss,
      onTap: onTap,
    );
  }

  Function getOnTap(BuildContext context) {
    return () {
      if (this.autoDismiss) {
        Navigator.of(context).pop();
      }
      if (this.onTap != null) {
        this.onTap();
      }
    };
  }
}

class NativeDialog {
  // for debugging purposes
  static bool isIOS = Platform.isIOS;
  static bool isAndroid = !NativeDialog.isIOS;

  static double alertFontSize = NativeDialog.isIOS ? 19 : 18;
  static Color alertCancelColor =
      NativeDialog.isIOS ? Color(0xfff1453d) : Color(0xffad2323);
  static Color alertConfirmColor = Color(0xff0a620c);
  static Color alertNeutralColor = Colors.blue;

  static int materialVerticalDialogThreshold = 2;
  static double materialDialogVerticalButtonPaddingHoriz = 8;
  static double materialDialogVerticalButtonPaddingVert = 16;

  static double materialSheetButtonPaddingHoriz = 4;
  static double materialSheetButtonPaddingVert = 8;
  static double materialSheetButtonBottomMargin = 0;
  static double materialSheetFontSize = alertFontSize;
  static bool materialSheetBold = false;
  static bool materialSheetUpperCase = false;

  static dynamic info(BuildContext context, String message, {Function onTap}) {
    NativeDialog.alert(
      context: context,
      content: message,
      actions: [
        AlertDialogAction(
          label: I18nUtils.t('ok'),
          onTap: onTap,
        ),
      ],
    );
  }

  static dynamic alert({
    @required BuildContext context,
    dynamic title,
    dynamic content,
    @required List<AlertDialogAction> actions,
    AlertDialogAction cancelAction,
    bool modal = true,
  }) {
    // need at least some info
    if (title == null && content == null) {
      return;
    }

    // check
    List<Widget> buttons = _buildButtons(
      context,
      actions,
      cancelAction,
      bold: isAndroid,
    );
    int buttonCount = buttons.length;
    if (buttonCount == 0) {
      return;
    }

    // build title and content
    if (title is String) {
      title = UIHelper.text(
        title,
        family: null,
        size: NativeDialog.alertFontSize,
        weight: FontWeight.bold,
      );
    }
    if (content is String) {
      content = UIHelper.text(
        content,
        family: null,
        size: NativeDialog.alertFontSize,
      );
    }

    // set up the AlertDialog
    Widget alert;
    if (NativeDialog.isIOS) {
      alert = CupertinoAlertDialog(
        title: title,
        content: content,
        actions: buttons,
      );
    } else {
      // vertical if more than two options
      if (buttonCount > materialVerticalDialogThreshold) {
        buttons = [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: buttons,
          )
        ];
      }

      // show it
      alert = AlertDialog(
        title: title,
        content: content,
        actions: buttons,
      );
    }

    // show the dialog
    return showDialog(
      context: context,
      barrierDismissible: !modal,
      builder: (context) => alert,
    );
  }

  static void bottomSheet({
    @required BuildContext context,
    String title,
    @required List<AlertDialogAction> actions,
    AlertDialogAction cancelAction,
    bool forceMaterial = false,
    Color titleColor,
    double height,
  }) {
    // depends on platform
    if (forceMaterial == false && NativeDialog.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          title: UIHelper.text(title, size: alertFontSize),
          actions: _buildButtons(context, actions, null),
          cancelButton: cancelAction == null
              ? null
              : _buildButtons(context, null, cancelAction).first,
        ),
      );
    } else {
      // height
      if (height == null) {
        int itemCount = (title == null ? 0 : 1) +
            (actions == null ? 0 : actions.length) +
            (cancelAction == null ? 0 : 1);
        double itemHeight = NativeDialog.alertFontSize * 1.5 +
            materialSheetButtonPaddingVert * 2;
        double maxHeight = MediaQuery.of(context).size.height * 0.66;
        height = min(maxHeight,
            itemCount * itemHeight + materialSheetButtonBottomMargin);
      }

      // build title
      Widget titleWidget = Align(
        alignment: Alignment.topRight,
        child: Decorator(
          paddingBottom: 8,
          child: UIHelper.text(
            title?.toUpperCase(),
            size: 16,
            color: titleColor,
            bold: true,
            align: TextAlign.end,
          ),
        ),
      );

      // build buttons
      List<Widget> buttons = _buildButtons(
        context,
        actions,
        cancelAction,
        forceMaterial: forceMaterial,
        paddingVert: materialSheetButtonPaddingVert,
        paddingHoriz: materialSheetButtonPaddingHoriz,
        size: materialSheetFontSize,
        bold: materialSheetBold,
        uppercase: materialSheetUpperCase,
        color: Colors.black,
        align: TextAlign.end,
      );

      // show it
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => Decorator(
          fullWidth: true,
          height: height,
          borderColor: Colors.black.withAlpha(80),
          borderTop: 1,
          child: Decorator(
            paddingAll: 16,
            child: Column(
              children: [
                titleWidget,
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: buttons,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }

  static List<Widget> _buildButtons(
    BuildContext context,
    List<AlertDialogAction> actions,
    AlertDialogAction cancelAction, {
    bool forceMaterial = false,
    double paddingVert,
    double paddingHoriz,
    bool uppercase,
    double size,
    bool bold,
    Color color,
    TextAlign align,
    Widget leading,
  }) {
    // render in one pass
    List<AlertDialogAction> actionsToRender = List();
    if (actions != null) {
      actionsToRender.addAll(actions);
    }
    actionsToRender.add(cancelAction);

    // now render them all
    List<Widget> buttons = new List();
    for (AlertDialogAction action in actionsToRender) {
      // we may allow null
      if (action == null) {
        continue;
      }

      // depends on platform
      if (forceMaterial == false && NativeDialog.isIOS) {
        buttons.add(_iosButton(context: context, action: action, size: size));
      } else {
        // build
        buttons.add(_androidButton(
          context: context,
          action: action,
          paddingHoriz: paddingHoriz,
          paddingVert: paddingVert,
          uppercase: uppercase,
          size: size,
          bold: bold,
          color: color,
          align: align,
          leading: leading,
        ));
      }
    }

    // done
    return buttons;
  }

  static Widget _androidButton({
    BuildContext context,
    AlertDialogAction action,
    double paddingVert,
    double paddingHoriz,
    bool uppercase,
    double size,
    bool bold,
    Color color,
    TextAlign align,
    Widget leading,
  }) {
    // widget
    Widget label = UIHelper.text(
      (uppercase == false) ? action.label : action.label.toUpperCase(),
      family: null,
      size: size ?? NativeDialog.alertFontSize,
      color: action.color ?? color ?? NativeDialog.alertConfirmColor,
      align: align ?? TextAlign.right,
      bold: (action.isDefault == true || bold == true),
    );

    // leading
    if (leading != null) {
      label = Row(
        children: [leading, label],
      );
    }

    // done
    return Decorator(
      paddingVert: paddingVert ?? materialDialogVerticalButtonPaddingVert,
      paddingHoriz: paddingHoriz ?? materialDialogVerticalButtonPaddingHoriz,
      child: label,
      onTap: action.getOnTap(context),
    );
  }

  static Widget _iosButton({
    BuildContext context,
    AlertDialogAction action,
    double size,
  }) {
    // widget
    Widget label = UIHelper.text(
      action.label,
      family: null,
      color: action.color,
      size: size ?? NativeDialog.alertFontSize,
    );

    // build
    return CupertinoActionSheetAction(
      child: label,
      isDefaultAction: action.isDefault,
      onPressed: action.getOnTap(context),
    );
  }
}
