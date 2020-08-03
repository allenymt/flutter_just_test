import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// do what
/// @author yulun
/// @since 2020-05-25 23:29
class InheritedTestModel {
  final int count;

  const InheritedTestModel(this.count);
}

///  InheritedWidget的具体实现
class InheritedContext extends InheritedWidget {
  //数据
  final InheritedTestModel inheritedTestModel;

  //点击+号的方法
  final Function() increment;

  //点击-号的方法
  final Function() reduce;

  InheritedContext({
    Key key,
    @required this.inheritedTestModel,
    @required this.increment,
    @required this.reduce,
    @required Widget child,
  }) : super(key: key, child: child);

  static InheritedContext of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedContext>();
  }

  //是否重建widget就取决于数据是否相同
  @override
  bool updateShouldNotify(InheritedContext oldWidget) {
    return inheritedTestModel != oldWidget.inheritedTestModel;
  }
}

///  依赖InheritedWidget
class TestWidgetA extends StatefulWidget {
  @override
  State createState() {
    return TestAState();
  }
}

class TestAState extends State<TestWidgetA> {
  @override
  Widget build(BuildContext context) {
    final inheritedContext = InheritedContext.of(context);

    final inheritedTestModel = inheritedContext.inheritedTestModel;

    print('TestWidgetA 中count的值:  ${inheritedTestModel.count}');
    return new Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
      child: new RaisedButton(
          textColor: Colors.black,
          child: new Text('+'),
          onPressed: inheritedContext.increment),
    );
  }

  @override
  void initState() {
    super.initState();
    print('TestWidgetA initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('TestWidgetA didChangeDependencies');
  }

  @override
  void didUpdateWidget(TestWidgetA oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('TestWidgetA didUpdateWidget');
  }
}

///  依赖InheritedWidget
class TestWidgetB extends StatefulWidget {
  @override
  State createState() {
    return TestBState();
  }
}

class TestBState extends State<TestWidgetB> {
  @override
  Widget build(BuildContext context) {
//    final inheritedContext = InheritedContext.of(context);
//
//    final inheritedTestModel = inheritedContext.inheritedTestModel;
//
//    print('TestWidgetB 中count的值:  ${inheritedTestModel.count}');

    return new Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
      child: new Text(
        '当前count:1234',
        style: new TextStyle(fontSize: 20.0),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    print('TestBState initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('TestBState didChangeDependencies');
  }

  @override
  void didUpdateWidget(TestWidgetB oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('TestBState didUpdateWidget');
  }
}

///  依赖InheritedWidget
class TestWidgetC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final inheritedContext = InheritedContext.of(context);

    final inheritedTestModel = inheritedContext.inheritedTestModel;

    print('TestWidgetC 中count的值:  ${inheritedTestModel.count}');

    return new Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
      child: new RaisedButton(
          textColor: Colors.black,
          child: new Text('-'),
          onPressed: inheritedContext.reduce),
    );
  }
}

/// 位于InheritedWidget内，但又不依赖于InheritedWidget
class TestWidgetD extends StatefulWidget {
  final Widget child;

  TestWidgetD(this.child);

  @override
  State createState() {
    return TestWidgetDState(child);
  }
}

class TestWidgetDState extends State<TestWidgetD> {
  final Widget child;

  TestWidgetDState(this.child);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
    );
  }

  @override
  void initState() {
    super.initState();
    print('TestWidgetDState initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('TestWidgetDState didChangeDependencies');
  }

  @override
  void didUpdateWidget(TestWidgetD oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('TestWidgetDState didUpdateWidget');
  }
}

class InheritedWidgetTestContainer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _InheritedWidgetTestContainerState();
  }
}

class _InheritedWidgetTestContainerState
    extends State<InheritedWidgetTestContainer> {
  InheritedTestModel inheritedTestModel;

  _initData() {
    inheritedTestModel = new InheritedTestModel(0);
  }

  @override
  void initState() {
    _initData();
    super.initState();
    print('_InheritedWidgetTestContainerState initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('_InheritedWidgetTestContainerState didChangeDependencies');
  }

  @override
  void didUpdateWidget(InheritedWidgetTestContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('_InheritedWidgetTestContainerState didUpdateWidget');
  }

  _incrementCount() {
    setState(() {
      inheritedTestModel = new InheritedTestModel(inheritedTestModel.count + 1);
    });
  }

  _reduceCount() {
    setState(() {
      inheritedTestModel = new InheritedTestModel(inheritedTestModel.count - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new InheritedContext(
        inheritedTestModel: inheritedTestModel,
        increment: _incrementCount,
        reduce: _reduceCount,
        child: new Scaffold(
            appBar: new AppBar(
              title: new Text('InheritedWidgetTest'),
            ),
            body: TestWidgetD(
              new Column(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, top: 10.0, right: 10.0),
                    child: new Text(
                      '我们常使用的\nTheme.of(context).textTheme\nMediaQuery.of(context).size等\n就是通过InheritedWidget实现的',
                      style: new TextStyle(fontSize: 20.0),
                    ),
                  ),
                  new TestWidgetA(),
                  new TestWidgetB(),
                  new TestWidgetC(),
                ],
              ),
            )));
  }
}
