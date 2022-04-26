import 'dart:async';
import 'dart:developer';
import 'dart:isolate' as dvm;

import 'package:flutter_just_test/util/log_util.dart';
import 'package:vm_service/utils.dart';
import 'package:vm_service/vm_service.dart';
import 'package:vm_service/vm_service_io.dart';

class VMServiceTest {
  // 单例
  static VMServiceTest _instance;

  factory VMServiceTest() => _getInstance();

  static VMServiceTest get instance => _getInstance();

  static VMServiceTest _getInstance() {
    _instance ??= VMServiceTest._internal();
    return _instance;
  }

  // 当前运行的isolateId
  String _isolateId;

  // 获取当前isolate的Id
  String get isolateId {
    if (_isolateId != null) {
      return _isolateId;
    }
    _isolateId = Service.getIsolateID(dvm.Isolate.current);
    return _isolateId;
  }

  // 存储vm信息
  String vmInfo = '';

  // 临时字段，统计已用内存
  String memoryUsed = '';

  // 当前vm内存快照
  AllocationProfile snapshotAllocation;

  // 标记vm连接状态
  bool _initSuccess = false;

  //vm 服务协议信息
  ServiceProtocolInfo _serviceInfo;

  // 服务协议url
  Uri _serviceUri;

  // socket链接url
  Uri _socketUri;

  // 当前vm服务
  VmService _vmService;

  // 当前进程内的Isolate
  List<IsolateRef> _userIsolates;

  VMServiceTest._internal();

  /// 初始化服务
  Future<bool> initService() async {
    if (_initSuccess == true) {
      FlutterTestLog.e("请勿重复初始化");
      return true;
    }
    _serviceInfo = await Service.getInfo();
    _serviceUri = _serviceInfo.serverUri;
    if (_serviceUri == null) {
      FlutterTestLog.e("服务协议地址为空");
      return false;
    }
    _socketUri = convertToWebSocketUrl(serviceProtocolUrl: _serviceUri);
    _vmService = await vmServiceConnectUri(_socketUri.toString());

    _vmService.onIsolateEvent.listen((e) => print('onIsolateEvent: ${e}'));
    _vmService.onDebugEvent.listen((e) => print('onDebugEvent: ${e}'));
    _vmService.onGCEvent.listen((e) => print('onGCEvent: ${e}'));
    _vmService.onStdoutEvent.listen((e) => print('onStdoutEvent: ${e}'));
    _vmService.onStderrEvent.listen((e) => print('onStderrEvent: ${e}'));

    _initSuccess = true;
    return true;
  }

  /// 获取当前vm内所有的Isolate
  Future<bool> updateIsolates() async {
    var _vm = await _vmService.getVM();
    if (_vm == null) {
      FlutterTestLog.e("无法获取到虚拟机信息");
      return false;
    }
    var buffer = StringBuffer();
    var version = _vm.version;
    if (version != null) {
      version = version.substring(0, version.indexOf(')') + 1);
    }
    buffer.writeln('version-------------------$version');
    buffer.writeln('archBits------------------${_vm.architectureBits}');
    buffer.write('system-------------------${_vm.operatingSystem}');
    vmInfo = buffer.toString();
    FlutterTestLog.i("updateIsolates-info-$vmInfo");
    _userIsolates = _vm.isolates;
    if (_userIsolates == null || _userIsolates.isEmpty) {
      return false;
    }
    return true;
  }

  /// 已用内存
  /// externalUsage，是 Dart 管理的非 Dart 内存量，VM或者引擎的内存
  /// heapCapacity，系统看dart堆栈的内存，实际使用比这个小，像是申请的内存
  /// heapUsage，dart堆栈实际使用的内存
  String _memoryUsed(MemoryUsage usage) {
    memoryUsed = '';
    if (usage == null) {
      return memoryUsed;
    }
    var buffer = StringBuffer();
    buffer.writeln('dart关联的引擎内存------${byteToString(usage.externalUsage)}');
    buffer.writeln('dart占用内存-----------${byteToString(usage.heapCapacity)}');
    buffer.write('dart使用内存-----------${byteToString(usage.heapUsage)}');
    memoryUsed = buffer.toString();
    FlutterTestLog.i("内存快照: $memoryUsed");
    return memoryUsed;
  }

