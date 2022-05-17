import 'package:flutter/cupertino.dart';

/// do what
/// @author yulun
/// @since 2022-04-26 11:50

class TestLeakClass {
  int a = 1;
  List<StatefulWidget>? widgetList;
  String s = "123";

  void testFun() {
    a = a + 2;
    s = s + "1234";
  }
}
