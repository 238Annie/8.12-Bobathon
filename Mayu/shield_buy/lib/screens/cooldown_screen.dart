import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/cooldown_provider.dart';
import '../models/cooldown_item.dart';

class CooldownScreen extends ConsumerWidget {
  const CooldownScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cooldownProvider);
    final notifier = ref.read(cooldownProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('冷靜清單',
            style: GoogleFonts.notoSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F2328))),
      ),
      body: items.isEmpty
          ? _buildEmpty()
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) =>
                  _CooldownCard(item: items[i], onRemove: () => notifier.removeItem(items[i].id)),
            ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.hourglass_empty, size: 72, color: Colors.grey.shade300),
        const SizedBox(height: 16),
        Text('冷靜清單是空的',
            style: GoogleFonts.notoSans(
                fontSize: 20, fontWeight: FontWeight.w700, color: Colors.grey.shade400)),
        const SizedBox(height: 8),
        Text('點擊購物連結時會自動加入',
            style: GoogleFonts.notoSans(fontSize: 15, color: Colors.grey.shade400)),
      ]),
    );
  }
}

class _CooldownCard extends StatefulWidget {
  final CooldownItem item;
  final VoidCallback onRemove;
  const _CooldownCard({required this.item, required this.onRemove});

  @override
  State<_CooldownCard> createState() => _CooldownCardState();
}

class _CooldownCardState extends State<_CooldownCard> {
  late final Stream<Duration> _ticker;
  bool _unlockRequested = false;

  @override
  void initState() {
    super.initState();
    _ticker = Stream.periodic(const Duration(seconds: 30), (_) => widget.item.remaining);
  }

  @override
  Widget build(BuildContext context) {
    final unlocked = widget.item.isUnlocked;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: unlocked ? const Color(0xFFE8F5E9) : const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: unlocked ? const Color(0xFF4CAF50) : const Color(0xFFFFB300),
          width: 1.5,
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // 商品名稱
        Row(children: [
          Icon(
            unlocked ? Icons.lock_open_outlined : Icons.lock_outline,
            color: unlocked ? const Color(0xFF4CAF50) : const Color(0xFFFFB300),
            size: 22,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(widget.item.title,
                style: GoogleFonts.notoSans(
                    fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF1F2328))),
          ),
        ]),

        const SizedBox(height: 10),

        // 倒數計時
        if (!unlocked)
          StreamBuilder<Duration>(
            stream: _ticker,
            initialData: widget.item.remaining,
            builder: (_, snap) {
              final r = snap.data ?? widget.item.remaining;
              final h = r.inHours;
              final m = r.inMinutes % 60;
              return Row(children: [
                const Icon(Icons.timer_outlined, size: 16, color: Color(0xFFFFB300)),
                const SizedBox(width: 6),
                Text('還需等待 $h 小時 $m 分鐘',
                    style: GoogleFonts.notoSans(
                        fontSize: 14, color: const Color(0xFF57606A))),
              ]);
            },
          ),

        if (unlocked)
          Text('✅ 冷靜期結束，你現在可以購買了！',
              style: GoogleFonts.notoSans(
                  fontSize: 14, color: const Color(0xFF4CAF50), fontWeight: FontWeight.w600)),

        const SizedBox(height: 12),

        // 操作按鈕
        Row(children: [
          if (unlocked)
            Expanded(
              child: ElevatedButton(
                onPressed: widget.onRemove,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('前往購買', style: GoogleFonts.notoSans(fontWeight: FontWeight.w700)),
              ),
            )
          else if (!_unlockRequested)
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _unlockRequested = true),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFE53935),
                  side: const BorderSide(color: Color(0xFFE53935)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('緊急解鎖', style: GoogleFonts.notoSans(fontWeight: FontWeight.w600)),
              ),
            )
          else
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text('請說明緊急解鎖原因：',
                    style: GoogleFonts.notoSans(fontSize: 13, color: const Color(0xFF57606A))),
                const SizedBox(height: 6),
                TextField(
                  style: GoogleFonts.notoSans(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: '例如：急需此商品…',
                    hintStyle: GoogleFonts.notoSans(color: Colors.grey, fontSize: 13),
                    filled: true, fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: widget.onRemove,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935), foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('確認解鎖', style: GoogleFonts.notoSans(fontWeight: FontWeight.w700)),
                ),
              ]),
            ),

          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.grey),
            onPressed: widget.onRemove,
          ),
        ]),
      ]),
    );
  }
}
