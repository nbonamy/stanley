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
      paddingAll: 64,
      paddingVert: 256,
      widget: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Button(
            label: 'Inform',
            onTap: () {
              NativeDialog.info(
                context,
                'This is Stanley',
              );
            },
          ),
          Button(
            label: 'Confirm',
            onTap: () {
              NativeDialog.alert(
                context: context,
                content: 'Are you sure?',
                actions: [
                  AlertDialogAction.cancel(
                    label: tr('no'),
                    isDefault: true,
                  ),
                  AlertDialogAction(
                    label: tr('yes'),
                    onTap: () {
                      NativeDialog.info(context, 'So be it!');
                    },
                  )
                ],
              );
            },
          ),
          Button(
            label: 'Multiple choices',
            onTap: () {
              NativeDialog.alert(
                context: context,
                content: 'Please select one',
                actions: [
                  AlertDialogAction(
                    label: 'Green',
                    color: Colors.green,
                  ),
                  AlertDialogAction(
                    label: 'Orange',
                    color: Colors.orange,
                    isDefault: true,
                  ),
                  AlertDialogAction(
                    label: 'Blue',
                    color: Colors.blue,
                  ),
                ],
              );
            },
          ),
          Button(
            label: 'Native Bottom Sheet',
            onTap: () {
              NativeDialog.bottomSheet(
                context: context,
                title: 'Please select one',
                actions: [
                  AlertDialogAction(
                    label: 'Green',
                    color: Colors.green,
                  ),
                  AlertDialogAction(
                    label: 'Orange',
                    color: Colors.orange,
                    isDefault: true,
                  ),
                  AlertDialogAction(
                    label: 'Blue',
                    color: Colors.blue,
                  ),
                ],
                cancelAction: AlertDialogAction.cancel(isDefault: true),
              );
            },
          ),
          Button(
            label: 'Material Bottom Sheet',
            onTap: () {
              NativeDialog.bottomSheet(
                context: context,
                forceMaterial: true,
                title: 'Please select one',
                actions: [
                  AlertDialogAction(
                    label: 'Green',
                    color: Colors.green,
                  ),
                  AlertDialogAction(
                    label: 'Orange',
                    color: Colors.orange,
                    isDefault: true,
                  ),
                  AlertDialogAction(
                    label: 'Blue',
                    color: Colors.blue,
                  ),
                ],
                cancelAction: AlertDialogAction.cancel(isDefault: true),
              );
            },
          ),
        ],
      ),
    );
  }
}

class Button extends StatelessWidget {
  final String label;
  final Function onTap;
  const Button({
    Key key,
    this.label,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Decorator(
      centered: true,
      paddingVert: 8,
      paddingHoriz: 16,
      borderColor: Colors.black,
      borderWidth: 1,
      borderRadius: 4,
      child: UIHelper.text(label, size: 18),
      onTap: onTap,
    );
  }
}
