import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_box/widget/base/fold_up_text_widget.dart';
import 'dart:ui' as ui show  PlaceholderAlignment;
/// do what
/// @author yulun
/// @since 2020-09-08 09:25

class FoldUpDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("文本展开收起控件"),
      ),
      body: Container(
          margin: EdgeInsets.only(left: 20, top: 20, right: 20),
          child: Column(
            children: <Widget>[
              FoldUpTextWidget(
                maxLines: 5,
                buildSpan: (expand, gestureRecognizer) {
                  return TextSpan(
                      text: expand ? " ..收起" : " ..展开",
                      recognizer: gestureRecognizer,
                      style: TextStyle(color: Colors.blueAccent, fontSize: 12));
                },
                textStyle: TextStyle(color: Colors.black, fontSize: 18),
                text:
                    "我我我我我我我我是测试的文案我是测试的文案我是测试的文案我是测试的文案我是测试的文案我是测试的文案我是测试的文案我是测试的文案我是测试的文案我是测试的文案我是测试的文案我是测试的文案我是测试的文案",
              ),
              SizedBox(
                height: 30,
              ),
              FoldUpTextWidget(
                maxLines: 2,
                buildSpan: (expand, gestureRecognizer) {
                  return TextSpan(
                      text: expand ? " ..收起" : " ..展开",
                      recognizer: gestureRecognizer,
                      style: TextStyle(color: Colors.blueAccent, fontSize: 12));
                },
                textStyle: TextStyle(color: Colors.black, fontSize: 18),
                inlineSpanList: []
                  ..add(WidgetSpan(
                      child: Image.asset("assets/images/assets_test.png",width: 60,height: 30,),alignment:ui.PlaceholderAlignment.middle, ))
                  ..add(TextSpan(
                      text: "我是绿色的测试文案", style: TextStyle(color: Colors.green)))
                  ..add(TextSpan(
                      text: "我是红色的测试文案", style: TextStyle(color: Colors.red)))
                  ..add(TextSpan(
                      text: "我是黄色的测试文案123123", style: TextStyle(color: Colors.yellow)))
                  ..add(TextSpan(
                      text: "我是黑色的测试文案", style: TextStyle(color: Colors.black)))
                  ..add(TextSpan(
                      text: "我我是大字号的测试文案", style: TextStyle(color: Colors.orange,fontSize: 22)))
                  ,
              ),
            ],
          )),
    );
  }
}
