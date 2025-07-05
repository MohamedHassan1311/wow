
import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import '../navigation/custom_navigation.dart';
import '../navigation/routes.dart';

class DeepLinksHalper {
  static DeepLinksHalper? _instance;

  DeepLinksHalper._internal();

  factory DeepLinksHalper() {
    _instance ??= DeepLinksHalper._internal();
    return _instance!;
  }



  final appLinks = AppLinks(); // AppLinks is singleton
  StreamSubscription<Uri>? _linkSubscription;

  Future<void> initDeepLinks() async {
    // Handle links


    _linkSubscription = AppLinks().uriLinkStream.listen((uri) {
      debugPrint('onAppLink: $uri');
      debugPrint('onAppLink: ${uri.queryParameters}');

      _handleDeepLink(uri.queryParameters);
    });

  }








  static void _handleDeepLink(Map? data) {
    if (data != null && data.containsKey("route")) {
      String? targetPage = data["route"];
      String? id = data["id"];
      Future.delayed(Duration(milliseconds:0), () {
 if (targetPage == Routes.register) {

          CustomNavigator.push(Routes.register,
              arguments: id ??"WOW");
        }
      });

    }
  }


}
