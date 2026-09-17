import '../utils/logger/app_logger.dart';

class CacheManager {
  const CacheManager._();

  static final Map<String, _CacheEntry> _store = {};


  static void write(String key, dynamic data) {
    _store[key] = _CacheEntry(data: data, cachedAt: DateTime.now());
    AppLogger.d('CACHE WRITE [$key]');
  }

  static dynamic read(String key) {
    final entry = _store[key];
    if (entry == null) {
      AppLogger.d('CACHE MISS [$key]');
      return null;
    }
    AppLogger.d('CACHE HIT [$key]');
    return entry.data;
  }

  static bool isStale(String key, {required Duration maxAge}) {
    final entry = _store[key];
    if (entry == null) return true;
    return DateTime.now().difference(entry.cachedAt) > maxAge;
  }

  static void remove(String key) => _store.remove(key);


  static void clearAll() => _store.clear();
}

class _CacheEntry {
  const _CacheEntry({required this.data, required this.cachedAt});

  final dynamic data;
  final DateTime cachedAt;
}
