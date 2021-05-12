import 'package:flutter/material.dart';

class MyPixel extends StatelessWidget {
  final innercolor;
  final child;
  final outercolor;

  MyPixel({this.child, this.outercolor, this.innercolor});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: EdgeInsets.all(10),
          color: outercolor, child:ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: innercolor, child: child )), )),
    );
  }
}
