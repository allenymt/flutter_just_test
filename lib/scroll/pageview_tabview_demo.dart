/// do what
/// @author yulun
/// @since 2020-12-13 17:10

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// tabview 嵌套 pageview  冲突解决
class PageViewTabViewConflict extends StatefulWidget {
  PageViewTabViewConflict({Key? key}) : super(key: key);

  @override
  _PageViewTabViewConflictState createState() => _PageViewTabViewConflictState();
}

final PageController _pageController = PageController();

PageView myPageView = PageView(
  controller: _pageController,
  allowImplicitScrolling: true,
  children: <Widget>[
    Container(color: Colors.red),
    GreenShades(),
    Container(color: Colors.yellow),
  ],
);

class _PageViewTabViewConflictState extends State<PageViewTabViewConflict> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('TabBarView inside PageView'),
    ),
    body: myPageView,
  );
}

class GreenShades extends StatefulWidget {
  @override
  _GreenShadesState createState() => _GreenShadesState();
}

class _GreenShadesState extends State<GreenShades>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    this._tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // Local dragStartDetail.
    DragStartDetails? dragStartDetails;
    // Current drag instance - should be instantiated on overscroll and updated alongside.
    Drag? drag;
    return Column(
      children: <Widget>[
        TabBar(
          labelColor: Colors.green,
          indicatorColor: Colors.green,
          controller: _tabController,
          tabs: <Tab>[
            const Tab(text: "Dark"),
            const Tab(text: "Normal"),
            const Tab(text: "Light"),
          ],
        ),
        Expanded(
          child: NotificationListener(
            onNotification: (dynamic notification) {
              if (notification is ScrollStartNotification) {
                dragStartDetails = notification.dragDetails;
              }
              if (notification is OverscrollNotification) {
                drag = _pageController.position.drag(dragStartDetails!, () {});
                drag!.update(notification.dragDetails!);
              }
              if (notification is ScrollEndNotification) {
                drag?.cancel();
              }
              return true;
            },
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                Container(color: Colors.green[800]),
                Container(color: Colors.green),
                Container(color: Colors.green[200]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
