import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 全局防衝動購物模式狀態
class ModeState {
  final bool masterEnabled;
  final bool scamDetection;
  final bool coolingPeriod;
  final bool trackingProtection;

  const ModeState({
    this.masterEnabled = false,
    this.scamDetection = true,
    this.coolingPeriod = true,
    this.trackingProtection = true,
  });

  ModeState copyWith({
    bool? masterEnabled,
    bool? scamDetection,
    bool? coolingPeriod,
    bool? trackingProtection,
  }) {
    return ModeState(
      masterEnabled: masterEnabled ?? this.masterEnabled,
      scamDetection: scamDetection ?? this.scamDetection,
      coolingPeriod: coolingPeriod ?? this.coolingPeriod,
      trackingProtection: trackingProtection ?? this.trackingProtection,
    );
  }
}

class ModeNotifier extends StateNotifier<ModeState> {
  ModeNotifier() : super(const ModeState());

  void toggleMaster() {
    state = state.copyWith(masterEnabled: !state.masterEnabled);
  }

  void toggleScamDetection() {
    state = state.copyWith(scamDetection: !state.scamDetection);
  }

  void toggleCoolingPeriod() {
    state = state.copyWith(coolingPeriod: !state.coolingPeriod);
  }

  void toggleTrackingProtection() {
    state = state.copyWith(trackingProtection: !state.trackingProtection);
  }
}

final modeProvider = StateNotifierProvider<ModeNotifier, ModeState>(
  (ref) => ModeNotifier(),
);
