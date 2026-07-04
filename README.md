# mini_logger

A lightweight Flutter logging package with support for color printing, local storage (SQLite), log querying, deletion, and upload events.

**Compatible with Dart 3 and Flutter 3.**

## Features

- Colorful log printing for different log levels
- Local storage powered by SQLite
- Log querying with filtering (level, time range, keyword)
- Log deletion support
- Configurable upload events for remote logging

## Getting Started

Add `mini_logger` to your `pubspec.yaml`:

```yaml
dependencies:
  mini_logger: ^3.41.9
```

## Usage

```dart
import 'package:mini_logger/mini_logger.dart';

// Initialize
L.init(MiniLoggerConfig(
  tag: 'my_app',
  withSQLite: true,
));

// Log at different levels
L.v('Verbose message');
L.d('Debug message');
L.i('Info message');
L.w('Warning message');
L.e('Error message');

// Query logs
List<MiniLoggerModel> logs = await L.queryLogs();

// Delete logs
int count = await L.deleteLog();
```
