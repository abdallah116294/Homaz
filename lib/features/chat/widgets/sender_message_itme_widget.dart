import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/helpers/date_converter.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/theming/constants.dart';
import 'package:homez/core/widgets/cached_network_image.dart';
import 'package:homez/features/app/cubit/app_cubit.dart';
import 'package:homez/features/chat/data/models/display_chat.dart';

class SenderMsgItemWidget extends StatelessWidget {
  final Message message;
  const SenderMsgItemWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        message.senderImage == ""
            ?  CircleAvatar(
                backgroundImage: const AssetImage('assets/images/user.png'),
                radius: 20.r,
              )
            : CachedImageWidget(
                imgUrl: message.senderImage!.toString(),
                radius: 100.r,
                height: 40.h,
                width: 40.w,
              ),
         SizedBox(
          width: 8.w,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CustomText(text: message.message.toString(), color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.sp),
              SizedBox(
                height: 6.h,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                width: Sizes.getWidth(context),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(24, 26, 35, 1),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: message.attachments.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (message.message!=null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                message.message.toString()==null?"" :message.message.toString(),
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
               SizedBox(height: 6.h),
              Text(
                DateConverter.getTimeString(message.createdAt.toString()),
                style: TextStyle(
                    fontSize: 14.sp,
                    color: ColorManager.white,
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
