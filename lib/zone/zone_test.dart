import 'dart:async';

import 'package:flutter/material.dart';

/// do what
/// @author yulun
/// @since 2020-07-27 11:49
class ZoneTestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var future = new Future.value(499);
    runZoned(() {
      var future2 = future.then((_) {
        throw "error in first error-zone";
      }).catchError((e) {
        print("Never reached!");
      });
      runZoned(() {
        var future3 = future2.catchError((e) {
          print("Never reached!");
        });
        throw "error in first error-zone";
      }, onError: (e, s) {
        print("unused error handler");
      });
    }, onError: (e, s) {
      print("catches error of first error-zone.");
    });
    return Scaffold(
      body: Center(
        child: Text("ZoneTest"),
      ),
    );
  }
}
