import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// 模仿系统的WidgetsFlutterBinding，更好的理解mixin机制以及初始化流程
/// 疑问1 执行顺序是基类的mixin依赖顺序哪个类mixin的依赖顺序
///   答 依赖的是实际执行的类，也就是TestWidgetsFlutterBinding的on顺序
/// 疑问2 TestSemanticsBinding没有依赖其他的mixin，为什么其他的有依赖
///   答 是的，例如系统类WidgetsBinding有那么多依赖，只是继承了它们的方法，方便监听，如render的handleTextScaleFactorChanged，handleMetricsChanged
/// 其实每个子mixin只要on 基类就行， 实际的执行顺序 实际在执行的类也就是TestWidgetsFlutterBinding的mixin依赖顺讯决定的。
class TestBindingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: SafeArea(
          child: Scaffold(
              body: GestureDetector(
        child: Center(
          child: Text("测试系统启动mixin"),
        ),
        onTap: () {
          TestWidgetsBinding.instance = null;
          TestWidgetsFlutterBinding.ensureInitialized();
        },
      ))),
    );
  }
}

abstract class TestBindingBase {
  TestBindingBase() {
    initInstances();
  }

  @protected
  @mustCallSuper
  void initInstances() {}
}

class TestWidgetsFlutterBinding extends TestBindingBase
    with
        TestGestureBinding,
        TestServicesBinding,
        TestSchedulerBinding,
        TestPaintingBinding,
        TestSemanticsBinding,
        TestRendererBinding,
        TestWidgetsBinding {
  static TestWidgetsBinding ensureInitialized() {
    if (TestWidgetsBinding.instance == null) {
      print("WidgetsFlutterBinding constr");
      TestWidgetsFlutterBinding();
    }
    return TestWidgetsBinding.instance;
  }
}

/// TestWidgetsFlutterBinding最后一个是widgetsbinding
/// 根据mixin规则，这里的initInstances先被执行
mixin TestWidgetsBinding
    on
        TestBindingBase,
        TestServicesBinding,
        TestSchedulerBinding,
        TestGestureBinding,
        TestRendererBinding,
        TestSemanticsBinding {
  static TestWidgetsBinding get instance => _instance;

  static set instance(TestWidgetsBinding s) => _instance = s;
  static TestWidgetsBinding _instance;

  @override
  void initInstances() {
    /// step 1
    super.initInstances();/// 执行TestSemanticsBinding的initInstances
    /// step 14
    _instance = this;
  }
}

mixin TestSemanticsBinding on TestBindingBase {
  static TestSemanticsBinding get instance => _instance;
  static TestSemanticsBinding _instance;

  @override
  void initInstances() {
    /// step 3
    super.initInstances();    /// 执行TestRendererBinding的initInstances
    /// step 13
    _instance = this;
  }
}

mixin TestRendererBinding
    on
        TestBindingBase,
        TestServicesBinding,
        TestSchedulerBinding,
        TestGestureBinding,
        TestSemanticsBinding {
  static TestRendererBinding get instance => _instance;
  static TestRendererBinding _instance;

  @override
  void initInstances() {
    /// step 2
    super.initInstances();    /// 执行TestPaintingBinding的initInstances
    /// step 12
    _instance = this;
  }
}

mixin TestPaintingBinding on TestBindingBase, TestServicesBinding {
  @override
  void initInstances() {
    /// step 4
    super.initInstances();    /// 执行TestSchedulerBinding的initInstances
    /// step 11
    _instance = this;
  }
  static TestPaintingBinding get instance => _instance;
  static TestPaintingBinding _instance;
}

mixin TestSchedulerBinding on TestBindingBase, TestServicesBinding {
  static TestSchedulerBinding get instance => _instance;
  static TestSchedulerBinding _instance;

  @override
  void initInstances() {
    /// step 5
    super.initInstances();    /// 执行TestServicesBinding的initInstances
    /// step 10
    _instance = this;
  }
}

mixin TestServicesBinding on TestBindingBase {
  static TestServicesBinding get instance => _instance;
  static TestServicesBinding _instance;

  @override
  void initInstances() {
    /// step 6
    super.initInstances();    /// 执行TestGestureBinding的initInstances
    /// step 9
    _instance = this;
  }
}

mixin TestGestureBinding on TestBindingBase {
  static TestGestureBinding get instance => _instance;
  static TestGestureBinding _instance;

  @override
  void initInstances() {
    /// step 7
    /// 最后被执行，但其实初始化函数是第一个走完的
    super.initInstances();
    /// step 8
    _instance = this;
  }
}
