import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final globalLoadingProvider = StateNotifierProvider<GlobalLoading, bool>((ref) => GlobalLoading());

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
  GlobalLoading() : super(false);

  /// start loading with timeout
  ///
  /// if timeout reached, stop loading and throw [LoadingException]
  void startLoadingWithTimeout({int timeout = 10}) async {
    state = true;
    await Future.delayed(Duration(seconds: timeout));

    if (state) {
      state = false;
      throw LoadingException("Timeout reached");
    }
  }

  /// start loading with timeout and return result
  ///
  /// if timeout reached, stop loading and throw [LoadingException]
  Future<T> startLoadingWithTimeoutAndReturnResult<T>(Future<T> Function() future, {int timeout = 10}) async {
    state = true;
    final result = await Future.any([
      future(),
      Future.delayed(Duration(seconds: timeout), () {
        state = false;
        throw LoadingException("Timeout reached");
      }),
    ]);

    state = false;
    return result;
  }

  void stopLoading() {
    state = false;
  }
}

class LoadingException implements Exception {
  final String message;

  LoadingException(this.message);
}
