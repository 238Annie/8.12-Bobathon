import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/mode_provider.dart';
import '../widgets/feature_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(modeProvider);
    final notifier = ref.read(modeProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'ShieldBuy',
          style: GoogleFonts.notoSans(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1F2328),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 32),

              // ── 主開關區塊 ──
              GestureDetector(
                onTap: notifier.toggleMaster,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  padding: const EdgeInsets.symmetric(vertical: 36),
                  decoration: BoxDecoration(
                    color: mode.masterEnabled
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFBDBDBD),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: mode.masterEnabled
                            ? const Color(0xFF4CAF50).withOpacity(0.35)
                            : const Color(0xFFE53935).withOpacity(0.25),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        mode.masterEnabled
                            ? Icons.shield
                            : Icons.shield_outlined,
                        size: 72,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        mode.masterEnabled ? '保護中' : '已關閉',
                        style: GoogleFonts.notoSans(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        mode.masterEnabled
                            ? '防衝動購物模式已啟動'
                            : '點我開啟全面保護',
                        style: GoogleFonts.notoSans(
                          fontSize: 17,
                          color: Colors.white.withOpacity(0.88),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // ── 功能標題 ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      '保護功能設定',
                      style: GoogleFonts.notoSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1F2328),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (!mode.masterEnabled)
                      Text(
                        '（請先開啟保護模式）',
                        style: GoogleFonts.notoSans(
                          fontSize: 14,
                          color: const Color(0xFF57606A),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ── 三個子功能卡片 ──
              FeatureCard(
                title: '詐騙廣告偵測',
                description: '自動辨識可疑購物廣告，\n高風險時立即警告',
                icon: Icons.gpp_bad_outlined,
                enabled: mode.scamDetection,
                masterEnabled: mode.masterEnabled,
                onToggle: notifier.toggleScamDetection,
              ),
              FeatureCard(
                title: '三天冷靜期',
                description: '購物連結鎖定 72 小時，\n衝動消費前先想清楚',
                icon: Icons.hourglass_bottom_outlined,
                enabled: mode.coolingPeriod,
                masterEnabled: mode.masterEnabled,
                onToggle: notifier.toggleCoolingPeriod,
              ),
              FeatureCard(
                title: '追蹤防護',
                description: '阻擋蝦皮追蹤你的瀏覽紀錄，\n讓社群平台無法投放精準廣告',
                icon: Icons.visibility_off_outlined,
                enabled: mode.trackingProtection,
                masterEnabled: mode.masterEnabled,
                onToggle: notifier.toggleTrackingProtection,
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
