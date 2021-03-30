import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// do what
/// @author yulun
/// @since 2021-03-22 10:31

class TabViewLagDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TabViewLagDemoState();
  }
}

class TabViewLagDemoState extends State<TabViewLagDemo>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  PageController pageController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    tabController?.dispose();
    pageController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    children.add(_buildPageChild(1));
    children.add(Container(
      color: Colors.yellow,
    ));
    children.add(_buildPageChild(3));
    return Scaffold(
        appBar: AppBar(
          title: Text("tabBarView 嵌套滑动优化"),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 50,
              child: TabBar(
                controller: tabController,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: Color(0xff333333),
                labelStyle:
                    new TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                unselectedLabelColor: Color(0xff999999),
                unselectedLabelStyle:
                    new TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                tabs: [
                  Text("1"),
                  Text("2"),
                  Text("3"),
                ],
              ),
            ),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                child: TestTabBarView(
                  children: children,
                  controller: tabController,
                  onCreatePageController: () {
                    return pageController;
                  },
                ),
                onNotification: (nofi) {
                  if (nofi is ScrollStartNotification) {
                    pageController?.position?.context?.setIgnorePointer(false);
                  }
                  return false;
                },
              ),
            ),
          ],
        ));
  }

  Widget _buildPageChild(int index) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            height: 50,
            color: Colors.black38,
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 20,
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 150,
            child: ListView.separated(
                separatorBuilder: (context, index) {
                  return SizedBox(
                    width: 30,
                  );
                },
                itemBuilder: (context, index) {
                  return Container(
                      height: 150,
                      width: 150,
                      color: Color.fromARGB(
                        255,
                        (150 * (index + 1)) % 255,
                        (100 * (index + 1)) % 255,
                        (80 * (index + 1)) % 255,
                      ));
                },
                itemCount: 10,
                scrollDirection: Axis.horizontal),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 20,
          ),
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
            child: Container(
                height: 20,
                color: Color.fromARGB(
                  255,
                  (150 * (index + 1)) % 255,
                  (100 * (index + 1)) % 255,
                  (60 * (index + 1)) % 255,
                )),
          );
        }, childCount: 50)),
      ],
    );
  }
}

class TapTestGestureRecognizer extends TapGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}

class TestTabBarView extends StatefulWidget {
  /// Creates a page view with one child per tab.
  ///
  /// The length of [children] must be the same as the [controller]'s length.
  const TestTabBarView({
    Key key,
    @required this.children,
    this.controller,
    this.physics,
    this.dragStartBehavior = DragStartBehavior.start,
    this.onCreatePageController,
  })  : assert(children != null),
        assert(dragStartBehavior != null),
        super(key: key);

  /// This widget's selection and animation state.
  ///
  /// If [TabController] is not provided, then the value of [DefaultTabController.of]
  /// will be used.
  final TabController controller;

  /// One widget per tab.
  ///
  /// Its length must match the length of the [TabBar.tabs]
  /// list, as well as the [controller]'s [TabController.length].
  final List<Widget> children;

  /// How the page view should respond to user input.
  ///
  /// For example, determines how the page view continues to animate after the
  /// user stops dragging the page view.
  ///
  /// The physics are modified to snap to page boundaries using
  /// [PageScrollPhysics] prior to being used.
  ///
  /// Defaults to matching platform conventions.
  final ScrollPhysics physics;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  final PageController Function() onCreatePageController;

  @override
  _TestTabBarViewState createState() => _TestTabBarViewState();
}

class _TestTabBarViewState extends State<TestTabBarView> {
  TabController _controller;
  PageController _pageController;
  List<Widget> _children;
  List<Widget> _childrenWithKey;
  int _currentIndex;
  int _warpUnderwayCount = 0;

  // If the TabBarView is rebuilt with a new tab controller, the caller should
  // dispose the old one. In that case the old controller's animation will be
  // null and should not be accessed.
  bool get _controllerIsValid => _controller?.animation != null;

  void _updateTabController() {
    final TabController newController =
        widget.controller ?? DefaultTabController.of(context);
    assert(() {
      if (newController == null) {
        throw FlutterError('No TabController for ${widget.runtimeType}.\n'
            'When creating a ${widget.runtimeType}, you must either provide an explicit '
            'TabController using the "controller" property, or you must ensure that there '
            'is a DefaultTabController above the ${widget.runtimeType}.\n'
            'In this case, there was neither an explicit controller nor a default controller.');
      }
      return true;
    }());

    if (newController == _controller) return;

    if (_controllerIsValid)
      _controller.animation.removeListener(_handleTabControllerAnimationTick);
    _controller = newController;
    if (_controller != null)
      _controller.animation.addListener(_handleTabControllerAnimationTick);
  }

