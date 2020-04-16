import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'decorator.dart';
import 'ui_helper.dart';

class AlertDialogAction {

  dynamic text;
  bool isDefault;
  Function onTap;
  AlertDialogAction({
    @required this.text,
    @required this.onTap,
    this.isDefault = false,
  });

  static AlertDialogAction cancel(BuildContext context, {
    String label,
    bool isDefault = false,
    bool autoDismiss = true,
    Function onTap,
  }) {

    // default value
    if (label == null) label = tr("cancel");

    // fallback
    return AlertDialogAction.build(
      context,
      label: label,
      color: NativeDialog.alertCancelColor,
      isDefault: isDefault,
      autoDismiss: autoDismiss,
      onTap: onTap,
    );
  }

  static AlertDialogAction build(BuildContext context, {
    dynamic label,
    Color color,
    bool noUpperCase = false,
    bool isDefault = false,
    bool autoDismiss = true,
    Function onTap,
  }) {

    // build the label
    if (label is String) {

      // android is upper case
      if (NativeDialog.isAndroid) {
        label = label.toString();
      }

      // now make it a widget
      if (color != null) {
        label = AlertDialogAction.label(
          label,
          color: color
        );
      }

    }

    return AlertDialogAction(
      text: (label is String && NativeDialog.isAndroid && noUpperCase == false) ? label.toUpperCase() : label,
      isDefault: isDefault,
      onTap: () {
        if (autoDismiss) {
          Navigator.pop(context);
        }
        if (onTap != null) {
          onTap();
        }
      }
    );
  }

  static Widget label(String label, { double size, Color color }) {
    return UIHelper.text(
      NativeDialog.isAndroid ? label.toUpperCase() : label,
      size: size != null ? size : NativeDialog.alertFontSize,
      color: color,
      bold: NativeDialog.isAndroid ? true : null,
    );
  }

}

class NativeDialog {

  // for debugging purposes
  static bool isIOS = Platform.isIOS;
  static bool isAndroid = !NativeDialog.isIOS;

  static double alertFontSize = NativeDialog.isIOS ? 19 : 18;
  static Color alertCancelColor = NativeDialog.isIOS ? Color(0xfff1453d) : Color(0xffad2323);
  static Color alertConfirmColor = Color(0xff0a620c);

  static int materialVerticalDialogThreshold = 2;
  static double materialVerticalButtonPaddingRight = 8;
  static double materialVerticalButtonPaddingVert = 16;

