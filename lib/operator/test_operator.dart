import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// do what
/// @author yulun
/// @since 2020-05-18 18:47
class TestOperator {
  String name;
  double price;

  TestOperator(this.name, this.price);

  TestOperator operator +(TestOperator testOperator) =>
      TestOperator(name + testOperator.name, price + testOperator.price);

  @override
  String toString() {
    return "name is $name,price is $price";
  }
}

class TestOperatorWidget extends StatelessWidget {
  TestOperator _a;
  TestOperator _b;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: SafeArea(child: Scaffold(body: Text((_a + _b).toString()))),
    );
  }

  TestOperatorWidget() {
    _a = TestOperator("测试1", 111);
    _b = TestOperator("测试2", 222);
  }
}