  @override
  void initState() {
    super.initState();
    _updateChildren();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateTabController();
    _currentIndex = _controller?.index;
    _pageController = widget.onCreatePageController() ??
        PageController(initialPage: _currentIndex ?? 0);
  }

  @override
  void didUpdateWidget(TestTabBarView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) _updateTabController();
    if (widget.children != oldWidget.children && _warpUnderwayCount == 0)
      _updateChildren();
  }

  @override
  void dispose() {
    if (_controllerIsValid)
      _controller.animation.removeListener(_handleTabControllerAnimationTick);
    _controller = null;
    // We don't own the _controller Animation, so it's not disposed here.
    super.dispose();
  }

  void _updateChildren() {
    _children = widget.children;
    _childrenWithKey = KeyedSubtree.ensureUniqueKeysForList(widget.children);
  }

  void _handleTabControllerAnimationTick() {
    if (_warpUnderwayCount > 0 || !_controller.indexIsChanging)
      return; // This widget is driving the controller's animation.

    if (_controller.index != _currentIndex) {
      _currentIndex = _controller.index;
      _warpToCurrentIndex();
    }
  }

  Future<void> _warpToCurrentIndex() async {
    if (!mounted) return Future<void>.value();

    if (_pageController.page == _currentIndex.toDouble())
      return Future<void>.value();

    final int previousIndex = _controller.previousIndex;
    if ((_currentIndex - previousIndex).abs() == 1) {
      _warpUnderwayCount += 1;
      await _pageController.animateToPage(_currentIndex,
          duration: kTabScrollDuration, curve: Curves.ease);
      _warpUnderwayCount -= 1;
      return Future<void>.value();
    }

    assert((_currentIndex - previousIndex).abs() > 1);
    final int initialPage =
        _currentIndex > previousIndex ? _currentIndex - 1 : _currentIndex + 1;
    final List<Widget> originalChildren = _childrenWithKey;
    setState(() {
      _warpUnderwayCount += 1;

      _childrenWithKey = List<Widget>.from(_childrenWithKey, growable: false);
      final Widget temp = _childrenWithKey[initialPage];
      _childrenWithKey[initialPage] = _childrenWithKey[previousIndex];
      _childrenWithKey[previousIndex] = temp;
    });
    _pageController.jumpToPage(initialPage);

    await _pageController.animateToPage(_currentIndex,
        duration: kTabScrollDuration, curve: Curves.ease);
    if (!mounted) return Future<void>.value();
    setState(() {
      _warpUnderwayCount -= 1;
      if (widget.children != _children) {
        _updateChildren();
      } else {
        _childrenWithKey = originalChildren;
      }
    });
  }

  // Called when the PageView scrolls
  bool _handleScrollNotification(ScrollNotification notification) {
    if (_warpUnderwayCount > 0) return false;

    if (notification.depth != 0) return false;

    _warpUnderwayCount += 1;
    if (notification is ScrollUpdateNotification &&
        !_controller.indexIsChanging) {
      if ((_pageController.page - _controller.index).abs() > 1.0) {
        _controller.index = _pageController.page.floor();
        _currentIndex = _controller.index;
      }
      _controller.offset =
          (_pageController.page - _controller.index).clamp(-1.0, 1.0) as double;
    } else if (notification is ScrollEndNotification) {
      _controller.index = _pageController.page.round();
      _currentIndex = _controller.index;
      if (!_controller.indexIsChanging)
        _controller.offset = (_pageController.page - _controller.index)
            .clamp(-1.0, 1.0) as double;
    }
    _warpUnderwayCount -= 1;

    return false;
  }

  @override
  Widget build(BuildContext context) {
    assert(() {
      if (_controller.length != widget.children.length) {
        throw FlutterError(
            "Controller's length property (${_controller.length}) does not match the "
            "number of tabs (${widget.children.length}) present in TabBar's tabs property.");
      }
      return true;
    }());
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: PageView(
        dragStartBehavior: widget.dragStartBehavior,
        controller: _pageController,
        physics: widget.physics == null
            ? const PageScrollPhysics().applyTo(const ClampingScrollPhysics())
            : const PageScrollPhysics().applyTo(widget.physics),
        children: _childrenWithKey,
      ),
    );
  }
}
