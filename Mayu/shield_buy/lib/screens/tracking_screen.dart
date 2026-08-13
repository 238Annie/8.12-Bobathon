import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/tracking_provider.dart';

class TrackingScreen extends ConsumerWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(trackingProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('追蹤防護報告',
            style: GoogleFonts.notoSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F2328))),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── 總封鎖數大卡片 ──
              Container(
                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2328),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(children: [
                  Text('今日已封鎖',
                      style: GoogleFonts.notoSans(
                          fontSize: 16, color: Colors.white70)),
                  const SizedBox(height: 8),
                  Text('${state.totalBlocked}',
                      style: GoogleFonts.notoSans(
                          fontSize: 56,
                          fontWeight: FontWeight.w900,
                          color: Colors.white)),
                  Text('個追蹤器',
                      style: GoogleFonts.notoSans(
                          fontSize: 16, color: Colors.white70)),
                  const SizedBox(height: 12),
                  Text('蝦皮與社群平台無法取得你的瀏覽紀錄',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSans(
                          fontSize: 13,
                          color: const Color(0xFF4CAF50),
                          fontWeight: FontWeight.w600)),
                ]),
              ),

              const SizedBox(height: 24),

              // ── 封鎖來源說明 ──
              Text('封鎖了哪些追蹤器？',
                  style: GoogleFonts.notoSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1F2328))),
              const SizedBox(height: 12),

              _TrackerInfoCard(
                icon: Icons.facebook,
                iconColor: const Color(0xFF1877F2),
                name: 'Facebook Pixel',
                desc: '記錄你在蝦皮的瀏覽行為，再投放精準廣告給你',
                blocked: state.recentTrackers.contains('connect.facebook.net'),
              ),
              _TrackerInfoCard(
                icon: Icons.analytics_outlined,
                iconColor: const Color(0xFF4285F4),
                name: 'Google Analytics',
                desc: '追蹤你的點擊路徑與購物意圖',
                blocked: state.recentTrackers.contains('google-analytics.com'),
              ),
              _TrackerInfoCard(
                icon: Icons.shopping_bag_outlined,
                iconColor: const Color(0xFFEE4D2D),
                name: '蝦皮追蹤腳本',
                desc: '將你的搜尋紀錄回傳給廣告平台',
                blocked: state.recentTrackers.contains('shopee-analytics.com'),
              ),
              _TrackerInfoCard(
                icon: Icons.ads_click,
                iconColor: const Color(0xFF9E9E9E),
                name: '其他廣告追蹤器',
                desc: 'Criteo、Taboola 等第三方廣告網路',
                blocked: state.totalBlocked > 3,
              ),

              const SizedBox(height: 24),

              // ── 最近封鎖清單 ──
              if (state.recentTrackers.isNotEmpty) ...[
                Text('最近封鎖紀錄',
                    style: GoogleFonts.notoSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1F2328))),
                const SizedBox(height: 10),
                ...state.recentTrackers.map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(children: [
                    const Icon(Icons.block, size: 16, color: Color(0xFF4CAF50)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(t,
                        style: GoogleFonts.notoSans(
                            fontSize: 14, color: const Color(0xFF1F2328)))),
                    Text('已封鎖',
                        style: GoogleFonts.notoSans(
                            fontSize: 12,
                            color: const Color(0xFF4CAF50),
                            fontWeight: FontWeight.w600)),
                  ]),
                )),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TrackerInfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String name;
  final String desc;
  final bool blocked;

  const _TrackerInfoCard({
    required this.icon,
    required this.iconColor,
    required this.name,
    required this.desc,
    required this.blocked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: blocked
            ? const Color(0xFFE8F5E9)
            : const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: blocked
              ? const Color(0xFF4CAF50)
              : const Color(0xFFE0E0E0),
          width: 1.5,
        ),
      ),
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                style: GoogleFonts.notoSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F2328))),
            const SizedBox(height: 2),
            Text(desc,
                style: GoogleFonts.notoSans(
                    fontSize: 12,
                    color: const Color(0xFF57606A),
                    height: 1.4)),
          ],
        )),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: blocked
                ? const Color(0xFF4CAF50)
                : const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            blocked ? '已封鎖' : '待封鎖',
            style: GoogleFonts.notoSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: blocked ? Colors.white : const Color(0xFF9E9E9E)),
          ),
        ),
      ]),
    );
  }
}
