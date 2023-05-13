import 'package:flutter/cupertino.dart';

// ignore: must_be_immutable
class MidText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  TextOverflow overflow;

  MidText({
    Key? key,
    this.color = const Color(0xFFFFFFFF),
    required this.text,
    this.size = 30,
    this.overflow = TextOverflow.ellipsis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w400,
        fontSize: 20,
      ),
    );
  }
}
