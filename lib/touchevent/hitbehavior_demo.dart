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
      // 默认情况下，Row的空白处不响应点击事件，有两个方法
      // 1. 设置behavior为HitTestBehavior.opaque或者translucent
      // 2. Container设置背景色,任意背景色都可以
      body: GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        child: Container(
          height: 50,
          // color: Colors.transparent,
          decoration: BoxDecoration(color: Colors.transparent),
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
      ),
    );
  }
}
