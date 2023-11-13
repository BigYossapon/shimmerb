import 'package:flutter/material.dart';

enum Type {
  lf,
}

class Shimmerb extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration period;
  final Type type;

  const Shimmerb(
      {super.key,
      required this.baseColor,
      required this.highlightColor,
      required this.child,
      this.period = const Duration(milliseconds: 1500),
      this.type = Type.lf});

  @override
  State<Shimmerb> createState() => _ShimmerbState();
}

class _ShimmerbState extends State<Shimmerb>
    with SingleTickerProviderStateMixin {
  late AnimationController controllerOne;
  late Animation<Color?> animationOne;
  late Animation<Color?> animationTwo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controllerOne = AnimationController(duration: widget.period, vsync: this);
    animationOne =
        ColorTween(begin: widget.baseColor, end: widget.highlightColor)
            .animate(controllerOne);
    animationTwo =
        ColorTween(begin: widget.highlightColor, end: widget.baseColor)
            .animate(controllerOne);
    controllerOne.forward();
    controllerOne.addListener(() {
      if (controllerOne.status == AnimationStatus.completed) {
        controllerOne.reverse();
      } else if (controllerOne.status == AnimationStatus.dismissed) {
        controllerOne.forward();
      }
      this.setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controllerOne.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
        shaderCallback: (rect) {
          return LinearGradient(
                  tileMode: TileMode.mirror,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [animationOne.value!, animationTwo.value!])
              .createShader(rect, textDirection: TextDirection.ltr);
        },
        child: widget.child);
  }
}
