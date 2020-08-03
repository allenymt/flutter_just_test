import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// do what
/// @author yulun
/// @since 2020-06-12 09:47

class TestTouchEventWidget extends StatefulWidget {
  @override
  State createState() => _TestTouchEventState();

}

class _TestTouchEventState extends State<TestTouchEventWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 100,
        height: 100,
        constraints: BoxConstraints(maxHeight: 100, maxWidth: 100,minHeight: 0,minWidth: 0),
        color: Colors.red,
        child: Listener(
          //为什么限定了大小没用,涉及到widget的layout why why why
          //这里解释下，当Container设置了constraints后，由于Container是组件容器，实际上参与layout的是ConstrainedBox
          //而Container中的constraints，如果是有宽高的情况下，会做一次constraints.tighten处理,在这里做了clamp操作，当父Container的w h都=max时，constraints.tighten的结果就是全是max
          //所以在这里父的constraints传递到了子Container，尽快子container做了约束，但父给的约束最小都是max,所以子的约束失效了，所以最终的效果就是子的constraints没生效
          //现象就是子的大小和父的一样大，约束没生效
          //解决方法：
          //        1. 父亲的Container添加alignment属性,Align对应的RenderPositionedBox在layout时做了loosen处理，重置了min的w 和 h为0
          //        2. padding也是铺满的，只是减去了padding值，没用
          //        3. 暂时没想到好办法
          child: Container(
            constraints: BoxConstraints(maxHeight: 50, maxWidth: 50),
            color: Colors.yellow,
          ),
          onPointerDown: (downEvent) {
            print("downEvent is $downEvent");
          },
          onPointerMove: (moveEvent) {
            print("moveEvent is $moveEvent");
          },
          onPointerUp: (upEvent) {
            print("upEvent is $upEvent");
          },
          onPointerCancel: (cancelEvent) {
            print("cancelEvent is $cancelEvent");
          },
        ),
      ),
    );
  }
}
