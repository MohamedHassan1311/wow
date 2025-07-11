import 'package:wow/main_widgets/guest_mode.dart';
import 'package:flutter/material.dart';

import '../../app/localization/language_constant.dart';
import '../../components/custom_app_bar.dart';

class GuestModeView extends StatelessWidget {
  const GuestModeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(child: GuestMode()),
          ),
        ],
      ),
    );
  }
}
