import 'package:flutter/material.dart';
import 'package:wow/app/core/app_event.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/images.dart';
import 'package:wow/app/core/styles.dart';
import 'package:wow/app/core/svg_images.dart';
import 'package:wow/app/core/text_styles.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/components/custom_alert_dialog.dart';
import 'package:wow/components/custom_network_image.dart';
import 'package:wow/features/profile_details/widgets/details_row.dart';
import 'package:wow/features/profile_details/widgets/maridge_request_dialog.dart';
import 'package:wow/main_blocs/user_bloc.dart';
import 'package:wow/main_models/user_model.dart';

import '../../../data/config/di.dart';
import '../bloc/guardian_request_bloc.dart';
import '../repo/profile_details_repo.dart';

class PersonalInfoTap extends StatelessWidget {
  final UserModel user;
  const PersonalInfoTap({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.PADDING_SIZE_DEFAULT / 2,
          vertical: Dimensions.PADDING_SIZE_DEFAULT),
      child: ListView(
        children: [
          Row(
            children: [
              Text(
                '${user.nickname} , ${user.age}',
                style: AppTextStyles.w700
                    .copyWith(fontSize: 20, color: Styles.HEADER),
              ),
              if (user.isVerified == 1)
                Icon(Icons.verified, color: Colors.blue, size: 20),
              SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            user.personalInfo ?? '',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 24),
          Text(getTranslated("details", context: context),
              style: AppTextStyles.w700
                  .copyWith(fontSize: 16, color: Styles.HEADER)),
          const SizedBox(height: 12),
          DetailsRow(
              title: getTranslated("skin_color", context: context),
              value: user.skinColor?.name ?? ''),
          DetailsRow(
              title: getTranslated("weight", context: context),
              value: user.weight.toString() ?? ''),
          DetailsRow(
              title: getTranslated("height", context: context),
              value: user.height.toString() ?? ''),
          DetailsRow(
              title: getTranslated("body_type", context: context),
              value: user.bodyType?.name ?? ''),
          DetailsRow(
              title: getTranslated("social_status", context: context),
              value: user.socialStatus?.name ?? ''),
          const SizedBox(height: 24),




          ///
          ///
          /// guardian info
      Visibility(
        visible: user.gender == "F"&& user.can_view_guardian_info!,
        child: Column(children: [
          DetailsRow(
              title: getTranslated("Guardian's data", context: context),
              value: ''),

          DetailsRow(
              title: "${getTranslated("name")}", value: user.glName ?? ''),

          DetailsRow(
              title: "${getTranslated("phone")}",
              value: user.gPhoneNumber ?? ''),
          DetailsRow(
              title: "${getTranslated("kinship")}",
              value: user.grelation ?? ''),
        ],),
      ),

          Visibility(
            visible: user.gender == "F"&& user.can_view_guardian_info!,
            child: InkWell(
              onTap: () async {
                final result = await CustomAlertDialog.show(
                    dailog: AlertDialog(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: Dimensions.PADDING_SIZE_DEFAULT.w,
                            horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                        insetPadding: EdgeInsets.symmetric(
                            vertical: Dimensions.PADDING_SIZE_EXTRA_LARGE.w,
                            horizontal: context.width * 0.1),
                        shape: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(20.0)),
                        content: MaridgeRequestDialog(
                          name: getTranslated("MARIDGE_REQUEST_DATA"),
                          discription: getTranslated("marige_request_data_desc"),
                          image: SvgImages.ring,
                          note: getTranslated("not_refundable"),
                        )));
                if (result == true)
                  GuardianRequestBloc(
                    repo: sl.get<ProfileDetailsRepo>(),
                  ).add(Click());
              },
              child: Image.asset(
                Images.zwagcard,
                width: context.width,
                height: context.height * .25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
