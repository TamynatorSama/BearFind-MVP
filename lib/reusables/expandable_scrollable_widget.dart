import 'package:flutter/material.dart';

class ExpandableScrollableWidget extends StatelessWidget {
  final Widget child;
  final ScrollPhysics? physics;
  const ExpandableScrollableWidget({super.key, required this.child,this.physics});

  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, layout) {
        return SingleChildScrollView(
          physics: physics,
          child: IntrinsicHeight(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: layout.maxHeight),
              child: child,
            ),
          ),
        );
      });
}