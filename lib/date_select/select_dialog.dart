import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_box/flutter_ui_kit.dart';

/// do what
/// @author yulun
/// @since 2020-08-15 23:54
class CascadeTestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("级联选择框"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('日期选择'),
            onTap: () {
              showModalBottomSheet<String>(
                  context: context,
                  // 圆角
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0)),
                  ),
                  // 背景色
                  backgroundColor: Colors.white,
                  builder: (context) {
                    return DateSelectDialog("");
                  }).then((value) async {
                if (isNotEmpty(value)) {
                  print("the result is $value");
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
