import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/localization/lang_keys.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/svg_icons.dart';

class AboutHomzPage extends StatefulWidget {
  const AboutHomzPage({super.key});

  @override
  State<AboutHomzPage> createState() => _AboutHomzPageState();
}

class _AboutHomzPageState extends State<AboutHomzPage> {
   List<bool> _isExpandedList = [false, false, false, false, false];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.bgColor,
        title:  CustomText(text:'${context.translate(LangKeys.about)} Homz',color: ColorManager.white,fontSize: 16.sp,fontWeight: FontWeight.bold,),
        leading: IconButton(
          icon:  Icon(Icons.arrow_back_ios,color: ColorManager.white,size: 24.sp,),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildExpansionTile(
              index: 0,
              title: context.translate(LangKeys.what_about),
              content:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
            ),
            _buildExpansionTile(
              index: 1,
              title: context.translate(LangKeys.how_can_subscribe),
              content:
                  context.translate(LangKeys.can_subscribe),
            ),
            _buildExpansionTile(
              index: 2,
              title: context.translate(LangKeys.how_can_follow),
              content:
                  context.translate(LangKeys.you_can_follow),
            ),
            _buildExpansionTile(
              index: 3,
              title: context.translate(LangKeys.how_do_delete),
              content:
                  context.translate(LangKeys.to_delete),
            ),
            _buildExpansionTile(
              index: 4,
              title: context.translate(LangKeys.how_exit_app),
              content:
                  context.translate(LangKeys.extit_app),
            ),
          ],
        ),
      ),
      backgroundColor:ColorManager.bgColor, 
    );
  }

  Widget _buildExpansionTile({required String title, required String content,required int index,}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
         decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60.0.r), 
          border: Border.all( 
            width: 2.0.w, 
          ),
        ),
        child: ExpansionTile(
          trailing:_isExpandedList[index]?SvgIcon(icon: 'assets/icons/arrow_drop_up.svg', color: ColorManager.mainColor): SvgIcon(icon: 'assets/icons/trailing.svg', color: ColorManager.mainColor),
          onExpansionChanged: (bool expanded){
            setState(() {
              _isExpandedList[index]=expanded;
            });
          },
          collapsedBackgroundColor: Colors.grey[850], 
          backgroundColor: Colors.grey[850], 
          title: Text(
            title,
            style:  TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize:16.sp
            ),
          ),
          iconColor: ColorManager.mainColor, 
          collapsedIconColor:  ColorManager.mainColor,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                content,
                style:  TextStyle(
                  color: Colors.white70, 
                  fontSize:16.sp
                ),
              ),
            ),
          ], 
        ),
      ),
    );
  }
}