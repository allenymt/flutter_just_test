import 'package:flutter/material.dart';
import 'package:flutter_just_test/memory/TestMemory.dart';
import 'package:flutter_just_test/plugin/platform_view.dart';
import 'package:flutter_just_test/reqexp/RegExpText.dart';
import 'package:flutter_just_test/touchevent/TouchEventWidget.dart';
import 'package:flutter_just_test/widgets_bind/TestBindingBase.dart';
import 'package:flutter_just_test/zone/zone_test.dart';

import 'animation/FadeAppTest.dart';
import 'basic/DynamicChild.dart';
import 'custom/PaintDemo.dart';
import 'custom/offscreen_layer_test.dart';
import 'date_select/select_dialog.dart';
import 'debug/debug_log_test.dart';
import 'eventloop/Isolate_demo.dart';
import 'eventloop/event_test.dart';
import 'fps/TestFps.dart';
import 'key/test_key.dart';
import 'operator/test_operator.dart';
import 'widget/InheritedWidgetTest.dart';

void main() {
  // 就是开发工具的debugPaint，很好奇IDE的工具怎么改变 Dart vm的值？
//  debugPaintSizeEnabled=true;
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
      "touch_event": (BuildContext context) => TestTouchEventWidget(),
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
    },
  ));
//      new TestOperatorWidget());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    print('x is ${immutablePoint?.x},  y is ${immutablePoint?.y}');
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
          appBar: AppBar(
            title: Text('Welcome to Flutter'),
          ),
          body: ListView(
            children: <Widget>[
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
                title: Text('事件传递测试 TODO'),
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
                title: Text('级联选择框 选日期，选地址'),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext c) {
                    return CascadeTestWidget();
                  }));
                },
              ),
            ],
          )),
    );
  }
}
