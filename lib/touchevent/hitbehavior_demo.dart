import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// do what
/// @author yulun
/// @since 2020-12-20 13:48

/// HitTestBehavior demo
/// 源码角度说明三个参数的区别
class HitBehaviorDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("hit behavior demo"),
      ),

      body: buildChild1(),
    );
  }

  // 默认情况下，Row的空白处不响应点击事件，有两个方法
  // 1. 设置behavior为HitTestBehavior.opaque或者translucent
  // 2. Container设置背景色,任意背景色都可以
  Widget buildChild1() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 200,
        // color: Colors.transparent,
        // decoration: BoxDecoration(color: Colors.transparent),
        padding: EdgeInsets.only(left: 5, right: 5),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              "left text",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "right text",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      onTap: () {
        print("click");
      },
    );
  }

  //translucent和opaque的区别
  Widget buildChild2() {
    return Stack(
      children: <Widget>[
        Listener(
          child: ConstrainedBox(
            constraints: BoxConstraints.tight(Size(300.0, 300.0)),
            child: DecoratedBox(decoration: BoxDecoration(color: Colors.red)),
          ),
          onPointerDown: (event) => print("first child"),
        ),
        Listener(
          child: ConstrainedBox(
            constraints: BoxConstraints.tight(Size(200.0, 200.0)),
            child: Center(child: Text("左上角200*200范围内-空白区域点击")),
          ),
          onPointerDown: (event) => print("second child"),
          //放开此行注释后，单词点击 first ,second都会响应，HitTestBehavior.opaque是不行的
          behavior: HitTestBehavior.translucent,
        )
      ],
    );
  }
}
