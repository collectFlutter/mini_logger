import 'package:ansicolor/ansicolor.dart';

import 'mini_logger_db_manage.dart';
import 'mini_logger_model.dart';

import 'mini_logger_config.dart';
import 'package:flutter/foundation.dart';

class L {
  /// 日志配置
  static MiniLoggerConfig _config = MiniLoggerConfig();

  /// 初始化日志
  static void init([MiniLoggerConfig? config]) {
    ansiColorDisabled = !(config?.withPrintColor ?? false);
    L._config = config ?? _config;
  }

  /// Verbose就是冗长啰嗦的。通常表达开发调试过程中的一些详细信息。
  static void v(Object object, {String? tag, bool? withSQLite, bool? withUp}) {
    if (MiniLoggerLevelEnum.v >= _config.minPrintLevel) {
      _handleLog(MiniLoggerLevelEnum.v, object,
          tag: tag, withSQLite: withSQLite, withUp: withUp);
    }
  }

  /// Info来表达一些信息。
  static void i(Object object, {String? tag, bool? withSQLite, bool? withUp}) {
    if (MiniLoggerLevelEnum.i >= _config.minPrintLevel) {
      _handleLog(MiniLoggerLevelEnum.i, object,
          tag: tag, withSQLite: withSQLite, withUp: withUp);
    }
  }

  ///蓝色，Debug来表达调试信息。
  static void d(Object object, {String? tag, bool? withSQLite, bool? withUp}) {
    if (MiniLoggerLevelEnum.d >= _config.minPrintLevel) {
      _handleLog(MiniLoggerLevelEnum.d, object,
          tag: tag, withSQLite: withSQLite, withUp: withUp);
    }
  }

  /// Warn表示警告，但不一定会马上出现错误，开发时有时用来表示特别注意的地方。
  static void w(Object object, {String? tag, bool? withSQLite, bool? withUp}) {
    if (MiniLoggerLevelEnum.w >= _config.minPrintLevel) {
      _handleLog(MiniLoggerLevelEnum.w, object,
          tag: tag, withSQLite: withSQLite, withUp: withUp);
    }
  }

  ///Error 出现错误，是最需要关注解决的。
  static void e(Object object, {String? tag, bool? withSQLite, bool? withUp}) {
    if (MiniLoggerLevelEnum.e >= _config.minPrintLevel) {
      _handleLog(MiniLoggerLevelEnum.e, object,
          tag: tag, withSQLite: withSQLite, withUp: withUp);
    }
  }

  static Future<List<MiniLoggerModel>> queryLogs(
      [QueryLogParameter? parameter]) async {
    if (_config.withSQLite ?? false) {
      return await MiniLoggerDBManage.internal()
          .query(parameter ?? QueryLogParameter());
    }
    return [];
  }

  static Future<int> deleteLog([QueryLogParameter? parameter]) async {
    return await MiniLoggerDBManage.internal()
        .delete(parameter ?? QueryLogParameter());
  }

  static void _handleLog(
    MiniLoggerLevelEnum level,
    Object object, {
    String? tag,
    bool? withSQLite,
    bool? withUp,
  }) {
    tag = tag ?? _config.tag ?? 'mini_log';
    bool enablePrint =
        (_config.withPrint ?? false) && level >= _config.minPrintLevel;
    withUp =
        _config.upLogEvent != null && (withUp ?? level >= _config.minUpLevel);
    withSQLite = (!kIsWeb) &&
        (withSQLite ??
            ((_config.withSQLite ?? false) && level >= _config.minSQLiteLevel));

    String content = object.toString();
    DateTime now = DateTime.now();
    MiniLoggerModel log = MiniLoggerModel(level, tag, content, now, 0);

    if (withUp) {
      _config.upLogEvent!(log).then((value) {
        log.status = value ? 1 : 0;
        if (withSQLite!) {
          MiniLoggerDBManage.internal().insert(log);
        }
      });
    } else {
      if (withSQLite) {
        MiniLoggerDBManage.internal().insert(log);
      }
    }

    if (enablePrint) {
      int index = 1;
      AnsiPen pen = AnsiPen()
        ..rgb(
            r: level.color.r / 255.0,
            g: level.color.g / 255.0,
            b: level.color.b / 255);
      while (content.isNotEmpty) {
        if (content.length > 1024) {
          print(pen(
              "[$tag][${level.level}][${index++}]: ${content.substring(0, 512)}"));
          content = content.substring(512);
        } else {
          print(pen("[$tag][${level.level}][${index++}]: $content"));
          content = '';
        }
      }
    }
  }
}
