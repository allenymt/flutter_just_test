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
            // 对于其他文章来说，要下沉setState是没错的，因为正常情况都是new Widget写法
            // child: childWidget??=StateTestChild(),
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("StateTestParentState didChangeDependencies");
  }

  @override
  void dispose() {
    super.dispose();
    print("StateTestParentState dispose");
  }

  @override
  void deactivate() {
    super.deactivate();
    print("StateTestParentState deactivate");
  }

  @override
  void reassemble() {
    super.reassemble();
    print("StateTestParentState reassemble");
  }

  @override
  void didUpdateWidget(StateTestParent oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("StateTestParentState didUpdateWidget");
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    print("StateTestParentState setState");
    // state之后发生了什么，这里以孩子为statefulElement举例
    // 1. 标记自身的element为dirty
    // 2. 下一帧到来后，buildScope会遍历所有dirty的element，对每一个element调用rebuild方法
    // 3. rebuild方法里会调用performRebuild方法
    // 4. 对于statefulElement，重写了performRebuild，会校验是否需要调用state的didChangeDependencies
    // 5. 接着走父类的 performRebuild，这里的父类指的是ComponentElement，会走到build方法
    // 6. build方法，对于statefulElement的 state的build方法
    // 7. 接着在performRebuild里会继续走updateChild方法，这里就是element的diff 更新逻辑
    // 8. 如果孩子也是statefulElement，那会走到孩子的update方法
    // 9. 对于孩子的statefulElement，在update里会调用state的didUpdateWidget方法，然后调用rebuild
    // 10. 这样又走到第三步了，一直循环下去更新所有的孩子


    // buildScope的注册流程，调用流程
    // 1. 在RenderBinding里注册了PersistentFrameCallback持续回调
    // 2.

    // PipelineOwner的注册流程，调用流程
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
  int i = 0;

  @override
  void initState() {
    print("StateTestChildState initState");
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("StateTestChildState didChangeDependencies");
  }

  @override
  void dispose() {
    super.dispose();
    print("StateTestChildState dispose");
  }

  @override
  void deactivate() {
    super.deactivate();
    print("StateTestChildState deactivate");
  }

  @override
  void reassemble() {
    super.reassemble();
    print("StateTestChildState reassemble");
  }

  @override
  void didUpdateWidget(StateTestChild oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("StateTestChildState didUpdateWidget");
  }
}

/// StatelessWidget 每次都重建
class StateLessTestChildState extends StatelessWidget {
  int i = 0;

  StateLessTestChildState() {
    print("StateLessTestChildState create");
  }

  @override
  Widget build(BuildContext context) {
    print("StateLessTestChildState build");
    return Container(
      width: 200,
      height: 200,
      child: Stack(
        children: <Widget>[
          Positioned(
            child: Container(
              width: 100,
              height: 100,
              alignment: Alignment.center,
              child: Text("child i is ${i++}"),
            ),
            left: 0,
            top: 0,
          ),
        ],
      ),
    );
  }
}
