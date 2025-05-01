import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/core/dimensions.dart';
import '../../../../app/core/images.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/text_styles.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/custom_images.dart';
import '../bloc/complete_profile_bloc.dart';

class CompleteProfileHeader extends StatelessWidget {

  const CompleteProfileHeader({super.key, });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder<int?>(
          stream:context.read<CompleteProfileBloc>().currentStepStream,
          builder: (context, snapshot) {
            return Column(
              children: [
                LinearProgressIndicator(value: (snapshot.data??1)/5,backgroundColor: Styles.GREY_BORDER,),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      getTranslated(context.read<CompleteProfileBloc>().stepTitle(snapshot.data)),
                      style: AppTextStyles.w700
                          .copyWith(fontSize: 24, color: Styles.HEADER),
                    ),
                  ],
                ),
              ],
            );
          }
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_LARGE.h),

      ],
    );
  }
}
