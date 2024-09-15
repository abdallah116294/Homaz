import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/features/profile/widgets/change_lang_widget.dart';

class ModalBottomSheet {
  static void changeLangueBottomSheet(
    BuildContext context,
  ) {
    showModalBottomSheet(
        //   barrierColor: Colors.black.withAlpha(1),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        isDismissible: false,
        enableDrag: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                  decoration: BoxDecoration(
                    color: ColorManager.bgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: 428.w,
                  height: 400.h,
                  padding: const EdgeInsets.all(20),
                  child: ChangeLangWidget()
                  ),
            ),
          );
        });
  }
}