import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

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
  /// Returns an instance of the [WidgetsBinding], creating and
  /// initializing it if necessary. If one is created, it will be a
  /// [WidgetsFlutterBinding]. If one was previously initialized, then
  /// it will at least implement [WidgetsBinding].
  ///
  /// You only need to call this method if you need the binding to be
  /// initialized before calling [runApp].
  ///
  /// In the `flutter_test` framework, [testWidgets] initializes the
  /// binding instance to a [TestWidgetsFlutterBinding], not a
  /// [WidgetsFlutterBinding].
  static TestWidgetsBinding ensureInitialized() {
    if (TestWidgetsBinding.instance == null) {
      print("WidgetsFlutterBinding constr");
      TestWidgetsFlutterBinding();
    }
    return TestWidgetsBinding.instance;
  }
}

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
    super.initInstances();
    _instance = this;
  }
}

mixin TestSemanticsBinding on TestBindingBase {
  /// The current [SemanticsBinding], if one has been created.
  static TestSemanticsBinding get instance => _instance;
  static TestSemanticsBinding _instance;

  @override
  void initInstances() {
    super.initInstances();
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
    super.initInstances();
    _instance = this;
  }
}

mixin TestGestureBinding on TestBindingBase {
  /// The singleton instance of this object.
  static TestGestureBinding get instance => _instance;
  static TestGestureBinding _instance;

  @override
  void initInstances() {
    super.initInstances();
    _instance = this;
  }
}

mixin TestSchedulerBinding on TestBindingBase, TestServicesBinding {
  /// The current [SchedulerBinding], if one has been created.
  static TestSchedulerBinding get instance => _instance;
  static TestSchedulerBinding _instance;

  @override
  void initInstances() {
    super.initInstances();
    _instance = this;
  }
}

mixin TestServicesBinding on TestBindingBase {
  static TestServicesBinding get instance => _instance;
  static TestServicesBinding _instance;

  @override
  void initInstances() {
    super.initInstances();
    _instance = this;
  }
}

mixin TestPaintingBinding on TestBindingBase, TestServicesBinding {
  @override
  void initInstances() {
    super.initInstances();
    _instance = this;
  }

  /// The current [PaintingBinding], if one has been created.
  static TestPaintingBinding get instance => _instance;
  static TestPaintingBinding _instance;
}
