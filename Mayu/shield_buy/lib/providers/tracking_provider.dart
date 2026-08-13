import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrackingState {
  final int totalBlocked;
  final List<String> recentTrackers;

  const TrackingState({
    this.totalBlocked = 0,
    this.recentTrackers = const [],
  });

  TrackingState copyWith({int? totalBlocked, List<String>? recentTrackers}) {
    return TrackingState(
      totalBlocked: totalBlocked ?? this.totalBlocked,
      recentTrackers: recentTrackers ?? this.recentTrackers,
    );
  }
}

class TrackingNotifier extends StateNotifier<TrackingState> {
  TrackingNotifier() : super(const TrackingState());

  void recordBlock(String trackerDomain) {
    final updated = List<String>.from(state.recentTrackers);
    if (!updated.contains(trackerDomain)) updated.insert(0, trackerDomain);
    if (updated.length > 10) updated.removeLast();
    state = state.copyWith(
      totalBlocked: state.totalBlocked + 1,
      recentTrackers: updated,
    );
  }

  void reset() {
    state = const TrackingState();
  }
}

final trackingProvider =
    StateNotifierProvider<TrackingNotifier, TrackingState>(
  (ref) => TrackingNotifier(),
);
