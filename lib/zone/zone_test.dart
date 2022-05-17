import 'dart:async';

import 'package:flutter/material.dart';

import 'exception_test.dart';

/// do what
/// @author yulun
/// @since 2020-07-27 11:49
class ZoneTestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _zoneTest();
    return Scaffold(
      body: Center(
        child: Text("ZoneTest"),
      ),
    );
  }

  void _zoneTest() {
    var future = new Future.value(499);
    runZoned(() {
      var future2 = future.then((_) {
        throw "error in first error-zone";
      }).catchError((e) {
        print("Never reached!");
      });
      runZoned(() {
        var future3 = future2.catchError((e) {
          print("Never reached!");
        });
        throw "error in first error-zone";
      }, onError: (e, s) {
        print("unused error handler");
      });
    }, onError: (e, s) {
      print("catches error of first error-zone.");
    });
  }
}


class StateErrorTest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateErrorState();
  }
}

class StateErrorState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test state"),
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            bottom: 10,
            right: 10,
            child: RaisedButton(
              onPressed: () {
                setState(() {});
              },
              child: Text("click me"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // 测试init阶段，错误能否被framework捕捉到
    // 结论是可以的，答案是在performRebuild里，update child都有try/catch保护(和模式无关)
    String? a;
    print("expectinTest app error ${a!.length}");
  }
}


class ExceptionTestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget child;
    //试试推荐的做法，沙盒只在入口处
    // // build 异常
    String? b;
      // framework error,由于是在build中被捕捉到，同时也会被识别触发errorBuild
      // 不对啊 包括在单独的zone里后，系统的FlutterError.onError不会触发了，难道要在系统的zone里才行？
      // 这个zone和error一起使用还是有问题的？ 可以看runZonedGuarded源码，最终会执行下面这段代码
      // try {
      //  body就是要执行的函数，body一旦执行完，try/catch 就不再起作用了，所以当在build里单独包一层zone的时候，zone的try catch 是先触发的，因为这个function还没走完，所以
      // try/catch还是生效的
      //     return _runZoned<R>(body, zoneValues, zoneSpecification);
      //   } catch (error, stackTrace) {
      //     onError(error, stackTrace);
      //   }

      // 至于debug状态下为什么系统的FlutterError.onError还能触发，是因为
      //  void performRebuild() {
      //     Widget built;
      //     try {
      //       assert(() {
      //         _debugDoingBuild = true;
      //         return true;
      //       }());
      //       built = build();
      //       assert(() {
      //         _debugDoingBuild = false;
      //         return true;
      //       }());
      //      下面这行代码，只有在debug下会运行，校验生成的widget是否相等，然后抛错
      //       debugWidgetBuilderValue(widget, built);
      //     } catch (e, stack) {
      //       _debugDoingBuild = false;
      //       built = ErrorWidget.builder(
      //         _debugReportException(
      //           ErrorDescription('building $this'),
      //           e,
      //           stack,
      //           informationCollector: () sync* {
      //             yield DiagnosticsDebugCreator(DebugCreator(this));
      //           },
      //         ),
      //       );
      //     }
      print("expectinTest build error ${b!.length}");


      // 注释打开是测试异步异常，这里并没有被外部自定义的zone识别到，但 内部的是可以的
     String? c;
    Future.value(1).then((value) {
        // 异步异常
        print("app async error ${c!.length}");
      }).catchError((error){
        print(error);
    });

      child = Scaffold(
        body: Center(
          // child: Text("ZoneTest"),
          // 自定义zone里，试试build错误，自定义zone里profile还真不行。。framwork和build都不会触发
          // debug模式全都可以了，卧槽，什么鬼
          // 可以看上面的注释
          child: Text("ZoneTest"),
        ),
      );
    return child;
  }
}
