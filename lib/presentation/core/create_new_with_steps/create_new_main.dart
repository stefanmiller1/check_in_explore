import 'package:flutter/material.dart';

class CreateNewMain extends StatelessWidget {

  final Widget child;

  const CreateNewMain({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
            layoutBuilder: (currentChild, previousChildren) {
              return Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: [
                  ...previousChildren,
                  if (currentChild != null) currentChild,
                ],
              );
            },
            transitionBuilder: (child, animation) {
              final offsetAnimation = Tween(
              begin: const Offset(1.0, 0.0),
              end: const Offset(0.0, 0.0),
              ).animate(animation);
              // 3.
              return ClipRect(
              // 2.
              child: SlideTransition(
              position: offsetAnimation,
              child: child,
                ),
              );
            },
            switchInCurve: Curves.easeOutExpo,
            child: child,
          )
        ],
      ),
    );
  }

}