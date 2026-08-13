class CooldownItem {
  final String id;
  final String url;
  final String title;
  final DateTime lockedAt;

  const CooldownItem({
    required this.id,
    required this.url,
    required this.title,
    required this.lockedAt,
  });

  static const Duration cooldownDuration = Duration(hours: 72);

  DateTime get unlocksAt => lockedAt.add(cooldownDuration);

  bool get isUnlocked => DateTime.now().isAfter(unlocksAt);

  Duration get remaining {
    final r = unlocksAt.difference(DateTime.now());
    return r.isNegative ? Duration.zero : r;
  }

  String get remainingLabel {
    final r = remaining;
    final h = r.inHours;
    final m = r.inMinutes % 60;
    return '$h 小時 $m 分鐘';
  }
}
