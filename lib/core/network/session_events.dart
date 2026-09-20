import 'dart:async';

/// Fired when the refresh token itself is invalid/expired, so the user
/// has to log in again. `core/network` never imports screens or the
/// router, so this is a plain event stream — the app shell (`main.dart`)
/// listens and decides where "log in again" actually navigates to.
class SessionEvents {
  const SessionEvents._();

  static final _controller = StreamController<void>.broadcast();

  static Stream<void> get onSessionExpired => _controller.stream;

  static void notifySessionExpired() => _controller.add(null);
}
