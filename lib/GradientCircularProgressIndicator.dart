/*
Time:2023/6/7
Description:
Author:
*/
import 'dart:math';

import 'package:flutter/material.dart';

class GradientCircularProgressIndicator extends StatelessWidget {
  final double strokeWidth;
  final double radius;
  final bool strokeCapRound;
  final double value;
  final Color backgroundColor;

  ///color.length must be equal stops.length
  final List<Color> colors;

  ///stops.length must be equal color.length
  final List<double> stops;

  const GradientCircularProgressIndicator(
      {super.key,
      required this.strokeWidth,
      required this.radius,
      required this.strokeCapRound,
      required this.value,
      required this.backgroundColor,
      required this.colors,
      required this.stops});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.fromRadius(radius),
      painter: _GradientCircularProgressPainter(
          strokeWidth,
          strokeCapRound,
          value,
          backgroundColor,
          colors,
          radius,
          stops),
    );
  }
}

class _GradientCircularProgressPainter extends CustomPainter {
  final double strokeWidth;
  final bool strokeCapRound;
  final double value;
  final Color backgroundColor;
  final List<Color> colors;
  final double totalAngle = 2 * pi;
  final double radius;
  final List<double> stops;

  _GradientCircularProgressPainter(this.strokeWidth, this.strokeCapRound,
      this.value, this.backgroundColor, this.colors, this.radius, this.stops);

  @override
  void paint(Canvas canvas, Size size) {
    ///处理角度偏移问题
    ///启示位置从270°转到360°
    canvas.translate((size.width) / 2, (size.height) / 2);
    canvas.rotate(-pi / 2);
    canvas.translate(-(size.width) / 2, -(size.height) / 2);
    size = Size.fromRadius(radius);

    ///计算偏移,为什么要有偏移？
    ///因为要根据strokeWidth,偏移位置
    double offset = strokeWidth / 2;

    ///返回一个0.0和1.0之间的doule值，这一步是为了防范value溢出
    double safeValue = value.clamp(0.0, 1.0) * totalAngle;

    ///开始点初始化
    double start = 0.0;

    ///根据偏移和大小确定矩形
    Rect rect = Offset(offset, offset) &
        Size(size.width - strokeWidth, size.height - strokeWidth);

    ///创建画笔
    var paint = Paint()
      ..strokeCap = strokeCapRound ? StrokeCap.round : StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeWidth = strokeWidth;

    ///画背景
    if (backgroundColor != Colors.transparent) {
      paint.color = backgroundColor;
      canvas.drawArc(rect, start, totalAngle, false, paint);
    }

    ///画颜色图层
    if (safeValue > 0) {
      List<double> safeStops = stops;
      List<Color> safeColors = colors;
      if(safeColors.isEmpty)safeColors = [Colors.deepOrange];
      if(safeStops.isEmpty||safeColors.length!=safeStops.length){
        safeStops = List.generate(safeColors.length, (index) => (1/safeColors.length)*index);
      }
      paint.shader =
          SweepGradient(colors: safeColors, stops: safeStops).createShader(rect);
      canvas.drawArc(rect, start, safeValue, false, paint);
    }
  }

  @override
  bool shouldRepaint(_GradientCircularProgressPainter old) =>
      old.strokeWidth != strokeWidth ||
      old.strokeCapRound != strokeCapRound ||
      old.backgroundColor != backgroundColor ||
      old.radius != radius ||
      old.value != value ||
      old.colors.toString() != colors.toString() ||
      old.stops.toString() != stops.toString();
}
