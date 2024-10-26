import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/config/pusher_service/pusher_service.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/helpers/main_services.dart';
import 'package:homez/core/localization/lang_keys.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/circle_image.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/svg_icons.dart';
import 'package:homez/features/chat/cubit/chat_cubit.dart';
import 'package:homez/features/chat/data/models/display_chat.dart';
import 'package:homez/features/chat/data/models/pusher_event_model.dart';
import 'package:homez/features/chat/widgets/massage_text_formfield_with_image.dart';
import 'package:homez/features/chat/widgets/sender_message_itme_widget.dart';
import 'package:homez/features/chat/widgets/send_message_widget.dart';
import 'package:homez/features/chat/widgets/receiver_message_item.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:homez/injection_container.dart' as di;

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {super.key,
      required this.imageUrl,
      required this.chatName,
      required this.roomId});
  final String imageUrl, chatName;
  final int roomId;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late PusherConfig pusherConfig;
  ScrollController scrollController = ScrollController();
  DisplayChat? displayChat;
  initilizeRoom(roomId) {
    pusherConfig = PusherConfig();
    pusherConfig.initPusher(
      onEvent,
      roomId: roomId,
    );
  }

  animateListToTheEnd({int time = 500}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: time),
        curve: Curves.easeInOut,
      );
    });
  }

  animateListToStart({int time = 500}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: time),
        curve: Curves.easeInOut,
      );
    });
  }

  void onEvent(PusherEvent event) {
    log("Full Event data:${event.data}");
    log("event came: ${event.data}");
    if (event.data != null) {
      final decodedData = jsonDecode(event.data);
      Message message = Message.fromJson(decodedData);
      if (message.attachments.isNotEmpty) {
        displayChat!.data!.chat!.messages.insert(0, message);
      } else {
        displayChat!.data!.chat!.messages.insert(0, message);
      }
      // displayChat!.data!.chat!.messages.insert(0, message);
      log("Messages: $message");
      setState(() {});
      animateListToStart();
    } else {
      throw Exception('Event data is null');
    }
  }

  List<File>? currentSelectedImage;
  TextEditingController messageController = TextEditingController();
  // late ChatCubit chatCubit;
  @override
  void initState() {
    // chatCubit = ChatCubit.get(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var chatCubit = ChatCubit.get(context);
    return BlocProvider(
      create: (context) =>
          di.sl<ChatCubit>()..displayChat(chatId: widget.roomId),
      child: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state is DisplayChatErrorState) {
            log(state.error);
          } else if (state is DisplayChatLoading) {
            log("loading");
          } else if (state is DisplayChatSuccessState) {
            log(state.displayChat.status.toString());
            displayChat = state.displayChat;
            initilizeRoom(widget.roomId.toString());
            animateListToStart();
          }
        },
        builder: (context, state) {
          if (displayChat == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Scaffold(
              backgroundColor: ColorManager.bgColor,
              appBar: AppBar(
                backgroundColor: ColorManager.black,
                elevation: 0.0,
                // centerTitle: true,
                actions: [
                  CircleImageWidget(
                    image: widget.imageUrl,
                    size: 50,
                  ),
                ],
                title: CustomText(
                  color: ColorManager.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  text: widget.chatName,
                ),
                leading: IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: ColorManager.white,
                    )),
              ),
              body: Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                    controller: scrollController,
                    reverse: true,
                    itemCount: displayChat!.data!.chat!.messages.length,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 30),
                    itemBuilder: (context, index) {
                      if (displayChat!.data!.chat!.messages[index].senderName ==
                          "superAdmin") {
                        return ReceiverMsgItemWidget(
                          message: displayChat!.data!.chat!.messages[index],
                          imageUrl: widget.imageUrl,
                        );
                      } else {
                        return SenderMsgItemWidget(
                            message: displayChat!.data!.chat!.messages[index]);
                      }
                    },
                  )),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CustomTextFormField(
                      textFormField: TextFormField(
                        minLines: 1,
                        maxLines: 6,
                        textAlign: TextAlign.start,
                        controller: messageController,
                        style: TextStyle(
                            color: ColorManager.white, fontSize: 16.sp),
                        decoration: InputDecoration(
                            hintText: context.translate(LangKeys.type_your_message),
                            hintStyle: TextStyle(
                                color: ColorManager.grey15, fontSize: 16.sp),
                            focusColor: ColorManager.mainColor),
                      ),
                      images: currentSelectedImage != null
                          ? List.generate(
                              currentSelectedImage!.length,
                              (index) => currentSelectedImage![index],
                            )
                          : [],
                      imageButton: GestureDetector(
                        onTap: () async {
                          // Handle image button press
                          currentSelectedImage = (await MainServices
                              .getListImagesUsingImagePicker())!;
                          if (currentSelectedImage != null) {
                            setState(() {});
                          }
                        },
                        child: SvgIcon(
                            icon: "assets/icons/image-upload.svg",
                            color: ColorManager.white,
                            height: 30.h),
                      ),
                      sendButton: GestureDetector(
                          onTap: () async {
                            if (currentSelectedImage != null) {
                              chatCubit.sendMessage(
                                  message: messageController.text,
                                  attachment: currentSelectedImage,
                                  chatId: widget.roomId);
                            }
                            if (messageController.text.isNotEmpty &&
                                currentSelectedImage == null) {
                              chatCubit.sendMessage(
                                  message: messageController.text,
                                  chatId: widget.roomId);
                              messageController.clear();
                              currentSelectedImage = null;
                              setState(() {});
                            }
                          },
                          child: Container(
                            height: 50.h,
                            width: 48.w,
                            decoration: BoxDecoration(
                              color: ColorManager.mainColor,
                              shape: BoxShape.circle,
                              // borderRadius: BorderRadius.circular(40.r),
                            ),
                            child: Center(
                              child: SvgIcon(
                                  height: 30.h,
                                  icon: "assets/icons/send_button_white.svg",
                                  color: ColorManager.white),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
