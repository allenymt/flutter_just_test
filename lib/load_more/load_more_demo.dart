import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// do what
/// @author yulun
/// @since 2021-04-06 11:49

class TabViewLoadMoreDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TabViewLagDemoState();
  }
}

class TabViewLagDemoState extends State<TabViewLoadMoreDemo>
    with SingleTickerProviderStateMixin {


  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController?.dispose();
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
          title: Text("tabBarView load more"),
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
              child: TabBarView(
                controller: tabController,
                children: children,
              ),
            ),
          ],
        ));
  }

  Widget _buildPageChild(int index) {
    Widget scrollChild = CustomScrollView(
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
          return _buildItem(index);
        }, childCount: dataList)),
        SliverToBoxAdapter(
          child: _buildLoadMore(),
        ),
      ],
    );

    // load more listener
    scrollChild = NotificationListener<ScrollNotification>(
      onNotification: (position) {
        if (position.metrics.pixels >= position.metrics.maxScrollExtent &&
            !_lastPage() &&
            !isLoadingMore) {
          isLoadingMore = true;
          SchedulerBinding.instance!.addPostFrameCallback((_) {
            _addItems();
          });
        }
        return false;
      },
      child: scrollChild,
    );
    return scrollChild;
  }

  int pageIndex = 0;
  int dataList = 20;
  bool isLoadingMore = false;

  Widget _buildItem(int index) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
      child: Container(
          height: 20,
          child: Text("$index"),
          color: Color.fromARGB(
            255,
            (150 * (index + 1)) % 255,
            (100 * (index + 1)) % 255,
            (60 * (index + 1)) % 255,
          )),
    );
  }

  Widget _buildLoadMore() {
    if (!_lastPage()) {
      return SizedBox(
        height: 50,
        child: Container(
          child: CupertinoActivityIndicator(),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: Center(
        child: Text(
          '没有更多了',
          style: TextStyle(color: Color(0xFFC0C0C0), fontSize: 14),
        ),
      ),
    );
  }

  void _addItems() {
    Future.delayed(Duration(milliseconds: 2 * 1000), () {
      dataList += 20;
      pageIndex++;
    }).then(((value) => setState(() {
          isLoadingMore = false;
        })));
  }

  bool _lastPage() {
    return pageIndex >= 2;
  }
}
