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
            children: children,
            controller: tabController,
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
