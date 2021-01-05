import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stanley/stanley.dart';

const kSectionTitle = TextStyle(fontSize: 13.0, color: Color(0xff6d6d71));
const kSectionBgColor = Color(0xfff2f2f6);
const kSeparator = Color(0xffc7c7c9);
const kItemTitle = TextStyle(fontSize: 17.0, color: Colors.black);
const kItemValue = TextStyle(fontSize: 15.0, color: Color(0xff7a7a7e));

class SettingItem extends StatelessWidget {
  final String title;
  final String displayValue;
  final GestureTapCallback onTap;
  final bool disabled;

  const SettingItem({
    Key key,
    @required this.title,
    this.displayValue,
    this.disabled = false,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var listTile = ListTile(
      dense: true,
      tileColor: Colors.white,
      visualDensity: VisualDensity.comfortable,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
      title: Text(title, style: kItemTitle),
      trailing:
          displayValue != null ? Text(displayValue, style: kItemValue) : null,
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

  final ValueChanged<String> onChanged;

  const SettingTextItem({
    Key key,
    @required this.title,
    @required this.onChanged,
    @required this.displayValue,
    this.initialValue,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingItem(
      title: title,
      displayValue: displayValue,
      onTap: () async {
        var changedValue = await showDialog(
          context: context,
          builder: (_) {
            var controller = TextEditingController(text: initialValue);
            return AlertDialog(
              title: Text(title),
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
                    onPressed: () => Navigator.pop(context)),
                FlatButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.pop(context, controller.text))
              ],
            );
          },
        );
        if (changedValue != initialValue) {
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

  const SettingsSection({
    Key key,
    @required this.title,
    @required this.items,
    this.footer,
    this.titleStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (title != null)
            ? Decorator(
                height: 64,
                backgroundColor: kSectionBgColor,
                paddingBottom: 8,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    title.toUpperCase(),
                    style: titleStyle ?? kSectionTitle,
                  ),
                ),
                paddingHoriz: 15.0,
                borderBottom: 1.0,
                borderColor: kSeparator,
              )
            : Container(),
        Decorator(
          borderColor: kSeparator,
          borderBottom: 1.0,
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            separatorBuilder: (BuildContext context, int index) => Divider(
              height: 1.0,
              indent: 15,
              color: kSeparator,
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
    Key key,
    @required this.sections,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kSectionBgColor,
      child: ListView(
        //shrinkWrap: true,
        children: sections,
      ),
    );
  }
}
