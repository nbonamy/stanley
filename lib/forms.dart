import 'package:flutter/material.dart';
import 'decorator.dart';
import 'dialog.dart';
import 'i18n.dart';
import 'ui_helper.dart';

class FormField extends StatelessWidget {
  static const double valueFontSize = 20;
  static const double labelFontSize = 16;
  static const Color textColor = Colors.white;

  final Widget child;

  const FormField({
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
  final Function onChange;
  final String helpText;
  final String disabledHint;

  const ToggleFormField({
    Key key,
    @required this.label,
    @required this.icon,
    @required this.initialValue,
    @required this.onChange,
    this.helpText,
    this.disabledHint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownField(
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
      onChange: onChange,
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
    return FormField(
        child: TextFormField(
            controller: _controller,
            style: TextStyle(
          color: FormField.textColor,
          fontSize: FormField.valueFontSize,
        ),
            cursorColor: FormField.textColor,
            onChanged: (value) => widget.onChange(value),
            decoration: InputDecoration(
                labelText: widget.label,
          icon: Icon(widget.icon, color: FormField.textColor),
                labelStyle: TextStyle(
                    color: FormField.textColor,
            fontSize: FormField.labelFontSize,
          ),
                fillColor: FormField.textColor,
                focusColor: FormField.textColor,
                hoverColor: FormField.textColor,
                enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: FormField.textColor),
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
      return FormField(
          child: DropdownButtonFormField(
        items: values,
        value: initialValue,
        disabledHint: UIHelper.text(disabledHint,
            color: FormField.textColor.withAlpha(90),
            size: FormField.valueFontSize),
        iconEnabledColor: FormField.textColor,
        selectedItemBuilder: (BuildContext context) {
          return values.map<Widget>((value) {
            return Decorator(
                width:
                    constraints.maxWidth - 72, // yes this is totally arbitrary
                child: UIHelper.text((value.key as ValueKey).value,
                    color: FormField.textColor,
                    size: FormField.valueFontSize,
                    overflow: TextOverflow.ellipsis));
          }).toList();
        },
        decoration: InputDecoration(
            labelText: label,
            icon: Decorator(
                child: Icon(icon, color: FormField.textColor),
                onTap: () => NativeDialog.info(context, helpText)),
            labelStyle: TextStyle(
                color: FormField.textColor, fontSize: FormField.labelFontSize),
            fillColor: FormField.textColor,
            focusColor: FormField.textColor,
            hoverColor: FormField.textColor,
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: FormField.textColor))),
        onChanged: onChange,
      ));
    });
  }

  static List<DropdownMenuItem> getEnumValues(
      BuildContext context, List<dynamic> values) {
    List<DropdownMenuItem> items = new List();
    for (dynamic value in values) {
      items.add(DropdownMenuItem(
          value: value,
          key: ValueKey(I18nUtils.getEnumLabel(value)),
          child: UIHelper.text(I18nUtils.getEnumLabel(value))));
    }
    return items;
  }
}
