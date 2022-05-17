import 'package:flutter/material.dart';

void main() {
  runApp(FadeAppTest());
}

class FadeAppTest extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Client().method();
    print(
        "test ddd is ${Uri.decodeQueryComponent(Uri.encodeComponent("%E6%88%91%E7%9A%84%20%E7%9A%84%E7%9A%84"))}");
    return MaterialApp(
      title: 'Fade Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyFadeTest(title: 'Fade Demo'),
    );
  }
}

abstract class Super {
  void method() {
    print("Super");
  }
}

class MySuper extends Super {
  void method() {
    super.method();
    print("MySuper");
  }
}

mixin Mixin on Super {
  void method() {
    super.method();
    print("Sub");
  }
}

class Client extends MySuper with Mixin {}

class InheritedTest extends InheritedWidget {
  const InheritedTest({
    Key? key,
    required this.testValue,
    required Widget child,
  })  : assert(testValue != null),
        assert(child != null),
        super(key: key, child: child);

  final int testValue;

  static InheritedTest? of(BuildContext context) {
    return context.findAncestorStateOfType() as InheritedTest?;
  }

  @override
  bool updateShouldNotify(InheritedTest oldWidget) {
    // TODO: implement updateShouldNotify
    return oldWidget.testValue != testValue;
  }
}

class MyFadeTest extends StatefulWidget {
  MyFadeTest({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MyFadeTest createState() => _MyFadeTest();
}

class _MyFadeTest extends State<MyFadeTest> with TickerProviderStateMixin {
  late AnimationController controller;
  late CurvedAnimation curve;
  int a=0;
  @override
  void initState() {
    super.initState();
    print("_MyFadeTest initState");
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    curve = CurvedAnimation(parent: controller, curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    print("_MyFadeTest build");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
          child: Container(
              child: FadeTransition(
                  opacity: curve,
                  child: FlutterLogo(
                    size: 100.0,
                  )))),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Fade',
        child: Text(a.toString()),
        onPressed: () {
          setState(() {
            a+=1;
          });
          controller.forward();
        },
      ),
    );
  }

  @override
  void deactivate() {
    super.deactivate();
    print("_MyFadeTest deactivate");
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    print("_MyFadeTest setState");
  }

  @override
  void reassemble() {
    super.reassemble();
    print("_MyFadeTest reassemble");
  }

  @override
  void didUpdateWidget(MyFadeTest oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("_MyFadeTest didUpdateWidget");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("_MyFadeTest didChangeDependencies");
  }

  @override
  void dispose() {
    super.dispose();
    print("_MyFadeTest dispose");
  }
}
