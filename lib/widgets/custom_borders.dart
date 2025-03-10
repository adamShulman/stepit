
import 'package:flutter/material.dart';

class CustomOutlinedBorder extends OutlinedBorder {

  final double borderRadius;

  const CustomOutlinedBorder({
    super.side = BorderSide.none,
    this.borderRadius = 12.0,
  });
  

  @override
  ShapeBorder scale(double t) {
    return CustomOutlinedBorder(
      side: side.scale(t),
      borderRadius: borderRadius * t,
    );
  }

  @override
  OutlinedBorder copyWith({BorderSide? side}) {
    return CustomOutlinedBorder(
      side: side ?? this.side,
      borderRadius: borderRadius,
    );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {

    final Path path = Path();
    final double r = borderRadius;
    const double p = 4.0;

    path.moveTo(rect.left, rect.top + r);
    path.quadraticBezierTo(rect.left, rect.top, rect.left + r, rect.top);
    path.lineTo(rect.right - p - rect.height / 2, rect.top);
    path.arcToPoint(
      Offset(rect.right - p - rect.height / 2, rect.bottom),
      radius: Radius.circular(rect.height / 2),
      clockwise: false,
    );
    path.lineTo(rect.left + r, rect.bottom);
    path.quadraticBezierTo(rect.left, rect.bottom, rect.left, rect.bottom - r);
    path.close();

    return path;
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {

    final Paint paint = Paint()
      ..color = side.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.1;

    canvas.drawPath(getOuterPath(rect, textDirection: textDirection), paint);
  }
}
