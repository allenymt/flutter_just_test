import 'package:flutter/material.dart';
import 'package:vm_service/vm_service.dart';

import 'test_vm_service.dart';

/// do what
/// @author yulun
/// @since 2022-04-24 10:44

class VmServicePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _VmServicePageState();
  }
}

class _VmServicePageState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test state"),
      ),
      body: ListView(children: <Widget>[
        ListTile(
          title: Text('初始化链接虚拟机'),
          onTap: () async {
            await VMServiceTest.instance.initService();
            await VMServiceTest.instance.updateIsolates();
          },
        ),
        ListTile(
          title: Text('获取内存快照'),
          onTap: () async {
            await VMServiceTest.instance.takeSnapshot();
          },
        ),
        ListTile(
          title: Text('测试isolate脚本解析'),
          onTap: () async {
            await VMServiceTest.instance.testScriptParse();
          },
        ),
        ListTile(
          title: Text('测试资源上报解析'),
          onTap: () async {
            await VMServiceTest.instance.testSourceReport();
          },
        ),
      ]),
    );
  }

  void tryFindClass(AllocationProfile allocationProfile){

  }
}
