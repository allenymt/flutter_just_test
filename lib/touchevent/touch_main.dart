import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'gesture_recogize_test.dart';
import 'listener_widget_test.dart';

/// do what
/// @author yulun
/// @since 2020-11-09 14:27
class TouchMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Touch Test List'),
          ),
          body: ListView(
            children: <Widget>[
              ListTile(
                title: Text('事件竞争测试'),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext c) {
                    return GestureRecognizerTest();
                  }));
                },
              ),
              ListTile(
                title: Text('事件监听测试'),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext c) {
                    return TestTouchEventWidget();
                  }));
                },
              ),
            ],
          )),
    );
  }
}
