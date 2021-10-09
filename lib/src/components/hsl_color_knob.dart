import 'package:flutter/cupertino.dart';

import 'color_ripple.dart';

class HSLColorKnob extends StatefulWidget {
  const HSLColorKnob({
    Key? key,
    required this.hue,
    required this.saturation,
    required this.lightness,
    required this.ratio,
    this.saveColor,
  }) : super(key: key);

  final double hue;
  final double saturation;
  final double lightness;
  final double ratio;
  final VoidCallback? saveColor;

  @override
  _HSLColorKnobState createState() => _HSLColorKnobState();
}

class _HSLColorKnobState extends State<HSLColorKnob>
    with TickerProviderStateMixin {
  late AnimationController scaleAnimationController;
  late AnimationController rippleAnimationController;
  late Animation<double> scaleAnimation;
  // timeDilation = 1.0;

  @override
  void initState() {
    super.initState();
    scaleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    rippleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    scaleAnimationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        scaleAnimationController.reverse();
      }
    });

    scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(
        parent: scaleAnimationController,
        curve: Curves.easeOut,
      ),
    );

    rippleAnimationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        widget.saveColor?.call();
      }
    });

    scaleAnimation.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    scaleAnimationController.dispose();
    rippleAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CupertinoThemeData ct = CupertinoTheme.of(context);

    return Center(
      child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0x00000000),
          ),
          child: FractionallySizedBox(
            widthFactor: widget.ratio,
            heightFactor: widget.ratio,
            child: ClipOval(
              clipBehavior: Clip.antiAlias,
              child: Center(
                child: Stack(children: <Widget>[
                  ColorRipple(
                    controller: rippleAnimationController,
                    color: HSLColor.fromAHSL(
                      1.0,
                      widget.hue,
                      widget.saturation,
                      widget.lightness,
                    ).toColor(),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (!rippleAnimationController.isAnimating) {
                        scaleAnimationController.forward(from: 0.0);
                        rippleAnimationController.forward(from: 0.0);
                      }
                    },
                    child: Transform.scale(
                      scale: scaleAnimation.value,
                      alignment: Alignment.center,
                      child: Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: HSLColor.fromAHSL(
                            1.0,
                            widget.hue,
                            widget.saturation,
                            widget.lightness,
                          ).toColor(),
                          border: Border.all(
                            color: ct.scaffoldBackgroundColor,
                            style: BorderStyle.solid,
                            width: 4.0,
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              offset: const Offset(0.0, 1.0),
                              blurRadius: 6.0,
                              spreadRadius: 1.0,
                              color: ct.brightness == Brightness.dark
                                  ? const Color(0x44FFFFFF)
                                  : const Color(0x44000000),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          )),
    );
  }
}
