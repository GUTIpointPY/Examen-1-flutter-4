import 'package:flutter/material.dart';

class CustomLogo extends StatelessWidget {
  final double size;

  const CustomLogo({
    super.key,
    this.size = 110.0,
  });

  @override
  Widget build(BuildContext context) {
    final double innerBoxSize = size * 0.65;

    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFF1F5F9), // Light grey background circle
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: innerBoxSize,
            height: innerBoxSize,
            decoration: BoxDecoration(
              color: const Color(0xFF0C1D24), // Dark slate/teal logo background
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Gold gradient applied to the text monogram
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFFE5A93C), // Metallic gold
                      Color(0xFFFFF0CA), // Bright gold highlight
                      Color(0xFFB8860B), // Dark goldenrod
                      Color(0xFFD4AF37), // Classic gold
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'AP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: innerBoxSize * 0.40,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'serif',
                          letterSpacing: 2,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        'L\'AMOR',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: innerBoxSize * 0.10,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 3,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
