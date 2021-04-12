import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stanley/stanley.dart';

class SettingsStyles {
  static TextStyle sectionTitleStyle = TextStyle(
    fontSize: 13.0,
    color: Color(0xff6d6d71),
  );
  static Color sectionBgColor = Color(
    0xfff2f2f6,
  );
  static Color separatorColor = Color(
    0xffc7c7c9,
  );
  static Color itemBgColor = Colors.white;
  static TextStyle itemTitleStyle = TextStyle(
    fontSize: 17.0,
    color: Colors.black,
  );
  static TextStyle itemValueStyle = TextStyle(
    fontSize: 15.0,
    color: Color(0xff7a7a7e),
  );
}

class SettingItem extends StatelessWidget {
  final String title;
  final String displayValue;
  final GestureTapCallback onTap;
  final bool disabled;
  final Color tileColor;
  final TextStyle titleStyle;
  final TextStyle valueStyle;

  const SettingItem({
    Key key,
    @required this.title,
    this.displayValue,
    this.disabled = false,
    this.tileColor,
    this.titleStyle,
    this.valueStyle,
    @required this.onTap,
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
      trailing: displayValue != null
          ? Text(
              displayValue,
              style: valueStyle ?? SettingsStyles.itemValueStyle,
            )
          : null,
    );
    return this.disabled || onTap == null
        ? listTile
        : GestureDetector(onTap: onTap, child: listTile);
  }
}

class SettingTextItem extends StatelessWidget {
  final String title;
  final String displayValue;
  final String hintText;
  final String initialValue;
  final Color tileColor;
  final TextStyle titleStyle;
  final TextStyle valueStyle;

  final ValueChanged<String> onChanged;

  const SettingTextItem({
    Key key,
    @required this.title,
    @required this.onChanged,
    @required this.displayValue,
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
          builder: (_) {
            var controller = TextEditingController(text: initialValue);
            return AlertDialog(
              title: Text(title),
              titleTextStyle: TextStyle(color: Colors.black),
              contentPadding: const EdgeInsets.all(16.0),
              content: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: controller,
                      autofocus: true,
                      autocorrect: false,
                      decoration: InputDecoration(hintText: hintText),
                    ),
                  )
                ],
              ),
              actions: <Widget>[
                FlatButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.pop(context, null)),
                FlatButton(
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
  final String footer;
  final List<Widget> items;
  final TextStyle titleStyle;
  final Color titleBgColor;

  const SettingsSection({
    Key key,
    @required this.title,
    @required this.items,
    this.footer,
    this.titleStyle,
    this.titleBgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (title != null)
            ? Decorator(
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
                borderColor: SettingsStyles.separatorColor,
              )
            : Container(),
        Decorator(
          borderColor: SettingsStyles.separatorColor,
          borderBottom: 1.0,
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            separatorBuilder: (BuildContext context, int index) => Divider(
              height: 1.0,
              indent: 15,
              color: SettingsStyles.separatorColor,
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
  final Color bgColor;

  const SettingsList({
    Key key,
    @required this.sections,
    this.bgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: this.bgColor,
      child: ListView(
        //shrinkWrap: true,
        children: sections,
      ),
    );
  }
}
