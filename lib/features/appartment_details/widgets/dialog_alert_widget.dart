import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_text.dart';

class CallModelBottomSheet {
  static void callAction(
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
                  height: 200.h,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        height: 56.h,
                        width: 343.w,
                        decoration: BoxDecoration(
                          color: ColorManager.callColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.phone,
                              color: ColorManager.white,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            CustomText(
                                text: 'Call +201144585024',
                                color: ColorManager.blueColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp)
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          height: 56.h,
                          width: 343.w,
                          decoration: BoxDecoration(
                            color: ColorManager.callColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                  text: 'Cancel',
                                  color: ColorManager.blueColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp)
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
            ),
          );
        });
  }
}
