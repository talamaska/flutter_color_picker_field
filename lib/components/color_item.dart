import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class ColorItem extends StatelessWidget {
  const ColorItem({
    Key key,
    @required this.item,
  })  : assert(item != null),
        super(key: key);

  final Color item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24.0,
      height: 24.0,
      margin: const EdgeInsets.only(right: 5.0),
      decoration: BoxDecoration(
          color: item,
          shape: BoxShape.circle,
          boxShadow: const <BoxShadow>[
            BoxShadow(
              offset: Offset(0.0, 1.0),
              blurRadius: 1.0,
              spreadRadius: 0.0,
              color: Color(0x44000000),
            )
          ]),
    );
  }
}
