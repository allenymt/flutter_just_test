import 'dart:async';

import 'package:flutter/material.dart';

/// do what
/// @author yulun
/// @since 2021-03-31 14:50

/// 倒计时组件
class CountDownWidget extends StatefulWidget {
  final int? countTimeInMilliseconds;

  final Function()? onCountDownFinish;

  final Widget Function(BuildContext context, String hour, String minute,
      String seconds, bool finish)? buildTimeWidget;

  CountDownWidget(
      {this.countTimeInMilliseconds,
        this.onCountDownFinish,
        this.buildTimeWidget});

  @override
  State<StatefulWidget> createState() {
    return _CountDownWidgetState();
  }
}

class _CountDownWidgetState extends State<CountDownWidget>
    with WidgetsBindingObserver {
  Timer? _timer;
  late Duration offset;

  String parseHour() {
    int hour = offset.inHours.remainder(60);
    if (hour <= 0) hour = 0;
    if (hour < 10) {
      return "0$hour";
    }

    return "$hour";
  }

  String parseMinute() {
    int minute = offset.inMinutes.remainder(60);
    if (minute <= 0) minute = 0;
    if (minute < 10) {
      return "0$minute";
    }
    return "$minute";
  }

  String parseSeconds() {
    int seconds = offset.inSeconds.remainder(60);
    if (seconds <= 0) seconds = 0;
    if (seconds < 10) {
      return "0$seconds";
    }
    return "$seconds";
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _refreshOffset();
    if (offset.inSeconds > 0) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        // 每秒刷新一次
        offset = Duration(milliseconds: offset.inMilliseconds - 1000);
        if (offset.inSeconds <= 0) {
          _timer!.cancel();
          widget?.onCountDownFinish!();
        }
        setState(() {});
      });
    }
  }

  /// 刷新计时器
  void _refreshOffset() {
    DateTime saleDate =
    DateTime.fromMillisecondsSinceEpoch(widget.countTimeInMilliseconds!);
    DateTime now = DateTime.now();
    offset = saleDate.difference(now);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// 回到可交互状态后需要重新计算时间，在pause后，timer会停止计时
    if (state == AppLifecycleState.resumed) {
      _refreshOffset();
    }
  }

  @override
  void didUpdateWidget(CountDownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    /// 时长不一样地方时候 ，需要重新计算
    if (oldWidget.countTimeInMilliseconds != widget.countTimeInMilliseconds) {
      _refreshOffset();
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    _timer?.cancel();
  }

  @override
  build(BuildContext context) {
    return widget.buildTimeWidget!(context, parseHour(), parseMinute(),
        parseSeconds(), offset.inSeconds <= 0);
  }
}
