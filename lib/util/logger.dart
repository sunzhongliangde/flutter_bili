import 'package:logging/logging.dart';

class Log {
  static final log = Logger('Bili');
  static warning(String? message) {
    log.warning(message);
  }

  static print(String? message) {
    log.warning(message);
  }
}