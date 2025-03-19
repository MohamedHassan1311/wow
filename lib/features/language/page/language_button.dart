import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/svg_images.dart';
import '../../../app/core/text_styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/custom_images.dart';
import '../../language/bloc/language_bloc.dart';

class LanguageButton extends StatefulWidget {
  final bool fromWelcome;
  const LanguageButton({super.key, this.fromWelcome = false});

  @override
  State<LanguageButton> createState() => _LanguageButtonState();
}

class _LanguageButtonState extends State<LanguageButton> {
  @override
  void initState() {
    LanguageBloc.instance.add(Init());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, AppState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Styles.FILL_COLOR))),
          padding: EdgeInsets.symmetric(
              vertical: Dimensions.PADDING_SIZE_SMALL.h,
              horizontal: Dimensions.PADDING_SIZE_SMALL.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              customContainerSvgIcon(
                backGround: Styles.WHITE_COLOR,
                color: Styles.PRIMARY_COLOR,
                withShadow: true,
                width: 40.w,
                height: 40.w,
                radius: 16.w,
                padding: 10.w,
                imageName: SvgImages.language,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(getTranslated("language", context: context),
                      maxLines: 1,
                      style: AppTextStyles.w500.copyWith(
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                          color: Styles.SUBTITLE)),
                ),
              ),

              ///Toggle Buttons
              StreamBuilder<int>(
                  stream: LanguageBloc.instance.selectIndexStream,
                  builder: (context, snapshot) {
                    return ToggleButtons(
                      direction: Axis.horizontal,
                      isSelected: [
                        (snapshot.data ?? 0) == 0,
                        (snapshot.data ?? 0) == 1,
                      ],
                      onPressed: (index) {
                        LanguageBloc.instance.updateSelectIndex(index);
                        LanguageBloc.instance.add(Update());
                      },
                      borderRadius: BorderRadius.circular(8.w),
                      selectedBorderColor: Styles.PRIMARY_COLOR,
                      selectedColor: Styles.WHITE_COLOR,
                      fillColor: Styles.PRIMARY_COLOR,
                      color: Styles.PRIMARY_COLOR,
                      borderColor: Styles.PRIMARY_COLOR,
                      constraints: BoxConstraints(
                        minHeight: 30.w,
                        minWidth: 40.w,
                      ),
                      children: [
                        Text(
                          getTranslated("en"),
                          style: AppTextStyles.w400.copyWith(fontSize: 14),
                        ),
                        Text(
                          getTranslated("ar"),
                          style: AppTextStyles.w400.copyWith(fontSize: 14),
                        ),
                      ],
                    );
                  }),
            ],
          ),
        );
      },
    );
  }
}
