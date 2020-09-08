import 'package:flutter/material.dart';

import 'animation_pageview_demo.dart';
import 'fold_up_demo.dart';
import 'prelaod_pageview_demo.dart';
import 'select_dialog.dart';

/// do what
/// @author yulun
/// @since 2020-09-07 14:29
class UiBoxDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ui Box',
      home: Scaffold(
          appBar: AppBar(
            title: Text('Ui Box Demo List'),
          ),
          body: ListView(
            children: <Widget>[
              ListTile(
                title: Text('级联选择框 选日期，选地址'),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext c) {
                    return CascadeTestWidget();
                  }));
                },
              ),
              ListTile(
                title: Text('高度容器自适应变化'),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext c) {
                    return AnimationPageViewWidget();
                  }));
                },
              ),

              ListTile(
                title: Text('预加载pageView'),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext c) {
                    return PreLoadPageViewDemo();
                  }));
                },
              ),
              ListTile(
                title: Text('文本展开收起控件'),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext c) {
                    return FoldUpDemo();
                  }));
                },
              ),
            ],
          )),
    );
  }
}