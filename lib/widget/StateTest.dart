import 'package:flutter/material.dart';

/// do what
/// @author yulun
/// @since 2020-12-17 12:12

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
          )
        ],
      ),
    );
  }
}

class StateTestChild extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateTestChildState();
  }
}

class StateTestChildState extends State<StateTestChild> {
  int i=0;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      alignment: Alignment.center,
      child: Text("child ${i++}"),
    );
  }
}
