import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/helpers/date_converter.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/theming/constants.dart';
import 'package:homez/core/widgets/cached_network_image.dart';
import 'package:homez/core/widgets/circle_image.dart';
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
            ? const CircleAvatar(
                backgroundImage: AssetImage('assets/images/user.png'),
                radius: 20,
              )
            : CachedImageWidget(
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
              SizedBox(
                height: 6.h,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                width: Sizes.getWidth(context),
                decoration: const BoxDecoration(
                  //rgba(24, 26, 35, 1)
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
                          if (message.messageContent!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                message.message.toString(),
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
                                  const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                return CachedImageWidget(
                                  imgUrl:
                                      message.attachments[index].url.toString(),
                                  height: Sizes.getHeight(context) * 0.2,
                                  width: 120,
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
              const SizedBox(height: 6),
              Text(
                DateConverter.getTimeString(message.createdAt.toString()),
                style: TextStyle(
                    fontSize: 14,
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
