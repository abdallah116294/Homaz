import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/extensions/context.extensions.dart';
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
        title:  CustomText(text:'About Homz',color: ColorManager.white,fontSize: 16.sp,fontWeight: FontWeight.bold,),
        leading: IconButton(
          icon:  Icon(Icons.arrow_back,color: ColorManager.white,size: 24.sp,),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildExpansionTile(
              index: 0,
              title: 'What is Homz?',
              content:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
            ),
            _buildExpansionTile(
              index: 1,
              title: 'How can I subscribe to the channel?',
              content:
                  'You can subscribe to the Homz channel by clicking the subscribe button on the homepage.',
            ),
            _buildExpansionTile(
              index: 2,
              title: 'How can I follow the channel?',
              content:
                  'You can follow the Homz channel on various social media platforms by visiting our homepage.',
            ),
            _buildExpansionTile(
              index: 3,
              title: 'How do I delete my account?',
              content:
                  'To delete your account, go to Settings, and select the "Delete Account" option.',
            ),
            _buildExpansionTile(
              index: 4,
              title: 'How do I exit the app?',
              content:
                  'To exit the app, simply click the back button or use your device\'s home button to close the app.',
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