  /// 获取内存分配快照
  Future<AllocationProfile> takeSnapshot() async {
    snapshotAllocation = null;
    snapshotAllocation =
        await _vmService.getAllocationProfile(isolateId, gc: true);
    _memoryUsed(snapshotAllocation?.memoryUsage);
    return snapshotAllocation;
  }

  /// 返回dart class 的描述信息
  Future<Class> getClassInfo(String classId) async {
    return await _vmService.getObject(isolateId, classId) as Class;
  }

  ///返回最基础的类描述信息
  Future<Obj> getObjectInfo(String objectId) async {
    try {
      return await _vmService.getObject(isolateId, objectId);
    } catch (e, s) {
      return Future.value(null);
    }
  }

  ///统计某个class在vm中的所有实例
  Future<InstanceSet> getClassInstances(String classId, int pageSize) async {
    return await _vmService.getInstances(isolateId, classId, pageSize);
  }

  Future testScriptParse() async {
    assert(_userIsolates != null);
    IsolateRef isolateRef = _userIsolates?.first;
    final isolateId = isolateRef.id;
    final Isolate isolate = await _vmService.getIsolate(isolateId);
    final Library rootLibrary =
        await _vmService.getObject(isolateId, isolate.rootLib.id) as Library;
    final ScriptRef scriptRef = rootLibrary.scripts.first;

    final Script script =
        await _vmService.getObject(isolateId, scriptRef.id) as Script;
    print(script);
    print(script.uri);
    print(script.library);
    print(script.source.length);
    print(script.tokenPosTable.length);
  }

  Future testSourceReport() async {
    assert(_userIsolates != null);
    IsolateRef isolateRef = _userIsolates?.first;
    final isolateId = isolateRef.id;
    final Isolate isolate = await _vmService.getIsolate(isolateId);
    final Library rootLibrary =
        await _vmService.getObject(isolateId, isolate.rootLib.id) as Library;
    final ScriptRef scriptRef = rootLibrary.scripts.first;

    // make sure some code has run
    await _vmService.resume(isolateId);
    await Future.delayed(const Duration(milliseconds: 25));

    final SourceReport sourceReport = await _vmService.getSourceReport(
        isolateId, [SourceReportKind.kCoverage],
        scriptId: scriptRef.id);
    for (SourceReportRange range in sourceReport.ranges) {
      print('  $range');
      if (range.coverage = null) {
        print('  ${range.coverage}');
      }
    }
    print(sourceReport);
  }

  Future testServiceRegistration() async {
    const String serviceName = 'serviceName';
    const String serviceAlias = 'serviceAlias';
    const String movedValue = 'movedValue';
    _vmService.registerServiceCallback(serviceName,
        (Map<String, dynamic> params) async {
      assert(params['input'] == movedValue);
      return <String, dynamic>{
        'result': {'output': params['input']}
      };
    });
    await _vmService.registerService(serviceName, serviceAlias);
    VmService otherClient = await vmServiceConnectUri(_socketUri.toString());
    Completer completer = Completer();
    otherClient.onEvent('Service').listen((e) async {
      if (e.service == serviceName && e.kind == EventKind.kServiceRegistered) {
        assert(e.alias == serviceAlias);
        Response response = await _vmService.callMethod(
          e.method,
          args: <String, dynamic>{'input': movedValue},
        );
        assert(response.json['output'] == movedValue);
        completer.complete();
      }
    });
    await otherClient.streamListen('Service');
    await completer.future;
    await otherClient.dispose();
  }

  static String byteToString(int size) {
    const g = 1024 * 1024 * 1024;
    const m = 1024 * 1024;
    const k = 1024;
    var resultSize = '';
    if (size / g >= 1) {
      resultSize = '${(size / g).toStringAsFixed(2)}G';
    } else if (size / m >= 1) {
      var value = size / m;
      if (value >= 100) {
        resultSize = '${value.toStringAsFixed(0)}M';
      } else {
        resultSize = '${value.toStringAsFixed(1)}M';
      }
    } else if (size / k >= 1) {
      var value = size / k;
      if (value >= 100) {
        resultSize = '${value.toStringAsFixed(0)}K';
      } else {
        resultSize = '${value.toStringAsFixed(1)}K';
      }
    } else {
      resultSize = '${size}B';
    }
    return resultSize;
  }
}
