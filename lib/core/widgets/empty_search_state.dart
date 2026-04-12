import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptySearchState extends StatelessWidget {
  const EmptySearchState({super.key});

  @override
  Widget build(BuildContext context) {
    const Color softPurple = Color(0xFF4B0082);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.travel_explore_rounded,
            size: 80,
            color: softPurple.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            "Bu kelimeyle eşleşen bir kayıt bulunamadı, seyyah",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: Colors.grey[500],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
