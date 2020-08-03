import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// do what
/// @author yulun
/// @since 2020-06-22 11:20
class EventLoopTestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          child: Text(
            "123",
            style: TextStyle(fontSize: 30),
          ),
          onTap: () async{
            scheduleMicrotask(() => print('EventTest This is a microtask'));
//            testFuture();
//            testFutureDelay();
            testFutureAwait();
          },
        ),
      ),
    );
  }

  void testFuture() {
    // 说下自己的理解，代码同步执行的结果是 一个future为一个单位加到event queue里，如果是microtask 那就放到task里，所以f12是最先输出的。
    // 下面开始第一个循环，只有f11是microtask，所以f11先执行
    // 第一个循环事件后，第二个事件是f1，因为f1是第一个被驾到事件里的
    // 接着是fx,注意fx跟了then，这两个是同个事件循环，所以fx执行完后 f10执行了
    // f2 f3 f5 f4 同理，为什么f4在f6前面？因为1个future占用了一个事件循环，下一个循环来时，发现task里有任务，就执行f4了
    // f6 f9 f7 f8 , f7 f8 后面被执行是y8是因为 f7重新构建了future，加到了queue的尾部
    // f12 f11 f1 f10  f2 f3 f5 f4 f6 f9 f7 f8
    Future(() => print('f1')); // 声明一个匿名 Future
    Future fx = Future(() => null); // 声明 Future fx，其执行体为 null
// 声明一个匿名 Future，并注册了两个 then。在第一个 then 回调里启动了一个微任务
    Future(() => print('f2')).then((_) {
      print('f3');
      scheduleMicrotask(() => print('f4'));
    }).then((_) => print('f5'));

// 声明了一个匿名 Future，并注册了两个 then。第一个 then 是一个 Future
    Future(() => print('f6'))
        .then((_) => Future(() => print('f7')))
        .then((_) => print('f8'));

// 声明了一个匿名 Future
    Future(() => print('f9'));

// 往执行体为 null 的 fx 注册了了一个 then
    fx.then((_) => print('f10'));

// 启动一个微任务
    scheduleMicrotask(() => print('f11'));
    print('f12');
  }

  void testFutureDelay() async {
    await fetchContent();
  }

  // 异步函数会同步等待 Hello 2019 的返回，并打印
  func() async => print(await fetchContent());

  // await 和 async , 只针对声明的函数有效，在这个例子里，输出 func before,func after , hello 2019,整个func都被丢到event queue里等待执行了
  void testFutureAwait()  {
    print("func before");
     func();
    print("func after");
  }

  // 这个例子 就是 func before,hello 2019,func after
  void testFutureAwait2() async {
    print("func before");
    await func();
    print("func after");
  }

  Future<String> fetchContent() =>
      Future<String>.delayed(Duration(seconds: 3), () => "Hello")
          .then((x) => "$x 2019");
}
