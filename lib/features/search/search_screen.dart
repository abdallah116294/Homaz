import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/search_text_field.dart';
import 'package:homez/features/search/widgets/model_bottom_sheet.dart';

class SearchScreenViews extends StatefulWidget {
  const SearchScreenViews({super.key});

  @override
  State<SearchScreenViews> createState() => _SearchScreenViewsState();
}

class _SearchScreenViewsState extends State<SearchScreenViews> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: ColorManager.bgColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: size.width * .7,
                      color: ColorManager.bgColor,
                      child: const SearchTextField(
                        hint: "Search",
                      )),
                  Center(
                    child: IconButton(
                        onPressed: () {
                          ModalBottomSheet.searchFilter(context);
                        },
                        icon: const Icon(Icons.filter_alt_outlined)),
                  )
                ],
              ),
            ]),
          ),
        ));
  }
}
