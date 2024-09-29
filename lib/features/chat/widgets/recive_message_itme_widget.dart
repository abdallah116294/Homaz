import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/helpers/date_converter.dart';
import 'package:homez/core/theming/constants.dart';
import 'package:homez/core/widgets/cached_network_image.dart';
import 'package:homez/core/widgets/circle_image.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/features/chat/data/models/display_chat.dart';

class ReceiverMsgItemWidget extends StatelessWidget {
  final Message message;
  const ReceiverMsgItemWidget(
      {super.key, required this.message,});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CachedImageWidget(
          imgUrl: message.senderImage!.toString(),
          radius: 100,
          height: 40,
          width: 40,
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             // CustomText(text: message.message.toString(), color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.sp),
              SizedBox(height: 6.h,),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                width: Sizes.getWidth(context),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child:message.attachmentUrl!=null? CachedImageWidget(
                  imgUrl: message.attachmentUrl.toString(),
                  height: Sizes.getHeight(context) * 0.2,
                  width: 30,
                  fit: BoxFit.fill,
                ): Text(
                  message.messageContent.toString(),
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                DateConverter.getTimeString(message.createdAt.toString()),
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}
