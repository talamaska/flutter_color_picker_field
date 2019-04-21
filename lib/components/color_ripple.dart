import 'package:flutter/material.dart';
//import 'package:flutter/scheduler.dart';

class Ripple extends StatelessWidget {
  Ripple({this.controller, this.color, this.size}) :
        scaleUpAnimation = Tween<double>(begin: 0.8, end: 5.0).animate(
            CurvedAnimation(
                parent: controller,
                curve: const Interval(
                    0.2,
                    1.0,
                    curve: Cubic(0.25, 0.46, 0.45, 0.94)
                )
            )
        ),
        opacityAnimation = Tween<double>(begin: 0.6, end: 0.0).animate(
            CurvedAnimation(
                parent: controller,
                curve: const Interval(
                    0.2,
                    1.0,
                    curve: Cubic(0.25, 0.46, 0.45, 0.94)
                )
            )
        ),
        scaleDownAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
            CurvedAnimation(
                parent: controller,
                curve: const Interval(
                    0.0,
                    0.2,
                    curve: Curves.easeOut
                )
            )
        );

  final AnimationController controller;
  final Animation<double> scaleUpAnimation;
  final Animation<double> scaleDownAnimation;
  final Animation<double> opacityAnimation;
  final Color color;
  final Size size;


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) {
          return Container(
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..scale(scaleDownAnimation.value)
                ..scale(scaleUpAnimation.value),
              child: Opacity(
                  opacity: opacityAnimation.value,
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: color,
                            style: BorderStyle.solid,
                            width: 4.0 - (2 * controller.value)
                        )
                    ),
                  )
              ),
            ),
          );
        }
    );
  }
}