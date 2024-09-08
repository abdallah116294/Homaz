import 'package:flutter/material.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_text.dart';

class PersonItem extends StatelessWidget {
  const PersonItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomText(
                  text: 'Jaesica ',
                  color: ColorManager.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
              const Spacer(),
              CustomText(
                  text:
                      "${DateTime.now().hour.toString()} : ${DateTime.now().minute.toString()}",
                  color: ColorManager.grey6,
                  fontWeight: FontWeight.w300,
                  fontSize: 13),
            ],
          ),
          CustomText(
              text: 'Sea you ',
              color: ColorManager.grey6,
              fontWeight: FontWeight.w300,
              fontSize: 13)
        ],
      ),
      leading: const CircleAvatar(
        foregroundImage: const AssetImage(AssetsStrings.splashBg),
        radius: 30,
      ),
    );
  }
}
