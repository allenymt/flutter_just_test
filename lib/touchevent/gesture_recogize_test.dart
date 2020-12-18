/// do what
/// @author yulun
/// @since 2020-11-09 14:25
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// do what
/// @author yulun
/// @since 2020-06-12 09:47

class GestureRecognizerTest extends StatefulWidget {
  @override
  State createState() => _GestureRecognizerState();
}

class _GestureRecognizerState extends State<GestureRecognizerTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("事件竞争"),
        ),
        body: GestureDetector(
          onTap: () {
            print('tab parent');
          },
          child: Container(
            width: 300,
            height: 300,
            color: Colors.red,
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                print('tab child');
              },
              child: Container(
                width: 100,
                height: 100,
                color: Colors.green,
              ),
            ),
          ),
        ));
  }
}
