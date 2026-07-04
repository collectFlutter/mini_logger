import 'mini_logger_model.dart';

// import 'dart:io';
import 'package:flutter/foundation.dart';

/// 日志上传事件
/// [value] 等待上传的日志！
/// [value] 反馈是否处理成功！
typedef UpLogEvent = Future<bool> Function(MiniLoggerModel value);

/// 日志配置
class MiniLoggerConfig {
  /// 是否打印日志
  bool? _withPrint;

  bool? get withPrint => _withPrint;

  /// 最小打印日志等级
  MiniLoggerLevelEnum? _minPrintLevel;

  MiniLoggerLevelEnum? get minPrintLevel => _minPrintLevel;

  /// 是否保存到数据库
  bool? _withSQLite;

  bool? get withSQLite => _withSQLite;

  /// 最小保存日志等级
  MiniLoggerLevelEnum? _minSQLiteLevel;

  MiniLoggerLevelEnum? get minSQLiteLevel => _minSQLiteLevel;

  /// 最小上传日志等级
  MiniLoggerLevelEnum? _minUpLevel;

  MiniLoggerLevelEnum? get minUpLevel => _minUpLevel;

  /// 日志上传事件，不设置时不上传，将在每次打印时，结合[minUpLevel]判断是否上传
  UpLogEvent? upLogEvent;

  /// 日志标签
  String? _tag;

  String? get tag => _tag;
  bool? _withPrintColor;

  bool? get withPrintColor => _withPrintColor;

  /// 初始化配置
  /// - [minPrintLevel] - 最小打印等级，默认 [MiniLoggerLevelEnum.d]
  /// - [minSQLiteLevel] - 最小保存日志等级，默认 [MiniLoggerLevelEnum.i]
  /// - [minUpLevel] - 最小上传等级，默认 [MiniLoggerLevelEnum.w]
  MiniLoggerConfig({
    bool withPrint = true,
    MiniLoggerLevelEnum? minPrintLevel,
    bool withSQLite = false,
    MiniLoggerLevelEnum? minSQLiteLevel,
    MiniLoggerLevelEnum? minUpLevel,
    bool withPrintColor = false,
    String tag = "mini_log",
    this.upLogEvent,
  })  : _withPrint = withPrint,
        _withSQLite = ([
              TargetPlatform.android,
              TargetPlatform.iOS,
              TargetPlatform.macOS
            ].contains(defaultTargetPlatform)) &&
            withSQLite,
        _withPrintColor =
            (defaultTargetPlatform != TargetPlatform.iOS) && withPrintColor,
        _minPrintLevel = minPrintLevel ?? MiniLoggerLevelEnum.d,
        _minSQLiteLevel = minSQLiteLevel ?? MiniLoggerLevelEnum.i,
        _minUpLevel = minUpLevel ?? MiniLoggerLevelEnum.w,
        _tag = tag;
}
