import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

/// do what
/// @author yulun
/// @since 2020-07-01 09:55

class DebugLogTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("debug_test"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("stderr"),
            onTap: () {
              // Android暂且不知道怎么玩
              stderr.writeln('stderr print me');
            },
          ),
          ListTile(
            title: Text("stdout"),
            onTap: () {
              // Android暂且不知道怎么玩
              stdout.writeln("stdout print me");
            },
          ),
          ListTile(
            title: Text("developer log"),
            onTap: () {
              developer.log('log me',
                  name: 'developer log', error: jsonEncode("123455"));
            },
          ),
          ListTile(
            title: Text("debug breakpoint"),
            onTap: () {
              // 设置断点好用，但后面的message没发现有什么用
              developer.debugger(when: true, message: "yeah , break it ");
              print("debug breakpoint");
            },
          ),
          ListTile(
            title: Text("dump widget tree"),
            onTap: () {
              //dump 当前widget树 ，信息太庞大，没什么用
              debugDumpApp();
            },
          ),
          ListTile(
            title: Text("dump render tree"),
            onTap: () {
              //dump rendertree树，layout issue可以查看
              //信息很多，建议可以打到文件里查看，在logcat里看不了
              SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
                debugDumpRenderTree();
              });
            },
          ),
          ListTile(
            title: Text("layer tree"),
            onTap: () {
              // 官方文档的描述 如果是查看混合的bug,就用这个，layer tree是什么？
              // 信息不多，但layer tre是什么 ，不是很理解。
              debugDumpLayerTree();
            },
          ),
          ListTile(
            title: Text("Semantics tree"),
            onTap: () {
              // 无障碍 api accessibility
              debugDumpSemanticsTree(DebugSemanticsDumpOrder.traversalOrder);
            },
          ),
          ListTile(
            title: Text("Scheduling frame"),
            onTap: () {
              debugPrintBeginFrameBanner = true;
              debugPrintEndFrameBanner = true;
              //猜测的理解
              //Frame 当前第几帧，          时间，间隔差不多刚好是16ms,17ms左右
              //意义不大，只能参考意义，无法做为核心数据分析
//                    ▄▄▄▄▄▄▄▄ Frame 337         6m 11s 353.398ms ▄▄▄▄▄▄▄▄
//                    ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
//                    ▄▄▄▄▄▄▄▄ Frame 338         6m 11s 370.347ms ▄▄▄▄▄▄▄▄
//              .394  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
//              .407  ▄▄▄▄▄▄▄▄ Frame 339         6m 11s 387.296ms ▄▄▄▄▄▄▄▄
//              .411  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
//              .423  ▄▄▄▄▄▄▄▄ Frame 340         6m 11s 404.247ms ▄▄▄▄▄▄▄▄
//              .426  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
//              .438  ▄▄▄▄▄▄▄▄ Frame 341         6m 11s 419.487ms ▄▄▄▄▄▄▄▄
//              .442  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
//              .457  ▄▄▄▄▄▄▄▄ Frame 342         6m 11s 436.103ms ▄▄▄▄▄▄▄▄
//              .460  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
//              .474  ▄▄▄▄▄▄▄▄ Frame 343         6m 11s 452.777ms ▄▄▄▄▄▄▄▄
//              .477  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
//              .490  ▄▄▄▄▄▄▄▄ Frame 344         6m 11s 469.389ms ▄▄▄▄▄▄▄▄
//              .493  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
//              .505  ▄▄▄▄▄▄▄▄ Frame 345         6m 11s 486.003ms ▄▄▄▄▄▄▄▄
//              .509  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
//              .522  ▄▄▄▄▄▄▄▄ Frame 346         6m 11s 502.619ms ▄▄▄▄▄▄▄▄
//              .526  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
//              .539  ▄▄▄▄▄▄▄▄ Frame 347         6m 11s 519.234ms ▄▄▄▄▄▄▄▄
//              .544  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
//              .556  ▄▄▄▄▄▄▄▄ Frame 348         6m 11s 535.612ms ▄▄▄▄▄▄▄▄
//              .564  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
//              .572  ▄▄▄▄▄▄▄▄ Frame 349         6m 11s 552.241ms ▄▄▄▄▄▄▄▄
            },
          ),
          ListTile(
            title: Text("Tracing Dart code performance"),
            onTap: () {
              // sure run in profile modle
              // devtools TimeLine view look result
              // 下面几步没成功
              //Then open your app’s Observatory’s timeline page, check the ‘Dart’ recording option and perform the function you want to measure.
              //
              //Refreshing the page displays the chronological timeline records of your app in Chrome’s tracing tool.
              //
              //Be sure to run your app in profile mode to ensure that the runtime performance characteristics closely match that of your final product.
              Timeline.startSync('interesting function');
              // iWonderHowLongThisTakes();
              int a = 1 * 2 * 3 * 485 * 123123;
              Timeline.finishSync();
            },
          ),
        ],
      ),
    );
  }
}
