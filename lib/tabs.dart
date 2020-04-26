import 'dart:async';

import 'package:flutter/material.dart';

class UpdateActionBarActionsNotification extends Notification {
  final List<Widget> appBarActions;
  UpdateActionBarActionsNotification({
    this.appBarActions,
  });
}

abstract class BottomBarState<T extends StatefulWidget> extends State<T> {
  int _page;
  List<Widget> _appBarActions;
  List<ValueNotifier<bool>> _visibilityFlags;

  @override
  void initState() {
    super.initState();
    _page = 0;
  }

  List<Widget> get appBarActions {
    return _appBarActions;
  }

  int get currentPage {
    return _page;
  }

  List<ValueNotifier<bool>> initVisibilityFlags({
    @required int count,
    int visibleIndex = 0,
  }) {
    // visibility flags
    _visibilityFlags = new List.filled(count, ValueNotifier(false));
    _visibilityFlags[visibleIndex] = ValueNotifier(true);
    return _visibilityFlags;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<UpdateActionBarActionsNotification>(
      onNotification: (notification) {
        setState(() {
          _appBarActions = notification.appBarActions;
        });
        return false;
      },
      child: buildWidget(context),
    );
  }

  Widget buildWidget(BuildContext context);

  onTabTapped(int index) {
    setState(() {
      _visibilityFlags[_page].value = false;
      _appBarActions = null;
      _page = index;
      _visibilityFlags[_page].value = true;
    });
  }
}

abstract class BaseTabPage extends StatefulWidget {
  final ValueNotifier<bool> visibilityFlag;

  const BaseTabPage({
    Key key,
    @required this.visibilityFlag,
  }) : super(key: key);

  State createState();
}

abstract class BaseTabState<T extends BaseTabPage> extends State<T> {
  @override
  Widget build(BuildContext context) {
    // do it
    return ValueListenableBuilder(
        valueListenable: widget.visibilityFlag,
        builder: (BuildContext context, bool visible, Widget child) {
          // update action bar
          if (visible) {
            scheduleMicrotask(() {
              UpdateActionBarActionsNotification(
                appBarActions: getAppBarActions(context),
              ).dispatch(context);
            });
          }

          // done
          return buildWidget(context);
        });
  }

  Widget buildWidget(BuildContext context);

  List<Widget> getAppBarActions(BuildContext context) {
    return null;
  }
}
