import 'package:flutter/material.dart';
import 'package:homez/features/appartment_details/screen/apartment_details_after_take_look.dart';
import 'package:homez/features/appartment_details/screen/apartment_details_on_click.dart';
import 'package:homez/features/take_look/data/model/take_look_model.dart';
class ApartmentDetailsScreen extends StatelessWidget {
  ApartmentDetailsScreen({super.key, this.takeLookData, this.apartmentId});
  TakeLookData? takeLookData;
  int? apartmentId;
  @override
  Widget build(BuildContext context) {
    return takeLookData != null
        ? ApartmentDetailsAfterTakeLook(takeLookData: takeLookData!)
        : ApartmentDetailsOnClick(apartmentId: apartmentId!);
  }
}
