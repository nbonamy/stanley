import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'decorator.dart';
import 'dialog.dart';
import 'i18n.dart';
import 'ui_helper.dart';

class PaddedFormField extends StatelessWidget {

  static double valueFontSize = 20;
  static double labelFontSize = 16;
  static Color textColor = Colors.black;

  final Widget child;

  const PaddedFormField({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Decorator(child: child, paddingBottom: 32);
  }
}

class ToggleFormField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool initialValue;
  final Function onTap;
  final String helpText;
  final String disabledHint;

  const ToggleFormField({
    Key key,
    @required this.label,
    @required this.icon,
    @required this.initialValue,
    @required this.onTap,
    this.helpText,
    this.disabledHint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AbsorbPointer(
        child: DropdownField(
          label: label,
          icon: icon,
          helpText: helpText,
          initialValue: initialValue,
          disabledHint: disabledHint,
          values: [
            DropdownMenuItem(
                value: false,
                key: ValueKey(I18nUtils.t('no')),
                child: UIHelper.text(I18nUtils.t('no'))),
            DropdownMenuItem(
                value: true,
                key: ValueKey(I18nUtils.t('yes')),
                child: UIHelper.text(I18nUtils.t('yes'))),
          ],
          onChange: onTap == null ? null : (_) {},
        ),
      ),
      onTap: onTap,
    );
  }
}

class DecoratedTextFormField extends StatefulWidget {

  final String label;
  final String value;
  final IconData icon;
  final Function onChange;

  const DecoratedTextFormField(
      {Key key,
      @required this.label,
      @required this.value,
      this.icon,
      @required this.onChange})
      : super(key: key);

  @override
  _DecoratedTextFormFieldState createState() => _DecoratedTextFormFieldState();
}

class _DecoratedTextFormFieldState extends State<DecoratedTextFormField> {
  TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController();
    _controller.text = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return PaddedFormField(
      child: TextFormField(
        controller: _controller,
        style: TextStyle(
          color: PaddedFormField.textColor,
          fontSize: PaddedFormField.valueFontSize,
        ),
        cursorColor: PaddedFormField.textColor,
        onChanged: (value) => widget.onChange(value),
        decoration: InputDecoration(
          labelText: widget.label,
          icon: Icon(widget.icon, color: PaddedFormField.textColor),
          labelStyle: TextStyle(
            color: PaddedFormField.textColor,
            fontSize: PaddedFormField.labelFontSize,
          ),
          fillColor: PaddedFormField.textColor,
          focusColor: PaddedFormField.textColor,
          hoverColor: PaddedFormField.textColor,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: PaddedFormField.textColor),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: PaddedFormField.textColor),
          ),
        ),
      ),
    );
  }
}

class DropdownField extends StatelessWidget {
  final String label;
  final IconData icon;
  final dynamic initialValue;
  final List<DropdownMenuItem> values;
  final String helpText;
  final String disabledHint;
  final Function onChange;

  const DropdownField(
      {Key key,
      @required this.label,
      @required this.initialValue,
      @required this.values,
      this.icon,
      this.helpText,
      this.disabledHint,
      this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return PaddedFormField(
          child: DropdownButtonFormField(
        items: values,
        value: initialValue,
        disabledHint: UIHelper.text(
          disabledHint,
          color: PaddedFormField.textColor.withAlpha(90),
          size: PaddedFormField.valueFontSize,
        ),
        iconEnabledColor: PaddedFormField.textColor,
        selectedItemBuilder: (BuildContext context) {
          return values.map<Widget>((value) {
            return Decorator(
              width: constraints.maxWidth - 72, // yes this is totally arbitrary
              child: UIHelper.text(
                (value.key as ValueKey).value,
                color: PaddedFormField.textColor,
                size: PaddedFormField.valueFontSize,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList();
        },
        decoration: InputDecoration(
          labelText: label,
          icon: Decorator(
              child: Icon(
                icon,
                color: PaddedFormField.textColor,
              ),
              onTap: () => NativeDialog.info(context, helpText)),
          labelStyle: TextStyle(
            color: PaddedFormField.textColor,
            fontSize: PaddedFormField.labelFontSize,
          ),
          fillColor: PaddedFormField.textColor,
          focusColor: PaddedFormField.textColor,
          hoverColor: PaddedFormField.textColor,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: PaddedFormField.textColor),
          ),
        ),
        onChanged: onChange,
      ));
    });
  }

  static List<DropdownMenuItem> getEnumValues(
      BuildContext context, List<dynamic> values) {
    List<DropdownMenuItem> items = new List();
    for (dynamic value in values) {
      items.add(
        DropdownMenuItem(
          value: value,
          key: ValueKey(I18nUtils.getEnumLabel(value)),
          child: UIHelper.text(I18nUtils.getEnumLabel(value)),
        ),
      );
    }
    return items;
  }
}