  static dynamic info(BuildContext context,String message) {
    NativeDialog.alert(
      context: context,
      content: message,
      actions: [
        AlertDialogAction.build(context, label: tr("ok"))
      ]
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
    List<Widget> buttons = _buildButtons(actions, cancelAction);
    int buttonCount = buttons.length;
    if (buttonCount == 0) {
      return;
    }

    // build title and content
    if (title is String) {
      title = UIHelper.text(title, family: null, size: NativeDialog.alertFontSize, weight: FontWeight.bold);
    }
    if (content is String) {
      content = UIHelper.text(content, family: null, size: NativeDialog.alertFontSize);
    }

    // set up the AlertDialog
    Widget alert;
    if (NativeDialog.isIOS) {

      alert = CupertinoAlertDialog(title: title, content: content, actions: buttons);

    } else {

      // vertical if more than two options
      if (buttonCount > materialVerticalDialogThreshold) {
        buttons = [ Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: buttons
        )];
      }

      // show it
      alert = AlertDialog(title: title, content: content, actions: buttons);
    }

    // show the dialog
    return showDialog(
      context: context,
      barrierDismissible: !modal,
      builder: (context) => alert
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
          actions: _buildButtons(actions, null),
          cancelButton: cancelAction == null ? null : _buildButtons(null, cancelAction).first
        )
      );

    } else {

      // height
      if (height == null) {
        height = MediaQuery.of(context).size.height * 0.66;
      }

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
                Align(
                  alignment: Alignment.topRight,
                  child: Decorator(
                    paddingBottom: 8,
                    child: UIHelper.text(
                      title.toUpperCase(),
                      size: 16,
                      color: titleColor,
                      bold: true, align:
                      TextAlign.end)
                  )
                ),
                Expanded(child: ListView(
                  shrinkWrap: true,
                  children: _buildButtons(
                    actions, null,
                    //leading: Decorator(
                    //  paddingRight: 6,
                    //  child: Icon(Icons.brightness_1, size: 8, color: Color(0xff707070))
                    //),
                    forceMaterial: forceMaterial,
                    paddingVert: 8, paddingHoriz: 4,
                    size: 16, bold: false, uppercase: false,
                    color: Colors.black,
                    align: TextAlign.end
                  )
                ))
              ]
            )
          )
        )
      );

    }

  }

  static List<Widget> _buildButtons(
    List<AlertDialogAction> actions,
    AlertDialogAction cancelAction,
    {
      bool forceMaterial = false,
      double paddingVert, double paddingHoriz,
      bool uppercase, double size, bool bold,
      Color color, TextAlign align, Widget leading,
    }
  ) {

      // buttons
    List<Widget> buttons = new List();
    int buttonCount = (actions == null ? 0 : actions.length) + (cancelAction == null ? 0 : 1);

    // each button
    if (actions != null) {

      for (AlertDialogAction action in actions) {

        // we may allow null
        if (action == null) {
          continue;
        }

        // depends on platform
        if (forceMaterial == false && NativeDialog.isIOS) {

          // widget
          if (action.text is String) {
            action.text = UIHelper.text(action.text, family: null, size: NativeDialog.alertFontSize);
          }

          // build
          buttons.add(CupertinoActionSheetAction(
            child: action.text,
            isDefaultAction: action.isDefault,
            onPressed: action.onTap
          ));

        } else {

          // widget
          if (action.text is String) {
            action.text = UIHelper.text(
              (uppercase == false) ? action.text : action.text.toUpperCase(),
              family: null,
              size: size ?? NativeDialog.alertFontSize,
              color: color ?? NativeDialog.alertConfirmColor,
              align: align ?? (buttonCount > materialVerticalDialogThreshold ? TextAlign.right : null),
              bold: bold ?? true//action.isDefault
            );
          }

          // leading
          if (leading != null) {
            action.text = Row(children: [ leading, action.text ]);
          }

          // build
          buttons.add(Decorator(
            paddingVert: paddingVert ?? materialVerticalButtonPaddingVert,
            paddingRight: paddingHoriz ?? materialVerticalButtonPaddingRight,
            paddingLeft: paddingHoriz ?? 0,
            child: action.text,
            onTap: action.onTap
          ));

        }
      }
    }

    // cancel
    if (cancelAction != null) {

      if (forceMaterial == false && NativeDialog.isIOS) {

        // widget
        if (cancelAction.text is String) {
          cancelAction.text = UIHelper.text(cancelAction.text, family: null, size: NativeDialog.alertFontSize, color: NativeDialog.alertCancelColor);
        }

        // build
        buttons.add(CupertinoActionSheetAction(
          child: cancelAction.text,
          isDefaultAction: cancelAction.isDefault,
          onPressed: cancelAction.onTap,
        ));

      } else {

        // widget
        if (cancelAction.text is String) {
          cancelAction.text = UIHelper.text(
            cancelAction.text.toUpperCase(),
            family: null,
            size: size ?? NativeDialog.alertFontSize,
            color: color ?? NativeDialog.alertCancelColor,
            align: align ?? buttonCount > materialVerticalDialogThreshold ? TextAlign.right : null,
            bold: bold ?? true//cancelAction.isDefault
          );
        }

        // build
        buttons.add(Decorator(
          paddingVert: paddingVert ?? materialVerticalButtonPaddingVert,
          paddingRight: paddingHoriz ?? materialVerticalButtonPaddingRight,
          paddingLeft: paddingHoriz ?? 0,
          child: cancelAction.text,
          onTap: cancelAction.onTap,
        ));

      }
    }

    // done
    return buttons;

  }

}
