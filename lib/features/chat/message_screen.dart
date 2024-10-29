import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homez/config/pusher_service/pusher_service.dart';
import 'package:homez/config/routes/app_routes.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/localization/lang_keys.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/search_text_field.dart';
import 'package:homez/core/widgets/search_text_field_without_filter.dart';
import 'package:homez/features/app/cubit/app_cubit.dart';
import 'package:homez/features/chat/cubit/chat_cubit.dart';
import 'package:homez/features/chat/data/models/chats_model.dart';
import 'package:homez/features/chat/widgets/person_item.dart';
import 'package:homez/injection_container.dart' as di;
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> with AutomaticKeepAliveClientMixin{
  ///ScrollController scrollController = ScrollController();
  late PusherConfig pusherConfig;
  ChatsModel? chatsModel;
  initilizeRoom(roomId) {
    pusherConfig = PusherConfig();
    pusherConfig.initPusher(
      onEvent,
      roomId: roomId,
    );
  }

  // animateListToTheEnd({int time = 500}) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     scrollController.animateTo(
  //       scrollController.position.maxScrollExtent,
  //       duration: Duration(milliseconds: time),
  //       curve: Curves.easeInOut,
  //     );
  //   });
  // }

  void onEvent(PusherEvent event) {
    log("Full Event data:${event.data}");
    log("event came: " + event.data.toString());
    try {
      log(event.eventName.toString());
      if (event.eventName == r"MessageSent") {
        final decodedData = jsonDecode(event.data);
        Data message = Data.fromJson(
            decodedData); // Adjust this based on your actual data structure
        log("Messages: $message");
      }

      setState(() {});
      //animateListToTheEnd();
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => di.sl<ChatCubit>()..getChats(),
      child: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state is GetChatsSuccessState) {
            chatsModel = state.chatsModel;
           // initilizeRoom(chatsModel!.data!.chats!.data[0].chatId.toString());
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: ColorManager.bgColor,
            appBar: AppBar(
              elevation: 0.0,
              title:
                  Text(context.translate(LangKeys.message), style: TextStyle(color: ColorManager.white)),
              backgroundColor: ColorManager.black,
              centerTitle: true,
              leading: Align(
                alignment: context.read<AppCubit>().getAlignment(),
                child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.arrow_back_ios, color: ColorManager.white)),
              ),
            ),
            body: state is GetChatsSuccessState
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                         Padding(
                          padding:const  EdgeInsets.all(8.0),
                          child: SearchTextFieldWithoutFilter(
                            hint:context.translate(LangKeys.search) ,
                          ),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: const ScrollPhysics(),
                          separatorBuilder: (context, index) => Divider(
                            color: ColorManager.grey10,
                          ),
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              context.pushName(AppRoutes.chatScreen,arguments: {
                                'chatName':state.chatsModel.data!.chats!.data[index].aparmentName.toString(),
                                'imageUrl':state.chatsModel.data!.chats!.data[index].aparmentImage.toString(),
                                'roomId':state.chatsModel.data!.chats!.data[index].chatId,
                              });
                            },
                            child: PersonItem(
                              data:state.chatsModel.data!.chats!
                                  .data[index],
                            ),
                          ),
                          itemCount: state.chatsModel.data!.chats!.data.length,
                        )
                      ],
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          );
        },
      ),
    );
  }
  
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
