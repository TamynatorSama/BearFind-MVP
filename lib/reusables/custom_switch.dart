import 'package:flutter/material.dart';
import 'package:lost_items/utils/app_theme.dart';

class CustomSwitch extends StatefulWidget {
  final Function(bool value)? onChange;
  final Color? activeTrackColor;
  final bool isDisabled;
  final bool? value;

  const CustomSwitch(
      {super.key,
      this.onChange,
      this.activeTrackColor,
      this.value,
      this.isDisabled = false});

  @override
  State<CustomSwitch> createState() => _CustomSwitch();
}

class _CustomSwitch extends State<CustomSwitch> {
  bool isSwitched = false;

  @override
  void initState() {
    if (widget.value != null) {
      isSwitched = widget.value!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (widget.isDisabled) return;
        isSwitched = !isSwitched;

        setState(() {});
        if (widget.onChange != null) {
          widget.onChange!(isSwitched);
          //   bool? res = await widget.onChange!(isSwitched);
          //   if (res == false) {
          //     setState(() {
          //       isSwitched = res;
          //     });
          //   }
        }
      },
      child: Stack(children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          alignment: isSwitched ? Alignment.centerRight : Alignment.centerLeft,
          width: 40,
          padding: const EdgeInsets.all(2),
          decoration: ShapeDecoration(
              shape: const StadiumBorder(),
              color: isSwitched
                  ? widget.activeTrackColor ?? AppTheme.accentColor
                  : Colors.black.withOpacity(0.1)),
          child: Container(
            width: 20,
            height: 20,
            decoration: ShapeDecoration(shadows: [
              BoxShadow(
                  offset: const Offset(-1, 0),
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 3),
            ], shape: const CircleBorder(), color: AppTheme.primaryColor),
          ),
        ),
        // AnimatedPositionedDirectional(
        //   duration: const Duration(milliseconds: 400),
        //   end: 1,
        //   child:
        // )
      ]),
    );
  }
}
