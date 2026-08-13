import '../models/scam_result.dart';

/// 詐騙分析 Service
/// 實際產品串接 OpenAI Cloud Function；此處為 mock 實作示範邏輯。
class ScamService {
  static const List<String> _blacklist = [
    'fake-shop.com',
    'scam-deals.tw',
    'cheap-gadget.net',
  ];

  static const List<String> _suspiciousKeywords = [
    'limited', '限時', '爆款', '清倉', '免費領取', '只剩', '秒殺',
  ];

  Future<ScamResult> analyze(String url) async {
    // 模擬網路延遲
    await Future.delayed(const Duration(milliseconds: 800));

    final lowerUrl = url.toLowerCase();

    // 黑名單命中 → 高風險
    for (final domain in _blacklist) {
      if (lowerUrl.contains(domain)) {
        return ScamResult(
          url: url,
          riskLevel: RiskLevel.high,
          reason: '此網址已被多位用戶回報為詐騙賣場',
          warnings: ['已列入黑名單', '價格異常偏低', '無法驗證賣家身份'],
        );
      }
    }

    // 關鍵字命中 → 中風險
    for (final kw in _suspiciousKeywords) {
      if (lowerUrl.contains(kw)) {
        return ScamResult(
          url: url,
          riskLevel: RiskLevel.medium,
          reason: '廣告使用高壓銷售手法，請謹慎評估',
          warnings: ['使用急迫性語言', '建議比價後再購買'],
        );
      }
    }

    // 預設 → 低風險
    return ScamResult(
      url: url,
      riskLevel: RiskLevel.low,
      reason: '未發現明顯詐騙特徵',
      warnings: [],
    );
  }
}
