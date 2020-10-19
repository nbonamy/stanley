import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
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

class _MyHomePageState extends BottomBarState<MyHomePage> {

  List<Widget> _children;

  @override
  void initState() {

    // basic
    super.initState();

    // visibility flags
    List<ValueNotifier<bool>> visibilityFlags = initVisibilityFlags(count: 2);

    // init children
    _children = [
      DemoTab(visibilityFlag: visibilityFlags[0],),
      ShareTab(visibilityFlag: visibilityFlags[1],),
    ];
  }

  @override
  Widget buildWidget(BuildContext context) {
    return UIHelper.scaffold(
      title: 'Stanley Demo',
      paddingAll: 64,
      paddingVert: 256,
      actions: appBarActions,
      widget: _children[currentPage],
      bottomBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: currentPage,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: 'Demo',
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.share),
            label: 'Share',
          ),
        ],
      ),
    );
  }
}

class DemoTab extends BaseTabPage {

  DemoTab({
    Key key,
    visibilityFlag
  }) : super(key: key, visibilityFlag: visibilityFlag,);

  @override
  DemoState createState() => new DemoState();
}

class DemoState extends BaseTabState<DemoTab> {

  @override
  Widget buildWidget(BuildContext context) {
    return Column(
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
              title: 'Are you sure?',
              content: 'Press "yes" only if you\'re really sure!',
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
    );

  }

  @override
  List<Widget> getAppBarActions(BuildContext context) {
    return [
      UIHelper.appBarIcon(icon: Icons.menu, onTap: () {
        NativeDialog.info(context, 'You tapped menu');
      }),
    ];
  }

}

class ShareTab extends BaseTabPage {

  ShareTab({
    Key key,
    visibilityFlag
  }) : super(key: key, visibilityFlag: visibilityFlag,);

  @override
  ShareState createState() => ShareState();
}

class ShareState extends BaseTabState<ShareTab> {

  @override
  Widget buildWidget(BuildContext context) {
    return Decorator(
      centered: true,
      child: UIHelper.text('Nothing here except app bar icons', size: 32),
    );
  }

  @override
  List<Widget> getAppBarActions(BuildContext context) {
    return [
      UIHelper.appBarIcon(icon: Icons.share, onTap: () {
        NativeDialog.info(context, 'You tapped share');
      }),
      UIHelper.appBarIcon(icon: Icons.close, onTap: () {
        NativeDialog.info(context, 'You tapped close');
      }),
    ];
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
