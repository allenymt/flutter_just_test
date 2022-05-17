
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_just_test/custom/count_down_widget.dart';
import 'package:flutter_just_test/memory/TestMemory.dart';
import 'package:flutter_just_test/plugin/platform_view.dart';
import 'package:flutter_just_test/reqexp/RegExpText.dart';
import 'package:flutter_just_test/sheet/bottom_sheet_test.dart';
import 'package:flutter_just_test/touchevent/touch_main.dart';
import 'package:flutter_just_test/vm/vm_service_page.dart';
import 'package:flutter_just_test/widgets_bind/TestBindingBase.dart';
import 'package:flutter_just_test/zone/zone_test.dart';

import 'animation/FadeAppTest.dart';
import 'mixin/mixin_test.dart';
import 'ui_box/infinite_page_view.dart';
import 'basic/DynamicChild.dart';
import 'custom/PaintDemo.dart';
import 'custom/offscreen_layer_test.dart';
import 'debug/debug_log_test.dart';
import 'eventloop/Isolate_demo.dart';
import 'eventloop/event_test.dart';
import 'focus/FocusDemo.dart';
import 'fps/TestFps.dart';
import 'key/test_key.dart';
import 'kraken/KrakenDemo.dart';
import 'load_more/load_more_demo.dart';
import 'operator/test_operator.dart';
import 'scroll/pageview_tabview_demo.dart';
import 'tab_lag/tabview_lag_demo.dart';
import 'touchevent/hitbehavior_demo.dart';
import 'ui_box/ui_box_demo.dart';
import 'web/web_view_in_list_view.dart';
import 'web/web_view_in_tabar_view.dart';
import 'widget/InheritedWidgetTest.dart';
import 'widget/StateTest.dart';
import 'zone/exception_test.dart';

