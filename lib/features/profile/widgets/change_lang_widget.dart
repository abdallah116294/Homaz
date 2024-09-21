import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homez/core/helpers/cache_helper.dart';
import 'package:homez/core/helpers/navigator.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/features/app/cubit/app_cubit.dart';
class ChangeLangWidget extends StatefulWidget {
  const ChangeLangWidget({super.key});

  @override
  State<ChangeLangWidget> createState() => _ChangeLangWidgetState();
}

class _ChangeLangWidgetState extends State<ChangeLangWidget> {
  bool isArabicSelected = false;
  @override
  void initState() {
    super.initState();
    final langCode = CacheHelper.get(key: "selected_language");
    isArabicSelected = langCode == 'ar'; 
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: Scaffold(  
        backgroundColor: ColorManager.bgColor,  
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<AppCubit>().toggleLanguage();
                    setState(() {
                      isArabicSelected = false; // Set to English
                      // Change to English
                    });
                     MagicRouter.navigatePop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isArabicSelected
                        ? Colors.grey
                        : Colors.blue, // Color based on selection
                  ),
                  child:const  Text('English'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    context.read<AppCubit>().toggleLanguage();
                    setState(() {
                      isArabicSelected = true; // Set to Arabic
                      // _changeLanguage(Locale('ar', '')); // Change to Arabic
                    });
                    MagicRouter.navigatePop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isArabicSelected
                        ? Colors.blue
                        : Colors.grey, // Color based on selection
                  ),
                  child:const  Text('العربية'),
                ),
              ],
            )
                    ],
                  ),
          )),
    );
  }
}
