import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// do what
/// @author yulun
/// @since 2020-12-25 14:56
/// 异常的捕获和处理，
/// 特殊异常的识别和处理
class SlotExceptionManager {
  static SlotExceptionManager? _instance;

  static SlotExceptionManager? getInstance(
      {required Function buildErrorWidget, Set<String>? specialClassName}) {
    assert(buildErrorWidget != null, "buildErrorWidget can't be null");
    if (_instance == null) {
      _instance = SlotExceptionManager._();
    }
    _instance!.buildErrorWidget = buildErrorWidget as Widget Function()?;
    _instance!.specialClassSet = specialClassName ?? Set<String>();
    assert(() {
      _instance!._isFlutterDebug = true;
      return true;
    }());

    /// debug时候在重新覆盖一次
    assert(() {
      Future.delayed(Duration(seconds: 2), () {
        _instance!._setFlutterErrorBuilder();
      });
      return true;
    }());
    return _instance;
  }

  bool _isFlutterDebug = false;

  Widget Function()? buildErrorWidget;

  Set<String>? specialClassSet;

  late Function(Object error, StackTrace stack) onError;

  SlotExceptionManager._() {
    onError = (Object error, StackTrace stackTrace) {
      print("expectinTest app error ${Zone.current}");
      print(
          "expectinTest zone error stackTrace is ${stackTrace.toString()} \n\n zone  error is ${error.toString()} ");
      // FlutterError.dumpErrorToConsole(FlutterErrorDetails(
      //   exception: error,
      //   stack: stackTrace,
      // ));
    };
    _setFlutterErrorBuilder();
    _setErrorWidgetBuilder();
  }

  runZonedCatchError(Function body) async {
    /// 沙盒, 异步异常捕获
    runZonedGuarded<Future<void>>(
      () async {
        body.call();
      },
      onError,
    );
  }

  /// Flutter Framework 异常信息捕获
  void _setFlutterErrorBuilder() {
    final defaultOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      print(
          "expectinTest framework error ${details.exception} stacktrace is ${details.stack?.toString()}23123");

      // 如果不是dynamic异常，直接抛给默认的处理
      if (buildErrorWidget == null || !checkIfSpecialException(details)) {
        try {
          defaultOnError!(details);
        } catch (e, s) {
          FlutterError.dumpErrorToConsole(FlutterErrorDetails(
            exception: e,
            stack: s,
          ));
        }
        return;
      }

      // FlutterError.dumpErrorToConsole(details);

      if (details.library == 'widgets library' &&
          details.context is ErrorDescription) {
        ErrorDescription description = details.context as ErrorDescription;
        bool isDescNotEmpty = description.value?.isNotEmpty ?? false;
        if (isDescNotEmpty == true && description.value[0] is String) {
          String descString = description.value[0] as String;

          if (descString == 'attaching to the render tree') {
            /// `flutter/lib/src/widgets/binding.dart#1146`
            /// 该错误表示之后会回调[ErrorWidget.builder]，这里不统计
            return;
          } else if (descString?.startsWith('building') ?? false) {
            /// `flutter/lib/src/widgets/framework.dart#4491`
            /// `flutter/lib/src/widgets/layout_builder.dart#95`
            /// `flutter/lib/src/widgets/sliver.dart#1621`
            /// 该错误表示之后会回调[ErrorWidget.builder]，这里不统计
            return;
          }
        }
      }
    };
  }

  /// 页面构建异常信息捕获
  Future<void> _setErrorWidgetBuilder() async {
    print("expectinTest init errorBuild");
    var defaultErrorBuilder = ErrorWidget.builder;
    ErrorWidget.builder = (FlutterErrorDetails details) {
      print(
          "expectinTest ErrorWidget stacktrace is ${details?.stack?.toString()} fsdfff");

      if (buildErrorWidget == null) {
        return defaultErrorBuilder(details);
      }

      // 如果不是dynamic异常，直接抛给默认的处理
      if (!checkIfSpecialException(details)) {
        print("expectinTest normal build error");
        return defaultErrorBuilder(details);
      }

      print("expectinTest special build error");

      Widget errorBuilder;

      errorBuilder = buildErrorWidget!();
      return errorBuilder;
    };
  }

  bool checkIfSpecialException(FlutterErrorDetails details) {
    if (specialClassSet == null || specialClassSet!.isEmpty) return false;
    if (details == null || details.context == null) {
      return false;
    }
    bool isSpecialError = false;
    specialClassSet!.forEach((element) {
      if (details?.context?.toString()?.contains(element) ?? false) {
        isSpecialError = true;
      }
    });

    return isSpecialError;
  }
}
