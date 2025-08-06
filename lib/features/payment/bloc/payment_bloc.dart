import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyperpay_plugin/flutter_hyperpay.dart';
import 'package:hyperpay_plugin/model/ready_ui.dart';

import 'package:rxdart/rxdart.dart';

import '../../../app/core/InApp_PaymentSetting.dart';
import '../../../app/core/app_core.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/app_notification.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/app_strings.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';

import '../../../app/core/svg_images.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/custom_alert_dialog.dart';
import '../../../data/config/di.dart';
import '../../../data/error/failures.dart';
import '../../../navigation/custom_navigation.dart';
import '../../../navigation/routes.dart';
import '../../profile/bloc/profile_bloc.dart';
import '../../profile_details/widgets/maridge_request_dialog.dart';
import '../repo/payment_repo.dart';

class PaymentBloc extends Bloc<AppEvent, AppState> {
  final CheckOutRepo repo;
  PaymentBloc({required this.repo}) : super(Start()) {

    flutterHyperPay = FlutterHyperPay(
      shopperResultUrl: InAppPaymentSetting.shopperResultUrl,
      paymentMode: PaymentMode.live,
      lang: InAppPaymentSetting.getLang(),
    );
  }

  FlutterHyperPay? flutterHyperPay;
  payRequestNowReadyUI(
      {List<String>? brandsName, bool pop =true, required String checkoutlink}) async {
    CustomNavigator.push(Routes.payment,arguments:checkoutlink);

    // PaymentResultData paymentResultData;
    // paymentResultData = await flutterHyperPay!.readyUICards(
    //   readyUI: ReadyUI(
    //       brandsName: brandsName ?? ["VISA", "MASTER"],
    //       checkoutId: checkoutId,
    //       merchantIdApplePayIOS: InAppPaymentSetting.merchantId,
    //       countryCodeApplePayIOS: InAppPaymentSetting.countryCode,
    //       companyNameApplePayIOS: AppStrings.appName,
    //       themColorHexIOS: "#d2a777",
    //       setStorePaymentDetailsMode: false),
    // );
    // await checkStatus(checkoutId,pop);

  }
  Future<void> checkStatus(checkoutId,bool pop) async {
    try {
      Either<ServerFailure, Response> response = await repo.checkStatus(checkOutID: checkoutId);
      if(pop) {
        CustomNavigator.pop();
      }
      response.fold((fail) {
        sl<ProfileBloc>().add(Get());

        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.red));
      }, (success) async {
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

    CustomNavigator.push(Routes.wallet,replace: pop);

      });
    } catch (e) {
      AppCore.showSnackBar(
          notification: AppNotification(
        message: e.toString(),
        backgroundColor: Styles.IN_ACTIVE,
        borderColor: Styles.RED_COLOR,
      ));
    }
  }


}
