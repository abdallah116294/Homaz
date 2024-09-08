import 'package:flutter/material.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/search_text_field.dart';
import 'package:homez/features/chat/widgets/person_item.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.bgColor,
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Messages", style: TextStyle(color: ColorManager.white)),
        backgroundColor: ColorManager.black,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_back_ios, color: ColorManager.white)),
      ),
      body:  SingleChildScrollView(
        child: Column(
          children: [
         const Padding(
            padding:  EdgeInsets.all(8.0),
            child:    SearchTextField(
               ),
          ),
            ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const ScrollPhysics(),
              separatorBuilder: (context, index) =>  Divider(color: ColorManager.grey10,),
              itemBuilder: (context, index) =>  
            const  PersonItem(),
              itemCount: 10,
           
            )
          ],
        ),
      ),
    );
  }
}
