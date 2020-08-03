import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:performance_fps/performance_fps.dart';

/// do what
/// @author yulun
/// @since 2020-07-17 14:51
/// https://pub.dev/packages/performance_fps
class TestFpsWidget extends StatefulWidget {
  @override
  State createState() {
    return TestFpsState();
  }
}

class TestFpsState extends State<TestFpsWidget> {
  var fps;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("fps"),
        ),
        body: Column(
          children: <Widget>[
            GestureDetector(
              child: Container(
                constraints: BoxConstraints.tightFor(width: 100, height: 50),
                alignment: Alignment.center,
                child: Text("open fps"),
                color: Colors.red,
              ),
              onTap: () {
                Fps.instance.registerCallBack((fps, dropCount) {
                  // current fps
                  this.fps = fps;
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              child: Container(
                constraints: BoxConstraints.tightFor(width: 100, height: 50),
                alignment: Alignment.center,
                child: Text("close fps"),
                color: Colors.green,
              ),
              onTap: () {
                Fps.instance.cancel();
              },
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              child: Container(
                constraints: BoxConstraints.tightFor(width: 300, height: 50),
                alignment: Alignment.center,
                child: Text("fps is $fps"),
                color: Colors.deepOrange,
              ),
              onTap: () {
                setState(() {

                });
              },
            ),
          ],
        ));
  }
}
