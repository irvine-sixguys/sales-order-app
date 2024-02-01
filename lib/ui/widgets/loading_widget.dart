import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:six_guys/utils/modals.dart';
import 'package:uuid/uuid.dart';

final globalLoadingProvider = StateNotifierProvider<GlobalLoading, bool>((ref) => GlobalLoading(ref));

const _timeoutMessage = "[Timeout] maybe the server is down or the internet connection is slow. Please try again later.";

class LoadingWidget extends ConsumerWidget {
  final Widget child;

  const LoadingWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(globalLoadingProvider);

    if (isLoading) {
      return Stack(
        alignment: Alignment.center,
        children: [
          AbsorbPointer(child: child),
          const Center(child: CircularProgressIndicator()),
        ],
      );
    } else {
      return child;
    }
  }
}

/// set 10 seconds as default timeout
///
/// purpose: prevent user to wait forever
class GlobalLoading extends StateNotifier<bool> {
  final Ref ref;
  final Uuid _uuid = Uuid();
  String? _currentLoadingId;

  GlobalLoading(this.ref) : super(false);

  void _showMessage(String message) {
    ref.read(modalsProvider).showMySnackBar(message);
  }

  /// start loading with timeout
  ///
  /// if timeout reached, stop loading and show message
  void startLoadingWithTimeout({int timeout = 10}) async {
    state = true;
    final id = _uuid.v8();
    _currentLoadingId = id;
    await Future.delayed(Duration(seconds: timeout));

    if (state && _currentLoadingId == id) {
      state = false;
      _showMessage(_timeoutMessage);
    }
  }

  /// start loading with timeout and return result
  ///
  /// if timeout reached, stop loading and show message
  Future<T?> startLoadingWithTimeoutAndReturnResult<T>(Future<T> Function() future, {int timeout = 20}) async {
    state = true;
    final id = _uuid.v8();
    _currentLoadingId = id;
    final result = await Future.any([
      future(),
      Future.delayed(Duration(seconds: timeout), () {
        if (state && _currentLoadingId == id) {
          state = false;
          _showMessage(_timeoutMessage);
        }
      }),
    ]);

    if (state && _currentLoadingId == id) {
      state = false;
    }

    return result;
  }

  void stopLoading() {
    state = false;
  }
}
