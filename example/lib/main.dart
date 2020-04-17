import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stanley/stanley.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: [Locale('en', 'US')],
      fallbackLocale: Locale('en', 'US'),
      path: 'i18n',
      child: MaterialApp(
        title: 'Stanley Demo',
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return UIHelper.scaffold(
      title: 'Stanley Demo',
      backgroundColor: Colors.blue,
      underlineColor: Colors.transparent,
      widget: Center(
        child: Decorator(
          marginBottom: 200,
          paddingVert: 24,
          paddingHoriz: 48,
          borderWidth: 2,
          borderColor: Colors.white,
          borderRadius: 8,
          child: UIHelper.text(
            'My name is\nStanley',
            size: 24,
            color: Colors.white,
            bold: true,
            align: TextAlign.center,
          ),
          onTap: () {
            NativeDialog.alert(
              context: context,
              content: "Are you staying at home?",
              actions: [
                AlertDialogAction.cancel(context, label: "No"),
                AlertDialogAction.build(
                  context,
                  label: "Yes",
                  onTap: () {
                    NativeDialog.info(
                      context,
                      "Thanks!",
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
