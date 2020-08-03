import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// do what
/// @author yulun
/// @since 2020-07-09 17:38

class offScreenWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            // 这里可以出发offer layer，因为这里内部使用到了colorfilter
            appBar: AppBar(), // 动态模糊导航栏
            body: Stack(
              children: <Widget>[
                Positioned.fromRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 5,
                      sigmaY: 5,
                    ),
                    child: Container(
                      color: Colors.white10,
                    ),
                  ),
                  rect: Rect.fromLTRB(0, 0, 200, 200),),
                Positioned(
                    child: Container(
                      constraints:
                          BoxConstraints.tightFor(width: 400, height: 400),
                      child: _buildColorList(),
                    ),
                    left: 0,
                    top: 0),

//          Positioned(child: Opacity(opacity: 0.5 ,child:Container(color: Colors.red,width: 300,height: 100,)),left: 0,top: 0,),
//          Positioned(child: Container(child:  Text("12312312312312312312312312312312321123123123"),),left: 0,top: 0,),
              ],
            )));
  }
}

Widget _buildColorList() {
  return ListView.builder(
    itemBuilder: (context, i) {
      return ListTile(
        title: Text(
          i.toString(),
          style: TextStyle(
              color: Color.fromARGB(
                  255, 10 * i % 255, 20 * i % 255, 30 * i % 255)),
        ),
      );
    },
    itemCount: 1000,
  );
}

class TestPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPaint(new Paint()..color = Colors.transparent);
    canvas.drawRect(new Rect.fromLTWH(50.0, 100.0, 200.0, 200.0),
        new Paint()..color = Colors.red);
    canvas.drawRect(
        new Rect.fromLTWH(150.0, 200.0, 200.0, 200.0),
        new Paint()
          ..color = Colors.white
          ..blendMode = BlendMode.dstOut);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
