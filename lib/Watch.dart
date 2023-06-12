/*
Time:2023/6/12
Description:
Author:
*/

import 'dart:math';

import 'package:flutter/material.dart';

class Watch extends StatelessWidget {
  final double width;
  final Color? clothesColor;
  final Color? skinColor;
  final Color? hairColor;
  final Color? backgroundColor;
  final String? text;
  final TextStyle? textStyle;

  const Watch(
      {super.key,
      required this.width,
      this.clothesColor,
      this.skinColor,
      this.hairColor,
      this.text,
      this.backgroundColor,
      this.textStyle});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(width/4),
        child: CustomPaint(
          painter: _WatchPainter(
              width: width,
              clothesColor: clothesColor,
              skinColor: skinColor,
              hairColor: hairColor,
              backgroundColor: backgroundColor,
              text: text,
              textStyle: textStyle),
        ),
      ),
    );
  }
}

class _WatchPainter extends CustomPainter {
  static const Color backgroundColorOrigin = Color.fromRGBO(82, 102, 101, 1);
  static const Color clothesColorOrigin = Color.fromRGBO(175, 104, 81, 1);
  static const Color skinColorOrigin = Color.fromRGBO(202, 139, 109, 1);
  static const Color hairColorOrigin = Color.fromRGBO(157, 130, 112, 1);
  static const Color mountColorOrigin = Color.fromRGBO(69, 64, 64, 1);
  final double width;
  final Color? clothesColor;
  final Color? skinColor;
  final Color? hairColor;
  final Color? backgroundColor;
  final String? text;
  final TextStyle? textStyle;

  _WatchPainter(
      {required this.width,
      this.clothesColor,
      this.skinColor,
      this.hairColor,
      this.backgroundColor,
      this.text,
      this.textStyle});

  @override
  void paint(Canvas canvas, Size size) {
    ///创建画笔
    Paint paint = Paint()
      ..color = backgroundColor??backgroundColorOrigin
      ..strokeWidth = 10
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    ///定义背景形状
    Rect rect = Offset.zero & Size(width, width);
    RRect rRect = RRect.fromRectAndRadius(rect,Radius.circular(width/4));
    canvas.drawRRect(rRect, paint);

    ///画身体
    paint.color = clothesColor ?? clothesColorOrigin;
    Rect ovalRect = Offset(0, width * 4 / 5) & Size(width, width / 2);
    canvas.drawOval(ovalRect, paint);

    ///画脖子
    paint.color = skinColor??skinColorOrigin;
    Path neckPath = Path()..moveTo(width*2/3, width*3/5);
    neckPath.lineTo(width*2/3, width*5/6);
    neckPath.arcToPoint(Offset(width/3, width*5/6),radius: Radius.circular(width/5));
    neckPath.lineTo(width/3, width*3/5);
    neckPath.close();
    canvas.drawPath(neckPath, paint);

    ///画脸
    Path facePath = Path()..moveTo(width*5/6, width/5);
    facePath.quadraticBezierTo(width*19/20, width*10/11, width/2, width*3/4);
    facePath.quadraticBezierTo(width/3, width*11/16, width/4, width*3/5);
    facePath.lineTo(width/4,  width/5);
    facePath.close();
    canvas.drawShadow(facePath, Colors.black12.withOpacity(0.5), 5, true);
    canvas.drawPath(facePath, paint);

    ///画头发
    paint.color = hairColor??hairColorOrigin;
    Path hairPath = Path()..moveTo(width*6/7, width/5);
    hairPath.quadraticBezierTo(width*5/6, width/4, width*2/3, width/4);
    hairPath.quadraticBezierTo(width/3,  width/4, width/3, width/2);
    hairPath.quadraticBezierTo(width/3, width*2/3, width/4, width*2/3);
    hairPath.quadraticBezierTo(width/6, width*2/3, width/7, width/2);
    hairPath.quadraticBezierTo(width/10, width/8, width/3,  width/15);
    hairPath.quadraticBezierTo(width/2, width/40, width*2/3,  width/15);
    hairPath.quadraticBezierTo(width*8/9, width/9, width*6/7, width/5);
    canvas.drawShadow(hairPath,Colors.black12.withOpacity(0.5), 5, true);
    canvas.drawPath(hairPath, paint);

    ///嘴巴
    paint.color = mountColorOrigin;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = width/60;
    Rect mountRect = Offset(size.width*5/9, size.width*4/7)&Size(width/5, width/10);
    canvas.drawArc(mountRect, pi/4, pi/2, false, paint);

    ///文字
    TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
        text: text ?? "${DateTime.now().hour}\\${DateTime.now().minute}",
        style: textStyle??TextStyle(color: mountColorOrigin,fontSize: width/6),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset((width-textPainter.width)*2/3, (width-textPainter.height)*2/5));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
