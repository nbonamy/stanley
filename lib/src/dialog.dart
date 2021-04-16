import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stanley/src/decorator.dart';
import 'package:stanley/src/i18n.dart';
import 'package:stanley/src/ui_helper.dart';

class AlertDialogAction {
  final String label;
  final Color color;
  final bool isDefault;
  final bool autoDismiss;
  final Function onTap;

  AlertDialogAction({
    @required this.label,
    this.color,
    this.isDefault = false,
    this.autoDismiss = true,
    this.onTap,
  });

  static AlertDialogAction confirm({
    String label,
    bool isDefault = false,
    bool autoDismiss = true,
    Function onTap,
  }) {
    // default value
    if (label == null) {
      label = I18nUtils.t('ok');
    }

    // fallback
    return AlertDialogAction(
      label: label,
      color: NativeDialog.isIOS ? null : NativeDialog.alertConfirmColor,
      isDefault: isDefault,
      autoDismiss: autoDismiss,
      onTap: onTap,
    );
  }

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

  static double alertFontSize = NativeDialog.isIOS ? 17 : 18;

  static Color alertCancelColor =
      NativeDialog.isIOS ? CupertinoColors.destructiveRed : Color(0xffd32f2f);
  static Color alertConfirmColor =
      NativeDialog.isIOS ? CupertinoColors.activeBlue : Color(0xff2e7d32);
  static Color alertNeutralColor =
      NativeDialog.isIOS ? CupertinoColors.activeBlue : Color(0xff1976d2);

  static int materialVerticalDialogThreshold = 2;
  static double materialDialogVerticalButtonPaddingHoriz = 8;
  static double materialDialogVerticalButtonPaddingVert = 16;

  static double materialSheetButtonPaddingHoriz = 4;
  static double materialSheetButtonPaddingVert = 8;
  static double materialSheetButtonBottomMargin = 0;
  static bool materialSheetBold = false;
  static bool materialSheetUpperCase = false;
  static Color materialSheetActionColor = alertNeutralColor;

  static double get alertTitleFontSize {
    return Platform.isIOS ? alertFontSize : alertFontSize;
  }

  static double get alertContentFontSize {
    return Platform.isIOS ? alertFontSize - 3 : alertFontSize;
  }

  static double get alertActionsFontSize {
    return alertFontSize;
  }

  static double get sheetActionsFontSize {
    return alertFontSize + 2;
  }

  static double get materialSheetFontSize {
    return alertFontSize + 1;
  }

  static FontWeight get normalFontWeight {
    return NativeDialog.isIOS ? FontWeight.w400 : FontWeight.normal;
  }

  static FontWeight get boldFontWeight {
    return NativeDialog.isIOS ? FontWeight.w500 : FontWeight.bold;
  }

  static dynamic info(
    BuildContext context,
    String message, {
    Function onTap,
  }) {
    return NativeDialog.alert(
      context: context,
      title: message,
      actions: [
        AlertDialogAction(
          label: I18nUtils.t('ok'),
          onTap: onTap,
        ),
      ],
    );
  }

