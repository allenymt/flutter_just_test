import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

import 'fps_callback.dart';

/// do what
/// @author yulun
/// @since 2020-07-17 11:36
class aliFps {
  static aliFps _instance;

  static final TAG = "aliFps";

  static aliFps get instance {
    if (_instance == null) {
      _instance = aliFps._();
    }
    return _instance;
  }

  /// 1s里最高120hz了吧
  static const MAX_FPS = 120;
  Timer _timer;
  ListQueue<_VdFrame> _frameQueue = ListQueue(MAX_FPS);
  bool _init;
  List<FpsCallback> _callBackList = [];

  aliFps._();

  init() {
    if (_init ?? false) {
      return;
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      //时间达到一秒了，开始计算这一秒的帧率
      _calFps();
    });
    _registerListener();
    _init = true;
  }

  cancel() {
    _timer?.cancel();
    _timer = null;
    if (beginCallId != null) {
      WidgetsBinding.instance.cancelFrameCallbackWithId(beginCallId);
    }
    drawTimeCallback = null;
  }

  registerCallBack(FpsCallback back) {
    _callBackList?.add(back);
  }

  unregisterCallBack(FpsCallback back) {
    _callBackList?.remove(back);
  }

  _VdFrame _currentFrame;
  var frameId = 1;
  FrameCallback beginTimeCallback;
  int beginCallId;
  FrameCallback drawTimeCallback;

  _registerListener() {
    print("$TAG,_registerListener1");
    beginTimeCallback = (timeStamp) {
      // handle begin frame
      _beginFrame(timeStamp);
      beginCallId =
          WidgetsBinding.instance.scheduleFrameCallback(beginTimeCallback);
    };

    // 理论上每一帧应该都是先begin,再draw
    // 那有没有可能是上一针没draw完，下一帧begin开始了
    beginCallId =
        WidgetsBinding.instance.scheduleFrameCallback(beginTimeCallback);

    print("$TAG,_registerListener2");
    drawTimeCallback = (timeStamp) {
      // handle draw frame
//      print("$TAG+123,_drawFrame");
      _drawFrame(timeStamp);
    };
    WidgetsBinding.instance.addPersistentFrameCallback(drawTimeCallback);
    print("$TAG,_registerListener3");
  }

  _beginFrame(Duration time) {
    if (_currentFrame == null) {
      _currentFrame = _VdFrame(frameId++, frameStartTime: time.inMicroseconds);
    } else {
      _currentFrame.clear();
      _currentFrame.frameId = frameId++;
      _currentFrame.frameStartTime = time.inMicroseconds;
    }
  }

  _drawFrame(Duration time) {
    if (_currentFrame == null || (_currentFrame?.frameStartTime ?? 0) <= 0) {
      print("$TAG,error not begin");
    }

    if ((_currentFrame?.frameId ?? 0) + 1 != frameId) {
      print("$TAG,error not call draw ,but call begin twice");
    }

    _currentFrame.frameEndTime = time.inMilliseconds;
    _frameQueue.addFirst(_currentFrame);
  }

  /// 计算fps
  _calFps() {
    if (_frameQueue.isEmpty) {
      print("$TAG,NO FRAME");
      return;
    }
    var _calFrameQueue = ListQueue(MAX_FPS);
    _calFrameQueue.addAll(_frameQueue);
    _frameQueue?.clear();

    while (_calFrameQueue.length > MAX_FPS) {
      _calFrameQueue.removeLast();
    }
    int FPS = 60; // 可以通过plugin获取
    int drawFrame = _calFrameQueue.length;
    int dropFrameCount = FPS - drawFrame;
    _callBackList?.forEach((callBack) {
      callBack(drawFrame.toDouble(), dropFrameCount.toDouble());
    });
    print("$TAG drawFrame is $drawFrame,dropFrameCount is $dropFrameCount");
  }
}

class _VdFrame {
  int frameStartTime;
  int frameEndTime;
  int frameId;

  _VdFrame(this.frameId, {this.frameStartTime, this.frameEndTime});

  clear() {
    frameStartTime = 0;
    frameEndTime = 0;
    frameId = 0;
  }
}
