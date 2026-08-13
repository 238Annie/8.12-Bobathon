import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/scam_result.dart';
import '../services/scam_service.dart';

/// 從通知點進來的詳細結果頁（選項 A：通知上已有摘要，此頁為備用詳細頁）
class ScamResultScreen extends StatefulWidget {
  final String url;
  const ScamResultScreen({super.key, required this.url});

  @override
  State<ScamResultScreen> createState() => _ScamResultScreenState();
}

class _ScamResultScreenState extends State<ScamResultScreen> {
  final _service = ScamService();
  ScamResult? _result;
  bool _loading = true;
  bool _reported = false;

  @override
  void initState() {
    super.initState();
    _analyze();
  }

  Future<void> _analyze() async {
    final result = await _service.analyze(widget.url);
    if (mounted) setState(() { _result = result; _loading = false; });
  }

  Color get _riskColor {
    switch (_result!.riskLevel) {
      case RiskLevel.low:    return const Color(0xFF4CAF50);
      case RiskLevel.medium: return const Color(0xFFFF9800);
      case RiskLevel.high:   return const Color(0xFFE53935);
    }
  }

  IconData get _riskIcon {
    switch (_result!.riskLevel) {
      case RiskLevel.low:    return Icons.check_circle_outline;
      case RiskLevel.medium: return Icons.warning_amber_outlined;
      case RiskLevel.high:   return Icons.dangerous_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('詐騙風險分析',
          style: GoogleFonts.notoSans(fontSize: 20, fontWeight: FontWeight.w700, color: const Color(0xFF1F2328))),
        centerTitle: true,
      ),
      body: _loading ? _buildLoading() : _buildResult(),
    );
  }

  Widget _buildLoading() => Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      const CircularProgressIndicator(color: Color(0xFF4CAF50)),
      const SizedBox(height: 20),
      Text('正在分析廣告連結…',
        style: GoogleFonts.notoSans(fontSize: 18, color: const Color(0xFF57606A))),
    ]),
  );

  Widget _buildResult() {
    final r = _result!;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          // 風險卡
          Container(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            decoration: BoxDecoration(
              color: _riskColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _riskColor.withOpacity(0.4), width: 1.5),
            ),
            child: Column(children: [
              Icon(_riskIcon, size: 64, color: _riskColor),
              const SizedBox(height: 12),
              Text(r.riskLabel,
                style: GoogleFonts.notoSans(fontSize: 28, fontWeight: FontWeight.w900, color: _riskColor)),
              const SizedBox(height: 8),
              Text(r.reason, textAlign: TextAlign.center,
                style: GoogleFonts.notoSans(fontSize: 16, color: const Color(0xFF1F2328), height: 1.5)),
            ]),
          ),

          if (r.warnings.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text('⚠️ 注意事項',
              style: GoogleFonts.notoSans(fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF1F2328))),
            const SizedBox(height: 10),
            ...r.warnings.map((w) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(children: [
                Icon(Icons.arrow_right, color: _riskColor),
                const SizedBox(width: 6),
                Expanded(child: Text(w,
                  style: GoogleFonts.notoSans(fontSize: 16, color: const Color(0xFF1F2328)))),
              ]),
            )),
          ],

          const SizedBox(height: 32),

          _reported
              ? Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(14)),
                  child: Text('✅ 感謝您的回報！已加入審核佇列',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSans(fontSize: 16, color: const Color(0xFF4CAF50), fontWeight: FontWeight.w600)))
              : OutlinedButton.icon(
                  onPressed: () => setState(() => _reported = true),
                  icon: const Icon(Icons.flag_outlined),
                  label: Text('回報這個廣告為詐騙',
                    style: GoogleFonts.notoSans(fontSize: 16, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE53935),
                    side: const BorderSide(color: Color(0xFFE53935)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),

          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50), foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('返回', style: GoogleFonts.notoSans(fontSize: 18, fontWeight: FontWeight.w700)),
          ),
        ]),
      ),
    );
  }
}