void main() {
  // 就是开发工具的debugPaint，很好奇IDE的工具怎么改变 Dart vm的值？
//  debugPaintSizeEnabled=true;
  runZonedGuarded<Future<Null>>(() async {
    runApp(MyApp());
  }, (error, stackTrace) async {
    print("expectinTest zone error ${stackTrace.toString()}");
//Do sth for error
  });


  runApp(new MaterialApp(
    home: MyApp(),
//    checkerboardOffscreenLayers: true,
    // 只有colorfilter才能检测到 ,Opacity,clip.savelayer 都无法检测到。
//    checkerboardRasterCacheImages: true,
    routes: <String, WidgetBuilder>{
      "fade_app": (BuildContext context) => FadeAppTest(),
      "paint_demo": (BuildContext context) => PaintApp(),
      "inherited_test": (BuildContext context) =>
          InheritedWidgetTestContainer(),
      "dynamic_child": (BuildContext context) => DynamicChildApp(),
      "touch_event": (BuildContext context) => TouchMain(),
      "test_operator": (BuildContext context) => TestOperatorWidget(),
      "test_key": (BuildContext context) => TestKeyWidget(),
      "event_test": (BuildContext context) => EventLoopTestWidget(),
      "isolate_test": (BuildContext context) => IsolateTestWidget(),
      "reqexp_test": (BuildContext context) => RegExpWidget(),
      "platform_test": (BuildContext context) => PlatformViewTest(),
      "debug_log": (BuildContext context) => DebugLogTest(),
      "offer_screen_layer": (BuildContext context) => offScreenWidget(),
      "test_memory": (BuildContext context) => TestMemory(),
      "test_fps": (BuildContext context) => TestFpsWidget(),
      "zone_test": (BuildContext context) => ZoneTestWidget(),
      "pageView_tabView_demo": (BuildContext context) =>
          PageViewTabViewConflict(),
      "vm_service_test":(BuildContext context) =>
          VmServicePage(),
    },
  ));
//      new TestOperatorWidget());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    print('x is ${immutablePoint?.x},  y is ${immutablePoint?.y}');
//     TestReference t = new TestReference();
//     t.test();
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
          appBar: AppBar(
            title: Text('Welcome to Flutter'),
          ),
          body: ListView(
            children: <Widget>[
              ListTile(
                title: Text('Ui Box'),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext c) {
                    return UiBoxDemo();
                  }));
                },
              ),
              ListTile(
                title: Text('fade动画测试'),
                onTap: () {
                  Navigator.of(context).pushNamed("fade_app");
                },
              ),
              ListTile(
                title: Text('自定义画笔'),
                onTap: () {
                  Navigator.of(context).pushNamed("paint_demo");
                },
              ),
              ListTile(
                title: Text('inherited测试'),
                onTap: () {
                  Navigator.of(context).pushNamed("inherited_test");
                },
              ),
              ListTile(
                title: Text('dynamic_child'),
                onTap: () {
                  Navigator.of(context).pushNamed("dynamic_child");
                },
              ),
              ListTile(
                title: Text('事件传递测试 Test'),
                onTap: () {
                  Navigator.of(context).pushNamed("touch_event");
                },
              ),
              ListTile(
                title: Text('+操作符重载测试'),
                onTap: () {
                  Navigator.of(context).pushNamed("test_operator");
                },
              ),
              ListTile(
                title: Text('key测试'),
                onTap: () {
                  Navigator.of(context).pushNamed("test_key");
                },
              ),
              ListTile(
                title: Text('EventLoop测试'),
                onTap: () {
                  Navigator.of(context).pushNamed("event_test");
                },
              ),
              ListTile(
                title: Text('isolate测试'),
                onTap: () {
                  Navigator.of(context).pushNamed("isolate_test");
                },
              ),
              ListTile(
                title: Text('正则测试'),
                onTap: () {
                  Navigator.of(context).pushNamed("reqexp_test");
                },
              ),
              ListTile(
                title: Text('AndroidView测试'),
                onTap: () {
                  Navigator.of(context).pushNamed("platform_test");
                },
              ),
              ListTile(
                title: Text('debug日志测试'),
                onTap: () {
                  Navigator.of(context).pushNamed("debug_log");
                },
              ),
              ListTile(
                title: Text('离屏渲染测试'),
                onTap: () {
                  Navigator.of(context).pushNamed("offer_screen_layer");
                },
              ),
              ListTile(
                title: Text('测试匿名类的gc回收'),
                onTap: () {
                  Navigator.of(context).pushNamed("test_memory");
                },
              ),
              ListTile(
                title: Text('fps测试'),
                onTap: () {
                  Navigator.of(context).pushNamed("test_fps");
                },
              ),
              ListTile(
                title: Text('zone异常测试'),
                onTap: () {
                  Navigator.of(context).pushNamed("zone_test");
                },
              ),
              ListTile(
                title: Text('widgets 胶水类测试'),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext c) {
                    return TestBindingWidget();
                  }));
                },
              ),
              ListTile(
                title: Text('pageview 嵌套 tabview 滑动冲突测试'),
                onTap: () {
                  Navigator.of(context).pushNamed("pageView_tabView_demo");
                },
              ),
              ListTile(
                title: Text('state 刷新测试'),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext c) {
                    return StateTestParent();
                  }));
                },
              ),
              ListTile(
                title: Text('hit behavior demo'),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext c) {
                    return HitBehaviorDemo();
                  }));
                },
              ),
              ListTile(
                title: Text('exception  demo'),
                onTap: () {
                  SlotExceptionManager.getInstance(
                      buildErrorWidget: () {
                        // 降级的errorWidget
                        return Container(
                          color: Colors.red,
                        );
                      },
                      specialClassName: Set<String>()
                        ..add("ExceptionTestWidget"));
                  // .runZonedCatchError(() async{
                  // test app 异常
                  String? a;
                  // 同步异常 被zone error 捕捉了，不属于framwork和error build,所以这两个都不会被捕捉到
                  // print("expectinTest app error ${a.length}");

                  // 已捕获的同步异常 没什么问题
                  try {
                    print("expectinTest app error ${a!.length}");
                  } catch (e) {}

                  // // 注释打开是测试异步异常，被zone识别到
                  // Future.value(1).then((value) {
                  //   // 异步异常
                  //   print("app error ${a.length}");
                  // });

                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext c) {
                    // return ExceptionTestWidget();
                    return StateErrorTest();
                  }));
                  // });
                },
              ),
              ListTile(
                title: Text('测试date time'),
                onTap: () {
                  DateTime dateTime = DateTime.now();
                  print("date time 1-${dateTime.millisecondsSinceEpoch}");
                  Future.delayed(Duration(seconds: 5), () {
                    print("date time 2-${dateTime.millisecondsSinceEpoch}");
                  });
                },
              ),
              ListTile(
                title: Text('FocusDemo测试-焦点变化'),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext c) {
                    // return ExceptionTestWidget();
                    return FocusDemoWidget();
                  }));
                },
              ),
              ListTile(
                title: Text('FocusDemo2测试-'),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext c) {
                    // return ExceptionTestWidget();
                    return FocusDemo2Widget();
                  }));
                },
              ),
              ListTile(
                title: Text('BottomSheet测试'),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext c) {
                    // return ExceptionTestWidget();
                    return BottomSheetPageRoute();
                  }));
                },
              ),
              ListTile(
                title: Text('tabView 卡顿测试'),
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        TabViewLagDemo(),
                    transitionDuration: Duration(seconds: 0),
                  ));
                },
              ),
              ListTile(
                title: Text('简单倒计时组件'),
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => Scaffold(
                        body: Center(
                            child: CountDownWidget(
                      countTimeInMilliseconds:
                          DateTime.now().millisecondsSinceEpoch + 5 * 1000,
                      onCountDownFinish: () {
                        print("倒计时结束啦");
                      },
                      buildTimeWidget: (context, h, m, s, finish) {
                        if (finish) {
                          return Text("倒计时结束啦");
                        } else {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(h),
                              Text(":"),
                              Text(m),
                              Text(":"),
                              Text(s),
                            ],
                          );
                        }
                      },
                    ))),
                    transitionDuration: Duration(seconds: 0),
                  ));
                },
              ),
              ListTile(
                title: Text('webview in ListView'),
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        Scaffold(body: Center(child: WebViewInListView())),
                    transitionDuration: Duration(seconds: 0),
                  ));
                },
              ),
              ListTile(
                title: Text('嵌套滑动webview'),
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        Scaffold(body: Center(child: WebViewInTabView())),
                    transitionDuration: Duration(seconds: 0),
                  ));
                },
              ),
              ListTile(
                title: Text('tabView load more'),
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        Scaffold(body: Center(child: TabViewLoadMoreDemo())),
                    transitionDuration: Duration(seconds: 0),
                  ));
                },
              ),
              ListTile(
                title: Text('KrakenDemo'),
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        Scaffold(body: Center(child: KrakenDemo())),
                    transitionDuration: Duration(seconds: 0),
                  ));
                },
              ),
              ListTile(
                title: Text('PageViewDemo'),
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        Scaffold(body: Center(child: PageViewDemo())),
                    transitionDuration: Duration(seconds: 0),
                  ));
                },
              ),
              ListTile(
                title: Text('mixinTest'),
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        Scaffold(body: Center(child: mixinTest())),
                    transitionDuration: Duration(seconds: 0),
                  ));
                },
              ),
              ListTile(
                title: Text('vm_service_test'),
                onTap: () {
                  Navigator.of(context).pushNamed("vm_service_test");
                },
              ),

            ],
          )),
    );
  }
}
