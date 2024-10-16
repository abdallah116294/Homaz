import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/circle_image.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/features/chat/data/models/chats_model.dart';
class PersonItem extends StatelessWidget {
  const PersonItem({super.key, 
  // required this.name, required this.imageUrl, required this.lastMessage, required this.time, required this.unreadCount
  required this.data});
  // final String name;
  // final String imageUrl;
  // final String lastMessage;
  // final String time;
  // final int unreadCount;
  final  Datum data;

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
                  text: data.aparmentName!.split(' ')
                                          .take(2)
                                          .join(' ')
                                          .toString(),
                  color: ColorManager.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,),
                 Spacer(),
                 
             data.lastMessageTime!=null? CustomText(
                  text:
                      data.lastMessageTime??"",
                  color: ColorManager.grey6,
                  fontWeight: FontWeight.w300,
                  fontSize: 13.sp):SizedBox()
            ],
          ),
          CustomText(
              text: data.lastMessage!,
              color: ColorManager.grey6,
              fontWeight: FontWeight.w300,
              fontSize: 13.sp)
        ],
      ),
      leading:  CircleAvatar(
        foregroundImage:  NetworkImage(data.aparmentImage!),
        radius: 30.r,
      ),
    );
  }
}
