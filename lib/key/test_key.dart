import 'dart:math' as math;

import 'package:flutter/material.dart';

/// do what
/// @author yulun
/// @since 2020-06-17 16:28

/// main widget
class TestKeyWidget extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<TestKeyWidget> {
  List<Widget> widgetsStateful;

  @override
  void initState() {
    super.initState();
//    widgetsStateful = [
//      Padding(
//        padding: EdgeInsets.all(1),
//        child: StatefulContainer(
//          key: UniqueKey(),
//        ),
//      ),
//      Padding(
//        padding: EdgeInsets.all(1),
//        child: StatefulContainer(
//          key: UniqueKey(),
//        ),
//      ),
//    ];

    widgetsStateful = [
      StatelessContainer(),
      StatelessContainer(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
//      Center(
//        child:
//        Column(
//          children: <Widget>[
//            Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: widgetsStateless,
//            ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widgetsStateful),
//          ],
//        ),

//      ),
      floatingActionButton: FloatingActionButton(
        onPressed: switchWidget,
        child: Icon(Icons.undo),
      ),
    );
  }

  switchWidget() {
//    switchWidgetStateless();
//    switchWidgetStateful();
  if (mounted)
    setState(() {
      widgetsStateful.insert(0, widgetsStateful.removeAt(1));
    });
  }

  switchWidgetStateful() {
    widgetsStateful.insert(0, widgetsStateful.removeAt(1));
  }
}

class StatefulContainer extends StatefulWidget {
  StatefulContainer({Key key}) : super(key: key);

  @override
  _StatefulContainerState createState() {
    return _StatefulContainerState();
  }
}

class _StatefulContainerState extends State<StatefulContainer> {
  Color color;

  @override
  void initState() {
    super.initState();
    color = RandomColor().randomColor();
  }

  @override
  Widget build(BuildContext context) {
    Widget widget = Container(
      width: 100,
      height: 100,
      color: color,
    );
    return widget;
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(StatefulContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
  }
}

class StatelessContainer extends StatelessWidget {
  final Color color = RandomColor().randomColor();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: color,
    );
  }
}

class RandomColor {
  Color randomColor() {
    return Color.fromARGB(
        random(150, 255), random(0, 255), random(0, 255), random(0, 255));
  }

  int random(int min, int max) {
    final _random = math.Random();
    return min + _random.nextInt(max - min + 1);
  }
}
