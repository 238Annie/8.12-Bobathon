import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'scam_result_screen.dart';

/// 輸入廣告連結送出分析的畫面
class ScamCheckScreen extends StatefulWidget {
  const ScamCheckScreen({super.key});

  @override
  State<ScamCheckScreen> createState() => _ScamCheckScreenState();
}

class _ScamCheckScreenState extends State<ScamCheckScreen> {
  final _controller = TextEditingController();
  bool _hasInput = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final url = _controller.text.trim();
    if (url.isEmpty) return;
    Navigator.push(context,
      MaterialPageRoute(builder: (_) => ScamResultScreen(url: url)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('詐騙廣告偵測',
          style: GoogleFonts.notoSans(fontSize: 20, fontWeight: FontWeight.w700, color: const Color(0xFF1F2328))),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              // 說明區
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8FA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(children: [
                  const Icon(Icons.info_outline, size: 32, color: Color(0xFF3b82d4)),
                  const SizedBox(height: 10),
                  Text(
                    '看到可疑廣告？\n把連結貼過來，我幫你檢查是不是詐騙！',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSans(fontSize: 17, color: const Color(0xFF1F2328), height: 1.6),
                  ),
                ]),
              ),

              const SizedBox(height: 28),

              // 輸入框
              TextField(
                controller: _controller,
                onChanged: (v) => setState(() => _hasInput = v.trim().isNotEmpty),
                style: GoogleFonts.notoSans(fontSize: 16),
                decoration: InputDecoration(
                  hintText: '貼上廣告連結（例如 https://...）',
                  hintStyle: GoogleFonts.notoSans(color: const Color(0xFF9E9E9E), fontSize: 15),
                  filled: true,
                  fillColor: const Color(0xFFF7F8FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  suffixIcon: _hasInput
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Color(0xFF9E9E9E)),
                          onPressed: () { _controller.clear(); setState(() => _hasInput = false); })
                      : null,
                ),
              ),

              const SizedBox(height: 20),

              // 分析按鈕
              ElevatedButton(
                onPressed: _hasInput ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  disabledBackgroundColor: const Color(0xFFE0E0E0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text('開始分析', style: GoogleFonts.notoSans(fontSize: 19, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
