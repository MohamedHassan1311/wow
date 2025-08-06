import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../app/core/app_core.dart';
import '../../app/core/app_event.dart';
import '../../app/core/app_notification.dart';
import '../../app/core/dimensions.dart';
import '../../app/core/styles.dart';
import '../../app/core/svg_images.dart';
import '../../app/localization/language_constant.dart';
import '../../components/custom_alert_dialog.dart';
import '../../components/custom_app_bar.dart';
import '../../data/config/di.dart';
import '../../navigation/custom_navigation.dart';
import '../../navigation/routes.dart';
import '../profile/bloc/profile_bloc.dart';
import '../profile_details/widgets/maridge_request_dialog.dart';

class PaymentPage extends StatefulWidget {
  final String url;

  const PaymentPage({super.key, required this.url});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isLoading = true;
  late WebViewController controller;
  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(NavigationDelegate(
            onPageStarted: (String url) {
              isLoading = true;
              setState(() {});
            },
            onPageFinished: (String url) {
              isLoading = false;
              evaluateJavaScript();
              setState(() {});
            },
            // onUrlChange: (url) => evaluateJavaScript()
      ),

      )
      ..loadRequest(Uri.parse(widget.url));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated("payment"),
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: controller,
          ),
          if (isLoading)
            Column(
              children: [
                Expanded(
                    child: Container(
                        color: Styles.WHITE_COLOR,
                        child: const Center(
                            child: CircularProgressIndicator(
                          color: Styles.PRIMARY_COLOR,
                        )))),
              ],
            ),
        ],
      ),
    );
  }

  void evaluateJavaScript() async {
    // Execute JavaScript code within the WebView
    String? result = (await controller.platform
        .runJavaScriptReturningResult('document.body.innerHTML')) as String?;
    log("======>result: $result");
    // Process the JavaScript response
    if (result != null && result.contains('Payment Success')) {

      Future.delayed(const Duration(seconds: 1), () async {
        sl<ProfileBloc>().add(Get());

        await CustomAlertDialog.show(
            dailog: AlertDialog(
                contentPadding: EdgeInsets.symmetric(
                    vertical: Dimensions.PADDING_SIZE_DEFAULT.w,
                    horizontal:
                    Dimensions.PADDING_SIZE_DEFAULT.w),
                insetPadding: EdgeInsets.symmetric(
                  vertical:
                  Dimensions.PADDING_SIZE_EXTRA_LARGE.w,
                  horizontal:  Dimensions.PADDING_SIZE_EXTRA_LARGE.w,),
                shape: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Colors.transparent),
                    borderRadius: BorderRadius.circular(20.0)),


                content: MaridgeRequestDialog(
                  name: getTranslated("paid_successfully"),
                  discription:
                  getTranslated("paid_successfully_des"),
                  image: SvgImages.shieldDone,
                  showBackButton:false,
                  confirmButtonText:    getTranslated("wallet"),

                )));

        CustomNavigator.push(Routes.wallet,clean: true);      });
    }

    if (result != null && result.contains('Payment Fail')) {
      AppCore.showSnackBar(
          notification: AppNotification(
              message: getTranslated("retry_desc"),
              isFloating: true,
              backgroundColor: Styles.IN_ACTIVE,
              borderColor: Colors.red));
      Future.delayed(const Duration(seconds: 1), () {
        CustomNavigator.pop();
      });
    }
  }
}
