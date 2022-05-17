import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// do what
/// @author yulun
/// @since 2020-07-15 20:47
class TestMemory extends StatefulWidget {
  @override
  State createState() {
    return TestMemoryState();
  }
}

class TestMemoryState extends State<TestMemory> {

  @override
  Widget build(BuildContext context) {
    print("TestMemoryState build 123");
    _build();
    return Scaffold(
      appBar: AppBar(
        title: Text("testMemory"),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            for (int i = 0; i < 10000; i++) {
              TestB(i, i + 1);
            }
          },
          child: Text("click me test"),
        ),
      ),
    );
  }

  _build() {
    print("TestMemoryState build");
    for (int i = 0; i < 10; i++) {
      TestA(i, i + 1);
    }
  }
}

class TestA {
  int? a;
  int? b;
  double? c;

  TestA._(int a, int b) {
    this.a = a;
    this.b = b;
    this.c = 1;
  }

  factory TestA(int a, int b) {
    return TestA._(a, b);
  }
}

class TestB {
  int? a;
  int? b;
  double? c;

  TestB._(int a, int b) {
    this.a = a;
    this.b = b;
    this.c = 1;
  }

  factory TestB(int a, int b) {
    return TestB._(a, b);
  }
}