import 'package:flutter/material.dart';

import 'decorator.dart';

class SettingsStyles {
  static TextStyle sectionTitleStyle =
      TextStyle(fontSize: 13.0, color: Color(0xff6d6d71));
  static Color sectionBgColor = Color(0xfff2f2f6);
  static Color sectionSeparatorColor = Color(0xffc7c7c9);
  static Color itemSeparatorColor = Color(0xffc7c7c9);
  static Color itemBgColor = Colors.white;
  static TextStyle itemTitleStyle =
      TextStyle(fontSize: 15.0, color: Colors.black);
  static TextStyle itemValueStyle =
      TextStyle(fontSize: 13.0, color: Color(0xff7a7a7e));
}

class SettingItem extends StatelessWidget {
  final String title;
  final String? displayValue;
  final GestureTapCallback onTap;
  final bool disabled;
  final Color? tileColor;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;

  const SettingItem({
    Key? key,
    required this.title,
    this.displayValue,
    this.disabled = false,
    this.tileColor,
    this.titleStyle,
    this.valueStyle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var listTile = ListTile(
      dense: true,
      tileColor: tileColor ?? SettingsStyles.itemBgColor,
      visualDensity: VisualDensity.comfortable,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
      title: Text(
        title,
        style: titleStyle ?? SettingsStyles.itemTitleStyle,
      ),
      trailing: displayValue == null
          ? null
          : Text(
              displayValue!,
              style: valueStyle ?? SettingsStyles.itemValueStyle,
            ),
    );
    return this.disabled
        ? listTile
        : GestureDetector(onTap: onTap, child: listTile);
  }
}

class SettingTextItem extends StatelessWidget {
  final String title;
  final String displayValue;
  final String? hintText;
  final String? initialValue;
  final Color? tileColor;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;

  final ValueChanged<String> onChanged;

  const SettingTextItem({
    Key? key,
    required this.title,
    required this.onChanged,
    required this.displayValue,
    this.initialValue,
    this.hintText,
    this.tileColor,
    this.titleStyle,
    this.valueStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingItem(
      title: title,
      tileColor: tileColor ?? SettingsStyles.itemBgColor,
      titleStyle: titleStyle ?? SettingsStyles.itemTitleStyle,
      valueStyle: valueStyle ?? SettingsStyles.itemValueStyle,
      displayValue: displayValue,
      onTap: () async {
        var changedValue = await showDialog(
          context: context,
          useRootNavigator: false,
          builder: (_) {
            var controller = TextEditingController(text: initialValue);
            return AlertDialog(
              title: Text(title),
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              //contentPadding: const EdgeInsets.all(16.0),
              content: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: controller,
                      autofocus: true,
                      autocorrect: false,
                      decoration: InputDecoration(hintText: hintText),
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                ],
              ),
              actions: <Widget>[
                TextButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.pop(context, null)),
                TextButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.pop(context, controller.text))
              ],
            );
          },
        );
        if (changedValue != null && changedValue != initialValue) {
          onChanged(changedValue);
        }
      },
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String title;
  final String? footer;
  final List<Widget> items;
  final TextStyle? titleStyle;
  final Color? titleBgColor;

  const SettingsSection({
    Key? key,
    required this.title,
    required this.items,
    this.footer,
    this.titleStyle,
    this.titleBgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Decorator(
          height: 64,
          backgroundColor: titleBgColor ?? SettingsStyles.sectionBgColor,
          paddingBottom: 8,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              title.toUpperCase(),
              style: titleStyle ?? SettingsStyles.sectionTitleStyle,
            ),
          ),
          paddingHoriz: 15.0,
          borderBottom: 1.0,
          borderColor: SettingsStyles.sectionSeparatorColor,
        ),
        Decorator(
          borderColor: SettingsStyles.itemSeparatorColor,
          borderBottom: 1.0,
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            padding: EdgeInsets.zero,
            separatorBuilder: (BuildContext context, int index) => Divider(
              thickness: 1.0,
              height: 1.0,
              indent: 15,
              color: SettingsStyles.itemSeparatorColor,
            ),
            itemBuilder: (BuildContext context, int index) => items[index],
          ),
        ),
      ],
    );
  }
}

class SettingsList extends StatelessWidget {
  final List<SettingsSection> sections;

  const SettingsList({
    Key? key,
    required this.sections,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        padding: EdgeInsets.zero,
        //shrinkWrap: true,
        children: sections,
      ),
    );
  }
}
