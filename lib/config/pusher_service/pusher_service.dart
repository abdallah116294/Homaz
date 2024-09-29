import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:homez/core/helpers/cache_helper.dart';
import 'package:homez/core/networking/api_constants.dart';
import 'package:homez/core/networking/api_consumer.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
 import 'package:http/http.dart' as http;
class PusherConfig {
  late PusherChannelsFlutter _pusher;
   ApiConsumer? apiConsumer;
  String PUSHER_APP_ID = "1867037";
  String PUSHER_APP_KEY = "aa799f3a644aa324fad1";
  String PUSHER_APP_SECRET = "d88a67dc005883f2ebd6";
  String PUSHER_APP_CLUSTER = "mt1"; 

  Future<void> initPusher(onEvent, {String channelName = "chat", String? roomId}) async {
    _pusher = PusherChannelsFlutter.getInstance();
    try {
      await _pusher.init(
        apiKey: PUSHER_APP_KEY,
        cluster: PUSHER_APP_CLUSTER,
        onConnectionStateChange: onConnectionStateChange,
        onError: onError,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onEvent: onEvent,
        onSubscriptionError: onSubscriptionError,
        onDecryptionFailure: onDecryptionFailure,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved,
        authEndpoint:"https://homez.azsystems.tech/api/chat/pusher/auth" ,
        onAuthorizer: onAuthorizer,
      );

      if (roomId == null) {
        log("roomId is null. Please provide a valid roomId.");
        return;
      }

      try {
        await _pusher.subscribe(
          channelName: "$channelName.$roomId",
        );
        log("Trying to subscribe to: $channelName.$roomId");
      } catch (e) {
        log("Subscription error: ${e.toString()}");
      }

      await _pusher.connect();
    } catch (e) {
      log("Error in initialization: ${e.toString()}");
    }
  }
    void disconnect() {
    _pusher.disconnect();
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    log("Connection: $currentState");
  }

  void onError(String message, int? code, dynamic e) {
    log("onError: $message code: $code exception: $e");
  }

  void onEvent(PusherEvent event) {
    log("onEvent: $event");
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    log("onSubscriptionSucceeded: $channelName data: $data");
    final me = _pusher.getChannel(channelName)?.me;
    log("Me: $me");
  }

  void onSubscriptionError(String message, dynamic e) {
    log("onSubscriptionError: $message Exception: $e");
  }

  void onDecryptionFailure(String event, String reason) {
    log("onDecryptionFailure: $event reason: $reason");
  }

  void onMemberAdded(String channelName, PusherMember member) {
    log("onMemberAdded: $channelName user: $member");
  }

  void onMemberRemoved(String channelName, PusherMember member) {
    log("onMemberRemoved: $channelName user: $member");
  }

  void onSubscriptionCount(String channelName, int subscriptionCount) {
    log("onSubscriptionCount: $channelName subscriptionCount: $subscriptionCount");
  }
  dynamic onAuthorizer(
      String channelName, String socketId, dynamic options) async {
    var token =  CacheHelper.getToken();
    var authUrl = "https://homez.azsystems.tech/api/chat/pusher/auth";
    var result = await http.post(
      Uri.parse(authUrl),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token',
      },
      body: 'socket_id=' + socketId + '&channel_name=' + channelName,
    );
    var json = jsonDecode(result.body);
    return json;
  }
  //New
//    dynamic onAuthorizer(String channelName, String socketId, dynamic options) async {
//    log("Socket ID: $socketId");
//    var jsonResponse;
//    try {
//       var authUrl = "https://homez.azsystems.tech/api/chat/pusher/auth";
//       var response = await http.post(
//          Uri.parse(authUrl),
//          headers: {
//             'Content-Type': 'application/x-www-form-urlencoded',
//             'Authorization': 'Bearer ${CacheHelper.getToken()}',
//          },
//          body: 'socket_id=$socketId&channel_name=$channelName',
//       );
      
//       log("Auth Response: ${response.body}");
//       jsonResponse = jsonDecode(response.body);

//       if (response.statusCode == 200 && jsonResponse != null && jsonResponse['auth'] != null) {
//          log("Authentication Successful: ${jsonResponse['auth']}");
//          return jsonResponse;  // Return the auth signature
//       } else {
//          log("Authentication failed, response: ${response.body}");
//          return null;  // Fail if there's no 'auth' key or invalid response
//       }
//    } catch (error) {
//       log("Error in authorization: ${error.toString()}");
//       return null;  // Return null in case of failure
//    }
// }


}