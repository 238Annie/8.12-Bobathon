enum RiskLevel { low, medium, high }

class ScamResult {
  final String url;
  final RiskLevel riskLevel;
  final String reason;
  final List<String> warnings;

  const ScamResult({
    required this.url,
    required this.riskLevel,
    required this.reason,
    required this.warnings,
  });

  String get riskLabel {
    switch (riskLevel) {
      case RiskLevel.low:    return '低風險';
      case RiskLevel.medium: return '中風險';
      case RiskLevel.high:   return '高風險詐騙';
    }
  }
}
