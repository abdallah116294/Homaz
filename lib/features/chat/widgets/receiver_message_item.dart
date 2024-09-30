import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/helpers/date_converter.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/theming/constants.dart';
import 'package:homez/core/widgets/cached_network_image.dart';
import 'package:homez/core/widgets/circle_image.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/features/chat/data/models/display_chat.dart';

class ReceiverMsgItemWidget extends StatelessWidget {
  ReceiverMsgItemWidget({super.key, required this.message, this.imageUrl});

  final Message message;
  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // CustomText(text: message.message.toString(), color: ColorManager.white, fontWeight: FontWeight.bold, fontSize: 16.sp),
               SizedBox(height: 6.h),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                width: Sizes.getWidth(context),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(24, 26, 35, 1),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                    topLeft: Radius.circular(8),
                  ),
                ),
                child: message.attachments.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (message.message!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                message.messageContent.toString(),
                                style:  TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          SizedBox(
                            height: Sizes.getHeight(context) * 0.2,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: message.attachments.length,
                              separatorBuilder: (context, index) =>
                                   SizedBox(width: 8.w),
                              itemBuilder: (context, index) {
                                return CachedImageWidget(
                                  imgUrl:
                                      message.attachments[index].url.toString(),
                                  height: Sizes.getHeight(context) * 0.2,
                                  width: 120.w,
                                  fit: BoxFit.fill,
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    : Text(
                        message.messageContent.toString(),
                        style:  TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
              ),
               SizedBox(
                height: 6.h,
              ),
              Text(
                DateConverter.getTimeString(message.createdAt.toString()),
                style:  TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
               SizedBox(height: 20.h),
            ],
          ),
        ),
         SizedBox(width: 8.w),
        message.senderImage == ""
            ? CachedImageWidget(
                imgUrl: imageUrl!,
                radius: 150.r,
                height: 40.h,
                width: 40.w,
              )
            : CachedImageWidget(
                imgUrl: message.senderImage!..toString(),
                radius: 150.r,
                height: 40.h,
                width: 40.w,
              ),
      ],
    );
  }
}