  static dynamic confirm(
    BuildContext context,
    String message,
    Function onTap, {
    bool destructive = false,
  }) {
    // actions
    List<AlertDialogAction> actions = [
      AlertDialogAction(
        label: I18nUtils.t('no'),
        color: destructive
            ? NativeDialog.alertConfirmColor
            : NativeDialog.alertCancelColor,
        isDefault: destructive,
      ),
      AlertDialogAction(
        label: I18nUtils.t('yes'),
        color: destructive
            ? NativeDialog.alertCancelColor
            : NativeDialog.alertConfirmColor,
        isDefault: !destructive,
        onTap: onTap,
      ),
    ];

    // destructive should not be default
    if (destructive) {
      actions = actions.reversed.toList();
    }

    // show
    return NativeDialog.alert(
      context: context,
      title: message,
      actions: actions,
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
        size: alertTitleFontSize,
        weight: content == null ? normalFontWeight : boldFontWeight,
      );
    }
    if (content is String) {
      content = UIHelper.text(
        content,
        family: null,
        size: alertContentFontSize,
        weight: normalFontWeight,
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
    if (NativeDialog.isIOS) {
      return showCupertinoDialog(
        context: context,
        builder: (context) => alert,
      );
    } else {
      return showDialog(
        context: context,
        barrierDismissible: !modal,
        builder: (context) => alert,
      );
    }
  }

  static void bottomSheet({
    @required BuildContext context,
    String title,
    String content,
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
          title: UIHelper.text(
            title,
            size: alertContentFontSize,
            weight: boldFontWeight,
          ),
          message: UIHelper.text(
            content,
            size: alertContentFontSize,
          ),
          actions: _buildButtons(
            context,
            actions,
            null,
            forActionSheet: true,
          ),
          cancelButton: cancelAction == null
              ? null
              : _buildButtons(
                  context,
                  null,
                  cancelAction,
                  forActionSheet: true,
                ).first,
        ),
      );
    } else {
      // height
      if (height == null) {
        int itemCount = (title == null ? 0 : 1) +
            (actions == null ? 0 : actions.length) +
            (cancelAction == null ? 0 : 1);
        double itemHeight =
            materialSheetFontSize * 1.5 + materialSheetButtonPaddingVert * 2;
        double maxHeight = MediaQuery.of(context).size.height * 0.66;
        height = min(
          maxHeight,
          itemCount * itemHeight + materialSheetButtonBottomMargin,
        );
      }

      // build title
      Widget titleWidget = Align(
        alignment: Alignment.topRight,
        child: Decorator(
          paddingBottom: 8,
          child: UIHelper.text(
            title?.toUpperCase(),
            size: alertTitleFontSize,
            color: titleColor,
            weight: boldFontWeight,
            align: TextAlign.end,
          ),
        ),
      );

      // build buttons
      List<Widget> buttons = _buildButtons(
        context,
        actions,
        cancelAction,
        forActionSheet: true,
        forceMaterial: forceMaterial,
        paddingVert: materialSheetButtonPaddingVert,
        paddingHoriz: materialSheetButtonPaddingHoriz,
        size: materialSheetFontSize,
        bold: materialSheetBold,
        uppercase: materialSheetUpperCase,
        color: materialSheetActionColor,
        align: TextAlign.end,
      );

      // show it
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => Decorator(
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
    bool forActionSheet = false,
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
    List<AlertDialogAction> actionsToRender = [];
    if (actions != null) {
      actionsToRender.addAll(actions);
    }
    actionsToRender.add(cancelAction);

    // now render them all
    List<Widget> buttons = [];
    for (AlertDialogAction action in actionsToRender) {
      // we may allow null
      if (action == null) {
        continue;
      }

      // depends on platform
      if (forceMaterial == false && NativeDialog.isIOS) {
        buttons.add(_iosButton(
          context: context,
          action: action,
          forActionSheet: forActionSheet,
          size: size,
        ));
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
      size: size ?? alertActionsFontSize,
      color: action.color ?? color ?? NativeDialog.alertNeutralColor,
      align: align ?? TextAlign.right,
      bold: (action.isDefault == true || bold == true),
    );

    // leading
    if (leading != null) {
      label = Row(
        children: [
          leading,
          label,
        ],
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
    bool forActionSheet,
    double size,
  }) {
    // widget
    Widget label = UIHelper.text(
      action.label,
      family: null,
      weight: action.isDefault ? boldFontWeight : normalFontWeight,
      color: action.color ?? CupertinoColors.systemBlue,
      size: size ??
          (forActionSheet ? sheetActionsFontSize : alertActionsFontSize),
    );

    // build
    if (forActionSheet) {
      return CupertinoActionSheetAction(
        child: label,
        isDefaultAction: action.isDefault,
        onPressed: action.getOnTap(context),
      );
    } else {
      return TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: label,
        onPressed: action.getOnTap(context),
      );
    }
  }
}
