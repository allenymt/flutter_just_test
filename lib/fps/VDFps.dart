///
/// fps 获取
///
import 'dart:collection';
import 'dart:ui';
import 'package:flutter/scheduler.dart';
import 'fps_callback.dart';

///
/// fps 获取
/// Android Studio Flutter Performance中
/// 横坐标是帧序列，递增
/// 纵坐标是frameTiming.totalSpan.inMilliseconds
/// 其帧率计算方式为 FPS=实际绘制帧数*60/(实际绘制帧数+丢帧数)
class Fps {
  static Future<double> getRefreshRate() async {
    return Future<double>.value(60);
  }

  /// 单例
  static Fps get instance {
    if (_instance == null) {
      _instance = Fps._();
    }
    return _instance;
  }

  static Fps _instance;

  static const _maxFrames = 120; // 最大保存帧数据，100 帧足够了，对于 60 fps 来说
  final lastFrames =
      ListQueue<FrameTiming>(_maxFrames); //保存帧数据的队列，约定队头为最后一帧，队尾为开始一帧
  TimingsCallback _timingsCallback;
  List<FpsCallback> _callBackList = [];

  Fps._() {
    _timingsCallback = (List<FrameTiming> timings) {
      //异步计算fps
      _calculateFps(timings);
    };
    SchedulerBinding.instance.addTimingsCallback(_timingsCallback);
  }

  registerCallBack(FpsCallback back) {
    _callBackList?.add(back);
  }

  unregisterCallBack(FpsCallback back) {
    _callBackList?.remove(back);
  }

  cancel() {
    if (_timingsCallback == null) {
      return;
    }
    SchedulerBinding.instance.removeTimingsCallback(_timingsCallback);
  }

  double _refreshRate;
  Duration _frameInterval;

  /// 计算fps并回调观察者
  Future<void> _calculateFps(List<FrameTiming> timings) async {
    // 约定队头为最后一帧，队尾为开始一帧，后面的帧做前向插入
    for (FrameTiming timing in timings) {
      lastFrames.addFirst(timing);
    }

    // 只保留 maxFrames，超出则移除最早的帧
    while (lastFrames.length > _maxFrames) {
      lastFrames.removeLast();
    }

    var lastFramesSet = <FrameTiming>[];

    if (_refreshRate == null) {
      _refreshRate = (await getRefreshRate()) ?? 60;
    }
    if (_frameInterval == null) {
      _frameInterval = Duration(
          microseconds:
              Duration.microsecondsPerSecond ~/ _refreshRate); //每帧消耗的时间，单位微秒
    }

    for (FrameTiming timing in lastFrames) {
      //lastFrames 对头是最后的帧，所以第一次取出来的是队尾帧
      if (lastFramesSet.isEmpty) {
        lastFramesSet.add(timing);
      } else {
        // 帧排序如下
        // frame4 frame3 frame2 frame1
        var lastStart = //frame4的build开始，即frame3的rasterFinish，但中间是会有间隔的
            lastFramesSet.last.timestampInMicroseconds(FramePhase.buildStart);
        // 上面提到的间隔时间
        var interval =
            lastStart - timing.timestampInMicroseconds(FramePhase.rasterFinish);
        //相邻两帧如果开始结束相差时间过大，比如大于 frameInterval * 2，认为是不同绘制时间段产生的
        if (interval > (_frameInterval.inMicroseconds * 2)) {
          break; //注意这里是break，这次循环结束了
        }
        lastFramesSet.add(timing);
      }
    }

    var drawFramesCount = lastFramesSet.length;

    //在认知里，假设当前手机的FPS = 60帧，1秒渲染了60次
    // FPS / 60 = drawFramesCount / (drawFramesCount + droppedCount)
    // FPS ≈ 60 * drawFramesCount / (drawFramesCount + droppedCount)
    // costCount = (drawFramesCount + droppedCount)
    // FPS ≈  60 * drawFramesCount / costCount

    int droppedFramesCount = 0; //丢帧数
    double droppedFramesTime = 0; //丢帧时长

    // 计算总的帧数
    var costCount = lastFramesSet.map((frame) {
      // 耗时超过 frameInterval 认为是丢帧
      // 15MS ~/ 16MS = 0
      // 16MS ~/ 16MS = 0
      // 17MS ~/ 16MS = 0
      // 所以只要droppedCount大于0 ，认为当前帧是丢帧的
      int droppedCount =
          (frame.totalSpan.inMicroseconds ~/ _frameInterval.inMicroseconds);
      if (droppedCount > 0) {
        //一帧绘制时间大于frameInterval部分的时间认为是丢帧时长，累加
        droppedFramesTime +=
            (frame.totalSpan.inMicroseconds - _frameInterval.inMicroseconds);
      }
      return droppedCount +
          1; //自己本身绘制的一帧，这里加一是因为认为丢帧了，加1变成2或3，主要看实际消耗的时长，如果是正常帧，那就是0+1=1
    }) //这里返回的其实是个list<int>
        .fold(
            0,
            (a, b) =>
                a + b); //计算总的帧数，fold就是list[0]+list[1]+....list[list.len-1]
    //丢帧数=总帧数-绘制帧数
    droppedFramesCount = costCount - drawFramesCount;
    double fps = drawFramesCount * _refreshRate / costCount; //参考上面那四行公式
    int droppedFramesMillisecondTime =
        droppedFramesTime ~/ Duration.microsecondsPerMillisecond; //转换成毫秒单位
    _callBackList?.forEach((callBack) {
      callBack(fps, droppedFramesCount.toDouble());
    });
    print(
        "wdb_fps,fps is $fps _refreshRate is $_refreshRate droppedFramesCount is $droppedFramesCount droppedFramesMillisecondTime is $droppedFramesMillisecondTime ");
  }
}
