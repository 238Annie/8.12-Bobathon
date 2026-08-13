import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'scam_service.dart';
import '../models/scam_result.dart';

/// 廣告主動偵測 Service
/// 實際產品透過 Android AccessibilityService / iOS Screen Time API
/// 偵測畫面上出現的廣告連結，此處模擬偵測流程。
class AdDetectorService {
  final _scamService = ScamService();
  final _notifications = FlutterLocalNotificationsPlugin();

  static const _channelId = 'shield_buy_scam';
  static const _channelName = '詐騙廣告警示';

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    await _notifications.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );
  }

  /// 當畫面偵測到廣告連結時呼叫此方法
  Future<void> onAdDetected(String url) async {
    final result = await _scamService.analyze(url);
    await _showNotification(result);
  }

  Future<void> _showNotification(ScamResult result) async {
    final (title, body, color) = switch (result.riskLevel) {
      RiskLevel.low    => ('✅ 低風險廣告', '未發現詐騙特徵，仍請謹慎購物', const Color(0xFF4CAF50)),
      RiskLevel.medium => ('⚠️ 中風險廣告', '廣告使用高壓銷售手法，請謹慎評估', const Color(0xFFFF9800)),
      RiskLevel.high   => ('🚨 高風險詐騙！', '此廣告已被多人回報為詐騙，請勿點擊', const Color(0xFFE53935)),
    };

    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      importance: Importance.high,
      priority: Priority.high,
      color: color,
      actions: [
        const AndroidNotificationAction('report', '回報詐騙', showsUserInterface: false),
        const AndroidNotificationAction('dismiss', '略過'),
      ],
    );

    await _notifications.show(
      result.url.hashCode,
      title,
      body,
      NotificationDetails(android: androidDetails),
      payload: result.url,
    );
  }
}
