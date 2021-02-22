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
            child: StateTestChild(),
          ),
          Positioned(
            left: 10,
            top: 200,
            child: StateLessTestChildState(),
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
  int j=0;
  @override
  void initState() {
    super.initState();
    j++;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      alignment: Alignment.center,
      child: Text("child i is ${i++}, j is $j"),
    );
  }
}

/// StatelessWidget 每次都重建
class StateLessTestChildState extends StatelessWidget {
  int i=0;
  @override
  Widget build(BuildContext context) {
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
          Positioned(
            child: StateTestChild(),
            left: 10,top: 110,
          ),
        ],
      ),
    );
  }
}

