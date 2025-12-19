import 'package:flutter/material.dart';

class BtnWidget extends StatelessWidget {
  final VoidCallback onTap;
  final double width;
  final double height;
  final String text;
  final TextStyle textstyle;
  final Color bgcolor;
  final bool isUpercase;
  final IconData? icon; // gunakan IconData, bukan Icon

  const BtnWidget({
    super.key,
    required this.onTap,
    required this.width,
    required this.height,
    required this.text,
    required this.bgcolor,
    required this.textstyle,
    this.isUpercase = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgcolor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(12),
          ),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: textstyle.color),
              const SizedBox(width: 8),
            ],
            Text(isUpercase ? text.toUpperCase() : text, style: textstyle),
          ],
        ),
      ),
    );
  }
}
