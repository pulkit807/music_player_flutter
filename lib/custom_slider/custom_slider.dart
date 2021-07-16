import 'package:flutter/material.dart';

class CustomSliderThumb extends SliderComponentShape {
  final double thumbRadius = 8;
  final Color theme;
  CustomSliderThumb({@required this.theme});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
    double textScaleFactor,
    Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final bg = Paint()
      ..color = Colors.white //Thumb Background Color
      ..style = PaintingStyle.fill;
    final foreGround = Paint()
      ..color = theme //Thumb foreground Color
      ..style = PaintingStyle.fill;
    final shadow = Paint()
      ..color = Colors.grey[400] //Thumb shadow Color
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal,5);
      
    canvas.drawCircle(Offset(center.dx+1, center.dy+2),thumbRadius,shadow);
    canvas.drawCircle(center, thumbRadius, bg);
    canvas.drawCircle(center, thumbRadius * 0.6, foreGround);
    
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
