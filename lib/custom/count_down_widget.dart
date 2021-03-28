import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// do what
/// @author yulun
/// @since 2021-03-27 14:38
/// 自定义 倒计时widget
class CountDownWidget extends StatefulWidget {
  final int saleTimeMilliseconds;

  CountDownWidget(this.saleTimeMilliseconds);

  @override
  State<StatefulWidget> createState() {
    return CountDownState();
  }
}

class CountDownState extends State<CountDownWidget> {
  @override
  Widget build(BuildContext context) {
    // return Text(
    //     "${offset.inHours.toString()} : ${offset.inMinutes - offset.inHours * 60} : ${offset.inSeconds - offset.inMinutes * 60}");

    return RichText(
        text: TextSpan(
            children: [
          TextSpan(text: parseHour()),
          TextSpan(text: ":"),
          TextSpan(text: parseMinute()),
          TextSpan(text: ":"),
          TextSpan(text: parseSeconds()),
        ],
            style: TextStyle(
              color: Colors.red,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            )));
  }

  String parseHour() {
    int hour = offset.inHours.remainder(60);
    if (hour <=0)
      hour = 0;
    if (hour < 10) {
      return "0$hour";
    }

    return "$hour";
  }

  String parseMinute() {
    int minute = offset.inMinutes.remainder(60);
    if (minute <=0)
      minute = 0;
    if (minute < 10) {
      return "0$minute";
    }
    return "$minute";
  }

  String parseSeconds() {
    int seconds = offset.inSeconds.remainder(60);
    if (seconds <=0)
      seconds = 0;
    if (seconds < 10) {
      return "0$seconds";
    }
    return "$seconds";
  }

  Timer _timer;
  Duration offset;

  @override
  void initState() {
    super.initState();
    final saleDate =
        DateTime.fromMillisecondsSinceEpoch(widget.saleTimeMilliseconds);
    final now = DateTime.now();
    offset = saleDate.difference(now);
    if (offset.inSeconds > 0){
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        offset = Duration(milliseconds: offset.inMilliseconds - 3000);
        if (offset.inSeconds <0){
          _timer?.cancel();
        }
        setState(() {
          // 每秒刷新一次
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
}
