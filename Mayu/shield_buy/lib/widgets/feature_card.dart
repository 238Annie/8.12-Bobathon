import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool enabled;
  final bool masterEnabled;
  final VoidCallback onToggle;

  const FeatureCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.enabled,
    required this.masterEnabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = masterEnabled && enabled;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFE8F5E9) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? const Color(0xFF4CAF50) : const Color(0xFFE0E0E0),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // 圖示
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFF4CAF50).withOpacity(0.15)
                  : Colors.grey.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              size: 28,
              color: isActive ? const Color(0xFF4CAF50) : Colors.grey,
            ),
          ),
          const SizedBox(width: 16),
          // 文字
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.notoSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F2328),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    color: const Color(0xFF57606A),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // 開關
          Switch(
            value: enabled,
            onChanged: masterEnabled ? (_) => onToggle() : null,
            activeColor: const Color(0xFF4CAF50),
            trackColor: WidgetStateProperty.resolveWith((states) {
              if (!masterEnabled) return Colors.grey.withOpacity(0.3);
              return null;
            }),
          ),
        ],
      ),
    );
  }
}
