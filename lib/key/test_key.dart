import 'dart:math';

import 'package:flutter/material.dart';

/// do what
/// @author yulun
/// @since 2020-06-17 16:28
/// https://juejin.cn/post/6845166891573444616#heading-4 讲的不错
class TestKeyWidget extends StatefulWidget {
  @override
  _KeyDemo1PageState createState() => _KeyDemo1PageState();
}

class _KeyDemo1PageState extends State<TestKeyWidget> {
  List<Widget> tiles = [
    StatefulColorfulTile(key:ValueKey("1"),name: "1"),
    StatefulColorfulTile(key:ValueKey("2"),name: "2"),

    // StatefulColorfulTile(name: "1"),
    // StatefulColorfulTile(name: "2"),
  ];

  UniqueKey key = UniqueKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text("Key demo"),
      ),
      body: Column(
        children: tiles,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.delete),
        onPressed: () {
          setState(() {
            tiles.insert(1, tiles.removeAt(0));
          });
        },
      ),
    );
  }
}

class StatefulColorfulTile extends StatefulWidget {
  // 如果把属性值放到widget里，那每次setState就会发生改变
  // Color myColor = Color.fromARGB(
  //     255, Random().nextInt(256), Random().nextInt(256), Random().nextInt(256));
  @override
  _StatefulColorfulTileState createState() => _StatefulColorfulTileState();
  String? name;

  StatefulColorfulTile({Key? key, this.name}): super(key: key);
}

class _StatefulColorfulTileState extends State<StatefulColorfulTile> {
  // 放到state里，不会发生改变的，因为每次setState只是改变state引用的widget，但是state没变过
  // 当然这种情况如果加了key，就会触发element的mount和unmount，那就能发生改变了
  Color myColor = Color.fromARGB(
      255, Random().nextInt(256), Random().nextInt(256), Random().nextInt(256));

  @override
  Widget build(BuildContext context) {
    // 为什么不加key的时候每次都触发。加了key反而不触发了？
    // 没加key之前，每次setState都会触发build，因为没有key，所以每次都会重新创建一个新的widget，然后setState的时候，会把新的widget和旧的widget进行比较，发现不一样，所以会触发build
    // 加了key之后，反而不会触发，因为element会优先从同等级的tree里去找相对应的widget，既然加了key，那么刚好找到对应的widget，所以不会触发build
    print("${widget.name} build , myColor is ${myColor} , key is ${widget.key}");
    return Container(
        color: myColor, child: Padding(padding: EdgeInsets.all(70.0)));

    // print("${widget.name} build , myColor is ${widget.myColor}");
    // return Container(
    //     color: widget.myColor, child: Padding(padding: EdgeInsets.all(70.0)));
  }

  @override
  void dispose() {
    print("${widget.name} dispose");
    super.dispose();
  }
}

class StatelessColorfulTile extends StatelessWidget {
  Color myColor = Color.fromARGB(
      255, Random().nextInt(256), Random().nextInt(256), Random().nextInt(256));

  @override
  Widget build(BuildContext context) {
    return Container(
        color: myColor, child: Padding(padding: EdgeInsets.all(70.0)));
  }
}
