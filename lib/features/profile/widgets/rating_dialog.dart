import 'package:flutter/material.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:rating_dialog/rating_dialog.dart';

class RatingAlertDialog {
  static final RatingDialog dialog = RatingDialog(
    showCloseButton: true,
    initialRating: 1.0,
    title:  Text(
      'Homz',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: ColorManager.white
      ),
    ),
    // encourage your user to leave a high rating?
    message:  Text(
      'Tap a star to set your rating. Add more description here if you want.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 15,color:ColorManager.white),
    ),
    // your app's logo?
    image: Image.asset(
      "assets/images/app_production_icon.png",
      height: 100,
      width: 100,
    ),
    submitButtonText: 'Submit',
    commentHint: 'Set your custom comment hint',
    submitButtonTextStyle: TextStyle(
      color: ColorManager.white,
    ),
    onCancelled: () => print('cancelled'),
    onSubmitted: (response) {
      print('rating: ${response.rating}, comment: ${response.comment}');

      // TODO: add your own logic
      if (response.rating < 3.0) {
        // send their comments to your email or anywhere you wish
        // ask the user to contact you instead of leaving a bad review
      } else {
        _launchUrl();
      }
    },
  );
  static Future _launchUrl() async {
    // final Uri _url = Uri.parse(url+packageName);
    // if (!await launchUrl(_url)) {
    //   throw Exception('Could not launch $_url');
    // }
  }
}
