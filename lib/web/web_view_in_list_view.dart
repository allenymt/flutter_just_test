import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// do what
/// @author yulun
/// @since 2021-03-22 10:31

class WebViewInListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WebViewInListViewState();
  }
}

class WebViewInListViewState extends State<WebViewInListView>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("web view in ListView"),
        ),
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: _buildWebView(),
            )
          ],
        ));
  }

  Widget _buildWebView() {
    return WebView(
      initialUrl: 'https://juejin.cn/user/764915820281304',
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
}

class PlatformViewVerticalGestureRecognizer
    extends VerticalDragGestureRecognizer {
  PlatformViewVerticalGestureRecognizer({PointerDeviceKind kind})
      : super(kind: kind);

  Offset _dragDistance = Offset.zero;

  @override
  void addPointer(PointerEvent event) {
    startTrackingPointer(event.pointer);
  }

  @override
  void handleEvent(PointerEvent event) {
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
    super.acceptGesture(pointer);
  }

  @override
  void rejectGesture(int pointer) {
    super.rejectGesture(pointer);
  }

  @override
  String get debugDescription => 'horizontal drag (platform view)';

  @override
  void didStopTrackingLastPointer(int pointer) {}
}
