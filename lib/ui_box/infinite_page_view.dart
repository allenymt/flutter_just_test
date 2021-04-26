import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_box/flutter_ui_kit.dart';

/// do what
/// @author yulun
/// @since 2021-04-22 11:37

// ignore: must_be_immutable
class PageViewDemo extends StatelessWidget {
  List<int> testDate = [1, 2, 3];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 2,
          child: InfinitePageView(
            onPageChange: (index) {
              print("onPageChange index is $index");
            },
            autoScroll: true,
            cycleRolling: true,
            autoPlaySeconds: 1,
            countMultiple: 10,
            count: testDate.length,
            buildItem: (context, index) {
              return Container(
                child: Center(
                  child: Text(
                    '${testDate.elementAt(index)}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                color: Colors.black,
              );
            },
          ),
        ),
      ),
    );
  }
}
