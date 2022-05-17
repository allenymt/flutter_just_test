import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// do what
/// @author yulun
/// @since 2021-08-24 11:09

mixin StaticTest {
  static bool? _enable2201;
  static Future<bool>? _fEnable2201;
  Future<bool?> enable2201() async {
    if (_enable2201 != null) {
      print("mixinTest _enable2201 not null $_enable2201");
      return _enable2201;
    }
    // 假设await Future.value(true)非常耗时，而enable2201在某个瞬间会被调用N次，
    // 那也就意味着await Future.value(true)会被调用N次，这有没有好的方法
    if (_fEnable2201== null){
      print("mixinTest _fEnable2201_1 is null");
      _fEnable2201 = Future.value(true);
      print("mixinTest _fEnable2201_2 is null");
    }
    _enable2201 = await _fEnable2201 ;
    print("mixinTest _enable2201 is null $_enable2201");
    return _enable2201 ?? true;
  }
}

class MixinTestA with StaticTest {
  String? a;
  String? b;

  void testA() {
    enable2201();
  }
}

class MixinTestB with StaticTest {
  String? a;
  String? b;

  void testB() {
    enable2201();
  }
}

class mixinTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("mixinTest"),),
      body: Column(
        children: [
          GestureDetector(
            onTap: (){
              MixinTestA ma = new MixinTestA();
              ma.testA();

              MixinTestB mb = new MixinTestB();
              mb.testB();
            },
            child: Text("click me",style: TextStyle(fontSize: 30),),
          ),
        ],
      ),
    );
  }
}
