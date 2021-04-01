import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// do what
/// @author yulun
/// @since 2021-03-22 10:31

class WebViewInTabView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WebViewInTabViewState();
  }
}

class WebViewInTabViewState extends State<WebViewInTabView>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController?.dispose();
  }

  double dy = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    children.add(_buildPageChild(1));
    children.add(NotificationListener<ScrollUpdateNotification>(
      child: _buildWebView(),
      onNotification: (updateNotification) {
        dy += updateNotification.metrics.pixels;
        print(
            "yulun handleEvent pixels is ${updateNotification.metrics.pixels} is $dy");
        return false;
      },
    ));
    children.add(_buildPageChild(3));

    double barHeight = math.max(MediaQuery.of(context).size.height * 0.065, 48);
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      barHeight = 44;
    }
    barHeight = 44;

    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return <Widget>[
          SliverOverlapAbsorber(
            // This widget takes the overlapping behavior of the SliverAppBar,
            // and redirects it to the SliverOverlapInjector below. If it is
            // missing, then it is possible for the nested "inner" scroll view
            // below to end up under the SliverAppBar even when the inner
            // scroll view thinks it has not been scrolled.
            // This is not necessary if the "headerSliverBuilder" only builds
            // widgets that do not overlap the next sliver.
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
              title: const Text('Books'),
              // This is the title in the app bar.
              expandedHeight: barHeight + 42,
              floating: true,
              snap: true,
              // The "forceElevated" property causes the SliverAppBar to show
              // a shadow. The "innerBoxIsScrolled" parameter is true when the
              // inner scroll view is scrolled beyond its "zero" point, i.e.
              // when it appears to be scrolled below the SliverAppBar.
              // Without this, there are cases where the shadow would appear
              // or not appear inappropriately, because the SliverAppBar is
              // not actually aware of the precise position of the inner
              // scroll views.
              forceElevated: innerBoxIsScrolled,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(42),
                child: TabBar(
                  controller: tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: Color(0xff333333),
                  labelStyle:
                      new TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  unselectedLabelColor: Color(0xff999999),
                  unselectedLabelStyle: new TextStyle(
                      fontSize: 15, fontWeight: FontWeight.normal),
                  tabs: [
                    Text("1"),
                    Text("2"),
                    Text("3"),
                  ],
                ),
              ),
            ),
          ),
        ];
      },
      body: TabBarView(
        children: children,
        controller: tabController,
      ),
    ));
  }

  Widget _buildWebView() {
    return WebView(
      initialUrl:
          'https://juejin.cn/user/764915820281304',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {},
      navigationDelegate: (NavigationRequest request) {
        if (request.url.startsWith('https://www.youtube.com/')) {
          print('blocking navigation to $request}');
          return NavigationDecision.prevent;
        }
        print('allowing navigation to $request');
        return NavigationDecision.navigate;
      },
      onPageStarted: (String url) {
        print('Page started loading: $url');
      },
      onPageFinished: (String url) {
        print('Page finished loading: $url');
      },
      gestureNavigationEnabled: true,
      gestureRecognizers: [
        Factory(() =>
            // VerticalDragGestureRecognizer()..onStart = (details) {}
            PlatformViewVerticalGestureRecognizer(
                kind: PointerDeviceKind.touch))
      ].toSet(),
    );
  }

  Widget _buildPageChild(int index) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            height: 50,
            color: Colors.black38,
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 20,
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 150,
            child: ListView.separated(
                separatorBuilder: (context, index) {
                  return SizedBox(
                    width: 30,
                  );
                },
                itemBuilder: (context, index) {
                  return Container(
                      height: 150,
                      width: 150,
                      color: Color.fromARGB(
                        255,
                        (150 * (index + 1)) % 255,
                        (100 * (index + 1)) % 255,
                        (80 * (index + 1)) % 255,
                      ));
                },
                itemCount: 10,
                scrollDirection: Axis.horizontal),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 20,
          ),
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
            child: Container(
                height: 20,
                color: Color.fromARGB(
                  255,
                  (150 * (index + 1)) % 255,
                  (100 * (index + 1)) % 255,
                  (60 * (index + 1)) % 255,
                )),
          );
        }, childCount: 50)),
      ],
    );
  }
}

class PlatformViewVerticalGestureRecognizer
    extends VerticalDragGestureRecognizer {
  PlatformViewVerticalGestureRecognizer({PointerDeviceKind kind})
      : super(kind: kind);

  Offset _dragDistance = Offset.zero;

  @override
  void addPointer(PointerEvent event) {
    print("yulun addPointer");
    startTrackingPointer(event.pointer);
  }

  @override
  void handleEvent(PointerEvent event) {
    print("yulun handleEvent");
    // super.handleEvent(event);
    _dragDistance = _dragDistance + event.delta;
    if (event is PointerMoveEvent) {
      final double dy = _dragDistance.dy.abs();
      final double dx = _dragDistance.dx.abs();

      if (dy > dx && dy > kTouchSlop) {
        // vertical drag - accept
        resolve(GestureDisposition.accepted);
        _dragDistance = Offset.zero;
      } else if (dx > kTouchSlop && dx > dy) {
        // horizontal drag - stop tracking
        // resolve(GestureDisposition.accepted);
        stopTrackingPointer(event.pointer);
        _dragDistance = Offset.zero;
      }
    }
  }

  @override
  void acceptGesture(int pointer) {
    print("yulun acceptGesture");
    super.acceptGesture(pointer);
  }

  @override
  void rejectGesture(int pointer) {
    print("yulun rejectGesture");
    super.rejectGesture(pointer);
  }

  @override
  String get debugDescription => 'horizontal drag (platform view)';

  @override
  void didStopTrackingLastPointer(int pointer) {
    print("yulun rejectGesture");
  }
}
