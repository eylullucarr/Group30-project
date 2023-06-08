import 'package:flutter/material.dart';
import 'package:insulin_calculate/core/util/color.dart';

class MainButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function()? onTap;
  final bool large;
  const MainButton(
      {super.key,
      required this.icon,
      required this.text,
      required this.onTap,
      required this.large});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: large ? size.width * 0.40 : size.width * 0.35,
        height: large ? size.height * 0.07 : size.height * 0.05,
        decoration: BoxDecoration(
          color: ColorUtility.lightCarminePink,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            const Spacer(
              flex: 2,
            ),
            Icon(
              icon,
              color: Colors.white,
            ),
            const Spacer(),
            Text(text,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500)),
            const Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}
