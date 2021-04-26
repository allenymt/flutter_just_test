import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

const int delayPlaySeconds = 4;

/// do what
/// @author yulun
/// @since 2020-06-23 14:47
/// 支持无限循环滚动
/// 支持自动轮播
class WdbPageView extends StatefulWidget {
  /// page数量
  final int count;

  /// 构建item
  final Widget Function(BuildContext context, int index) buildItem;

  /// 页面切换
  final void Function(int pageIdnex) onPageChange;

  /// 控制器监听器
  final void Function(PageController controller) onControllerListener;

  /// 支持自动轮播 默认false
  final bool autoScroll;

  /// 无限滚动
  final bool cycleRolling;

  /// 轮播间隔时间 , 默认4s
  final int autoPlaySeconds;

  /// 轮播动画时间
  final Duration animateDuration;

  ///
  final double viewportFraction;

  ///
  final bool padEnds;

  /// 初始化位置
  final int initIndex;

  /// 系数
  /// 例如 [1，2，3],countMultiple = 5,那实际的个数就是15，业务方还是正常使用
  /// 参考了其他方案，index个数都是无限大，这个对于内存肯定是个大问题，除非用key复用，但这样对于业务方来说就显的比较复杂了
  final int countMultiple;

  WdbPageView({
    @required this.count,
    @required this.buildItem,
    this.viewportFraction = 1.0,
    this.padEnds = true,
    this.onPageChange,
    this.onControllerListener,
    this.autoScroll = false,
    this.cycleRolling = true,
    this.autoPlaySeconds = delayPlaySeconds,
    this.animateDuration = kTabScrollDuration,
    this.initIndex = 0,
    this.countMultiple = 1,
  })  : assert(count > 0, "count >0 "),
        assert(buildItem != null, "buildItem can't be null");

  @override
  State createState() {
    return WdbPageViewState();
  }

  static WdbPageViewState of(BuildContext context) {
    return context.findAncestorStateOfType<WdbPageViewState>();
  }
}

class WdbPageViewState extends State<WdbPageView> with WidgetsBindingObserver {
  static const String Tag = "WdbPageView";

  ///当前页面数量
  int get itemCount => widget.count;

  int get countMultiple => widget.countMultiple;

  /// 内部的页面数
  int get innerPageCount {
    if (itemCount <= 1 || !widget.cycleRolling) return itemCount;
    if (widget.cycleRolling) return (itemCount * countMultiple) + 2;
    return itemCount * countMultiple;
  }

  bool get cycleRolling => widget.cycleRolling && itemCount > 1;

  Function get buildItem => widget.buildItem;

  Function get onPageChange => widget.onPageChange;

  Function get onControllerListener => widget.onControllerListener;

  double get viewportFraction => widget.viewportFraction;

  bool get padEnds => widget.padEnds;

  /// 自动播放控制器
  Timer _autoPlayTimer;

  PageController _pageController;

  /// 实际的index
  int _innerPageIndex;

  /// false 说明没有手动滑动过，触发自动滚动
  /// true 手势滚动过了
  /// 在一个自动滚动周期内的判断值,如果这个周期内手动滚动过了，自动滚动不会触发
  bool _jumpAutoScroll = false;

  /// 手指在触摸过程中，不开启自动轮播
  bool _inTouch = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _isActive = true;
    startAutoPlay();
    _innerPageIndex = cycleRolling ? widget.initIndex + 1 : widget.initIndex;
    _pageController = PageController(
      initialPage: _innerPageIndex,
      viewportFraction: viewportFraction,
    );
    _pageController.addListener(() {
      if (onControllerListener != null) {
        onControllerListener(_pageController);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child = PageView.builder(
      controller: _pageController,
      itemCount: innerPageCount,
      onPageChanged: (index) {
        _doChangePageIndex(index);
      },
      itemBuilder: (context, index) {
        Widget child = buildItem(context, _parseShowIndex(index));
        bool debug = false;
        assert(debug = true);
        if (debug) {
          child = Stack(
            children: [
              Positioned.fill(child: child),
              Positioned(
                  left: 0,
                  top: 10,
                  child: Text(
                    "realIndex is $index",
                    style: TextStyle(color: Colors.red, fontSize: 30),
                  )),
            ],
          );
        }
        return child;
      },
    );

    child = Listener(
      onPointerDown: (event) {
        _inTouch = true;
      },
      onPointerCancel: (event) {
        _inTouch = false;
      },
      onPointerUp: (event) {
        _inTouch = false;
      },
      child: child,
    );

    child = NotificationListener(
      child: child,
      onNotification: (notification) {
        this._handleScrollNotification(notification);
        return true;
      },
    );
    return child;
  }

  @override
  void didUpdateWidget(WdbPageView oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    cancelAutoPlay();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// 当前是否处于活跃态
  bool _isActive;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _isActive = true;
    } else {
      _isActive = false;
    }
  }

  void cancelAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;
  }

