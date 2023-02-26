import 'package:flutter/widgets.dart';

class ColorItem extends StatelessWidget {
  const ColorItem({
    Key? key,
    this.size = 16.0,
    required this.item,
    this.shape = BoxShape.circle,
  }) : super(key: key);

  final Color item;
  final double? size;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      width: size,
      height: size,
      margin: orientation == Orientation.portrait
          ? EdgeInsets.only(right: size! * 0.2)
          : EdgeInsets.only(bottom: size! * 0.2),
      decoration: BoxDecoration(
        color: item,
        shape: shape,
        boxShadow: const <BoxShadow>[
          BoxShadow(
            offset: Offset(0.0, 1.0),
            blurRadius: 1.0,
            spreadRadius: 0.0,
            color: Color(0x44000000),
          )
        ],
      ),
    );
  }
}
