import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:today/core/config/constants.dart';

/// Returns a periodic timer. With the given duration and callback.
Timer useTimer({
  required void Function(Timer) callback,
  required Duration duration,
}) {
  return use(
    _TimerHook(
      callback: callback,
      duration: duration,
    ),
  );
}

class _TimerHook extends Hook<Timer> {
  final void Function(Timer) callback;
  final Duration duration;

  const _TimerHook({
    required this.callback,
    required this.duration,
  });

  @override
  HookState<Timer, Hook<Timer>> createState() => _TimerHookState();
}

class _TimerHookState extends HookState<Timer, _TimerHook> {
  late Timer timer;

  @override
  void initHook() {
    super.initHook();

    timer = Timer.periodic(
      hook.duration,
      hook.callback,
    );
  }

  @override
  Timer build(BuildContext context) {
    return timer;
  }

  @override
  void dispose() {
    if (timer.isActive) timer.cancel();
    logger.i("Disposed timer");

    super.dispose();
  }

  @override
  String get debugLabel => 'useTimerHook';
}
