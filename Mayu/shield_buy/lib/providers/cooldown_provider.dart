import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cooldown_item.dart';

class CooldownNotifier extends StateNotifier<List<CooldownItem>> {
  CooldownNotifier() : super([]);

  void addItem(String url, String title) {
    final item = CooldownItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      url: url,
      title: title,
      lockedAt: DateTime.now(),
    );
    state = [...state, item];
  }

  void removeItem(String id) {
    state = state.where((e) => e.id != id).toList();
  }
}

final cooldownProvider =
    StateNotifierProvider<CooldownNotifier, List<CooldownItem>>(
  (ref) => CooldownNotifier(),
);
