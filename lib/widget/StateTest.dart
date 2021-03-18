import 'package:flutter/material.dart';

/// do what
/// @author yulun
/// @since 2020-12-17 12:12
/// 忘记了要测试什么，父state调用 setState，
class StateTestParent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateTestParentState();
  }
}

class StateTestParentState extends State {
  StateTestChild childWidget;
  StateLessTestChildState childWidget2;
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
          Positioned(
            left: 10,
            top: 10,
            // 缓存了widget的情况下，当前父亲调用了setState后，孩子都不会再出发build
            // 因为在element的updateChild方法中，判断如果新旧两个widget相等，也就是newWidget==oldWidget，不会触发build
            // 但我们正常写法都是new 一个widget,在==判断中，两个widget的引用地址肯定不同，所以对于stateFul来说会走build
            // 对于stateLess来说，直接重建了
            child: childWidget??=StateTestChild(),
          ),
          Positioned(
            left: 10,
            top: 200,
            child: childWidget2??=StateLessTestChildState(),
          )
        ],
      ),
    );
  }
}

///父亲或者祖先调用setState的时候 不会重建，只会rebuild
class StateTestChild extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateTestChildState();
  }
}

class StateTestChildState extends State<StateTestChild> {
  int i=0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("StateTestChildState build");
    return Container(
      width: 100,
      height: 100,
      alignment: Alignment.center,
      child: Text("child i is ${i++}"),
    );
  }
}

/// StatelessWidget 每次都重建
class StateLessTestChildState extends StatelessWidget {
  int i=0;
  @override
  Widget build(BuildContext context) {
    print("StateLessTestChildState build");
    return Container(
      width: 200,height: 200,
      child: Stack(
        children: <Widget>[
          Positioned(child: Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            child: Text("child i is ${i++}"),
          ),left: 0,top: 0,),
        ],
      ),
    );
  }
}

