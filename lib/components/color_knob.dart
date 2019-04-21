import 'package:flutter/material.dart';
//import 'package:flutter/scheduler.dart';
import 'package:flutter_color_picker/components/color_ripple.dart';


class ColorKnob extends StatefulWidget {
  const ColorKnob({
    this.color,
    this.ratio,
    this.saveColor
  });

  final Color color;
  final double ratio;
  final Function saveColor;

  @override
  _ColorKnobState createState() => _ColorKnobState();
}

class _ColorKnobState extends State<ColorKnob> with TickerProviderStateMixin  {

  AnimationController scaleAnimationController;
  AnimationController rippleAnimationController;
  Animation<double> scaleAnimation;
//  Animation<double> rippleAnimation;

  @override
  void initState() {
    super.initState();
    scaleAnimationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 100)
    );

    rippleAnimationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400)
    );

//    rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//        CurvedAnimation(parent: rippleAnimationController, curve: const Cubic(0.25,  0.46, 0.45, 0.94))
//    );

    scaleAnimationController.addStatusListener((AnimationStatus status) {
      if(status == AnimationStatus.completed) {
        scaleAnimationController.reverse();
      }
    });

    scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
        CurvedAnimation(parent: scaleAnimationController, curve: Curves.easeOut)
    );

    rippleAnimationController.addStatusListener((AnimationStatus status) {
       if(status == AnimationStatus.completed) {
          widget.saveColor();
       }
    });

    scaleAnimation.addListener((){
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
    return Center(
      child: Container(
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.transparent),
          child: FractionallySizedBox(
            widthFactor: widget.ratio,
            heightFactor: widget.ratio,
            child: ClipOval(
              clipBehavior: Clip.antiAlias,
              child: Center(
                child: Stack(
                    children: <Widget>[
                      Ripple(
                          controller: rippleAnimationController,
                          color: widget.color
                      ),
                      GestureDetector(
                        onTap: () {

            //            timeDilation = 1.0;
                          scaleAnimationController.forward(from: 0.0);
                          rippleAnimationController.forward(from: 0.0);
                        },
                        child: Transform.scale(
                          scale: scaleAnimation.value,
                          alignment: Alignment.center,
                          child: Container(
                            width: 60.0,
                            height: 60.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: widget.color,
                                border: Border.all(
                                    color: const Color(0xFFFFFFFF),
                                    style: BorderStyle.solid,
                                    width: 4.0
                                ),
                                boxShadow: const <BoxShadow>[
                                  BoxShadow(
                                      offset: Offset(0.0, 1.0),
                                      blurRadius: 6.0,
                                      spreadRadius: 1.0,
                                      color: Color(0x44000000)
                                  )
                                ]),

                          ),
                        ),
                      ),

                    ]
                ),
              ),
            ),
          )
      ),
    );
  }
}





