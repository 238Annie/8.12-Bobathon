/// 跨平台追蹤防護 Service
/// 維護已知追蹤網域黑名單，攔截蝦皮 ↔ SNS 的追蹤像素 / Cookie 請求。
/// 實際產品透過本地 VPN（Android VpnService / iOS NEPacketTunnelProvider）
/// 於系統層攔截；此處封裝邏輯層。
class TrackingProtectionService {
  static const List<String> _trackerDomains = [
    // Facebook Pixel
    'connect.facebook.net',
    'www.facebook.com/tr',
    // Google Analytics / Ads
    'google-analytics.com',
    'googletagmanager.com',
    'doubleclick.net',
    // 蝦皮追蹤
    'shopee-analytics.com',
    'spanalytics.com',
    // 其他常見追蹤器
    'scorecardresearch.com',
    'adnxs.com',
    'criteo.com',
    'taboola.com',
  ];

  int _blockedCount = 0;
  final List<String> _blockedList = [];

  int get blockedCount => _blockedCount;
  List<String> get blockedList => List.unmodifiable(_blockedList);

  /// 檢查 URL 是否為追蹤請求，是則攔截並記錄
  bool shouldBlock(String url) {
    final lower = url.toLowerCase();
    for (final domain in _trackerDomains) {
      if (lower.contains(domain)) {
        _blockedCount++;
        if (!_blockedList.contains(domain)) {
          _blockedList.add(domain);
        }
        return true;
      }
    }
    return false;
  }

  void reset() {
    _blockedCount = 0;
    _blockedList.clear();
  }
}
