import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/config/pusher_service/pusher_service.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/circle_image.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/features/chat/cubit/chat_cubit.dart';
import 'package:homez/features/chat/data/models/display_chat.dart';
import 'package:homez/features/chat/data/models/pusher_event_model.dart';
import 'package:homez/features/chat/widgets/recive_message_itme_widget.dart';
import 'package:homez/features/chat/widgets/send_message_widget.dart';
import 'package:homez/features/chat/widgets/sender_message_item.dart';
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
      Message message = Message.fromJson(
          decodedData); 
      displayChat!.data!.chat!.messages.insert(0, message);
      log("Messages: $message");
      setState(() {});
      animateListToStart();
    } else {
      throw Exception('Event data is null');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                centerTitle: true,
                actions: [
                  CircleImageWidget(
                    image: widget.imageUrl,
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
                        return SenderMsgItemWidget(
                          message: displayChat!.data!.chat!.messages[index],
                        );
                      } else {
                        return ReceiverMsgItemWidget(
                            message:displayChat!.data!.chat!.messages[index]);
                      }
                    },
                  )),
                   SendMessageWidget(
                    roomId:widget.roomId ,
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