  void startAutoPlay() {
    if (!widget.autoScroll) return;
    if ((itemCount ?? 0) <= 1) return;
    //参考RestartableTimer的写法
    if (_autoPlayTimer == null && cycleRolling) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        _autoPlayTimer = Timer.periodic(
            Duration(seconds: widget?.autoPlaySeconds ?? delayPlaySeconds),
            (timer) {
              /// 只有一个像素时，不开启自动轮播
          if (itemCount <= 1) {
            return;
          }

            /// 用户在触摸时，不开启轮播
          if (_inTouch) {
            return;
          }
            /// 非活跃态，不开启自动轮播
          if (!_isActive) {
            return;
          }

          // false 说明没有手动滑动过，触发自动滚动
          if (!_jumpAutoScroll) {
            autoMoveToNextIndex();
          } else {
            _jumpAutoScroll = false;
          }
        });
      });
    }
  }

  void autoMoveToNextIndex() {
    if (!mounted) {
      return;
    }
    if (!widget.autoScroll) return;

    _innerPageIndex++;
    _innerPageIndex = _innerPageIndex % innerPageCount;
    Duration duration = widget?.animateDuration ?? kTabScrollDuration;
    debugLog("autoMoveToNextIndex $_innerPageIndex");
    if (_innerPageIndex == 0) {
      this._pageController.jumpToPage(_innerPageIndex + 1);
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        autoMoveToNextIndex();
        setState(() {});
      });
    } else {
      this._pageController.animateToPage(_innerPageIndex,
          duration: duration, curve: Curves.easeInOut);
    }
  }

  void _doChangePageIndex(int _innerPageIndex) {
    if (!mounted) {
      return;
    }
    this._innerPageIndex = _innerPageIndex;
    if (onPageChange != null) {
      onPageChange(_parseShowIndex(_innerPageIndex));
    }
  }

  void _handleScrollNotification(Notification notification) {
    if (notification is UserScrollNotification) {
      debugLog(
          '$Tag, #########1   ${notification.runtimeType}    $_isStartByUser');
      if (_isStartByUser) {
        return;
      }
      if (_isEndByUser) {
        _isEndByUser = false;
      } else {
        print('$Tag, #########   手动开始');
        _isStartByUser = true;
        _jumpAutoScroll = true;
      }
      _handleUserScroll(notification);
    } else if (notification is ScrollEndNotification) {
      debugLog(
          '$Tag, #########2   ${notification.runtimeType}    $_isStartByUser');
      if (_isEndByUser) {
        return;
      }
      if (_isStartByUser) {
        print('$Tag, #########   手动结束');
        _isEndByUser = true;
        _isStartByUser = false;
        // _handleUserScroll(notification);
      } else {
        _isEndByUser = false;
      }
    }
  }

  void _handleUserScroll(UserScrollNotification notification) {
    UserScrollNotification sn = notification;
    // print('$Tag, #########   _handleUserScroll');
    PageMetrics pm = sn.metrics;
    var page = pm.page;
    var depth = sn.depth;

    // pageView本身滑动到最左 或者 最右
    var leftOrRight = page == .0 ? .0 : page % (page.round());
    bool atEdge = (page - page.round()).abs() <= 0.1;
    debugLog(
        "page is $page atEdge $atEdge leftOrRight is $leftOrRight depth is $depth");
    // 边界去判断好处就是不会有闪动 ，但滑的快的话会有明显的无法滑动的问题
    if (depth == 0 && leftOrRight == 0 && atEdge) {
      debugLog("_handleUserScroll");
      _resetWhenAtEdge(pm);
    }
  }

  void _resetWhenAtEdge(PageMetrics pm) {
    if (!widget.cycleRolling) {
      return;
    }
    try {
      if (_innerPageIndex == 0) {
        this._pageController.jumpToPage(innerPageCount - 2);
      } else if (this._innerPageIndex == innerPageCount - 1) {
        this._pageController.jumpToPage(1);
      }
      setState(() {});
    } catch (e) {
      debugLog('$Tag, Exception: ${e?.toString()}');
    }
  }

  bool _isEndByUser = false;
  bool _isStartByUser = false;

  /// 暴露给业务方展示的index
  int _parseShowIndex(int pageIndex) {
    int showIndex;
    if (!cycleRolling) return pageIndex;

    if (pageIndex == 0) {
      showIndex = itemCount - 1;
    } else if (pageIndex == innerPageCount - 1) {
      showIndex = 0;
    } else {
      showIndex = pageIndex % innerPageCount - 1;
      showIndex = showIndex % itemCount;
    }
    // debugLog("$Tag showIndex , nowIndex is $pageIndex realIndex is $showIndex");
    return showIndex;
  }

  void debugLog(String msg) {
    assert(msg != null);
    bool debug = false;
    assert(debug = true);
    if (debug) print("$msg");
  }
}
