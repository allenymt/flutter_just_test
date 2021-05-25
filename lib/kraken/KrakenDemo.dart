import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:kraken/kraken.dart';

/// do what
/// @author yulun
/// @since 2021-04-21 15:48

class KrakenDemo extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Kraken
    //     kraken; //= Kraken(bundleURL: 'https://raw.githubusercontent.com/openkraken/kraken/master/kraken/example/assets/bundle.js');
    // kraken = buildHellowWorld();
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // home: kraken
        home: Container()
    );
  }

  // Kraken buildHellowWorld() {
  //   return Kraken(bundlePath: "assets/kraken/bundle.txt");
  // }
  //
  // Kraken buildList() {
  //   return Kraken(
  //       bundleURL:
  //           "https://kraken.oss-cn-hangzhou.aliyuncs.com/demo/guide-high-performance-list.js");
  // }
}
