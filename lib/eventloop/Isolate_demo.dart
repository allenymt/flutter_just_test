import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// do what
/// @author yulun
/// @since 2020-06-23 19:38
/// TODO
class IsolateTestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          child: Text(
            "isolate_test",
            style: TextStyle(fontSize: 30),
          ),
          onTap: () {
            testSingleIsolate();
          },
        ),
      ),
    );
  }

  void testSingleIsolate() async {
//    await _portOnce();
//    await _checkInit();
    await textIsolate2();
  }

  /// 一次性port
  Isolate? isolate1;

  _portOnce() async {
    // 创建并发 Isolate，并传入发送管道
    ReceivePort receivePort = ReceivePort(); // 创建管道
    isolate1 = await Isolate.spawn(doSomething, receivePort.sendPort);
    receivePort.listen((message) {
      print('IsolateTest once：$message');
      isolate1?.kill(priority: Isolate.immediate);
      receivePort?.close();
      isolate1 = null;
    });
  }

  /// 并发 Isolate 往管道发送一个字符串
  static void doSomething(SendPort sendPort) {
    sendPort.send("123213");
  }

  /// 一次性port end

  /// reuse port start
  SendPort? _reUseSendPort;
  Isolate? isolate2;

  Future<void> _checkInit() async {
    if (isolate2 == null) {
      ReceivePort receivePort = new ReceivePort();
      isolate2 = await Isolate.spawn(_binding, receivePort.sendPort);
      _reUseSendPort = await (receivePort.first as FutureOr<SendPort?>);
    }
    _reUseSendPort!.send("1234");
  }

  static void _binding(SendPort sendPort) {
    ReceivePort answerReport = new ReceivePort();
    answerReport.listen((message) {
      print('IsolateTest reuse：$message');
    });
    sendPort.send(answerReport.sendPort);
  }

  /// reuse port end

  //两个方法都需要改造下，第一个只要把主的port传递给子isolate，子isolate里做计算就行了，在主的port需要做类型判断
  // 并发计算阶乘
  Future<void> asyncFactoriali(n) async {
    final response = ReceivePort(); // 创建管道
    // 创建并发 Isolate，并传入管道
    await Isolate.spawn(_isolate, response.sendPort);
    // 等待 Isolate 回传管道
    response.listen((message) {
      if (message is SendPort) {
        message.send(n);
      } else {
        print('IsolateTest123：$message');
      }
    });
  }



// 同步计算阶乘
  static int? syncFactorial(n) => n < 2 ? n : n * syncFactorial(n - 1);

  textIsolate2() async {
    // 等待并发计算阶乘结果
    await asyncFactoriali(5);
  }


// 使用 compute 函数封装 Isolate 的创建和结果的返回
  static textIsolateCompute() async => print(await compute(syncFactorial, 4));
}

//Isolate 函数体，参数是主 Isolate 传入的管道
 _isolate(initialReplyTo) async {
  final port = ReceivePort(); // 创建管道
  initialReplyTo.send(port.sendPort); // 往主 Isolate 回传管道
  port.listen((message) {
    if (message is int) {
//      initialReplyTo.send(syncFactorial(message));
    }
  });
}