import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/app_core.dart';
import 'package:wow/app/core/app_event.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/styles.dart';
import 'package:wow/app/core/svg_images.dart';
import 'package:wow/app/core/text_styles.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/components/custom_images.dart';
import 'package:wow/data/config/di.dart';
import 'package:wow/features/plans/bloc/plan_bloc.dart';
import 'package:wow/features/plans/model/plans_model.dart';
import 'package:wow/main_models/config_model.dart';

class PalnCard extends StatelessWidget {
  final PlanData plan;
  const PalnCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanBloc, AppState>(
      builder: (context, state) {
        return StreamBuilder<PlanData>(
          stream: context.read<PlanBloc>().selectedPlanStream,
          builder: (context, snapshot) {
            return InkWell(
              onTap: (){
                context.read<PlanBloc>().updateSelectedPlan(plan);              },
              child: Container(
                width: context.width,
                decoration: BoxDecoration(
                  color:snapshot.data?.id!=plan.id? Styles.PRIMARY_COLOR.withOpacity(0.1):Styles.PRIMARY_COLOR,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                    vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 0,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          plan.name!,
                          style: AppTextStyles.w700
                              .copyWith(fontSize: 20, color: snapshot.data?.id!=plan.id? Styles.HEADER:Styles.WHITE_COLOR),
                        ),
                        Row(
                          spacing: 10,
                          children: [
                            Text(
                              plan.amount.toString(),
                              style: AppTextStyles.w700
                                  .copyWith(fontSize: 20, color: snapshot.data?.id!=plan.id? Styles.HEADER:Styles.WHITE_COLOR),
                            ),
                            AppCore.saudiRiyalSymbol(color: snapshot.data?.id!=plan.id? Styles.HEADER:Styles.WHITE_COLOR)
                          ],
                        ),
                      ],
                    ),
                    if( plan.numberOfChats !=null)

                      Row(
                      spacing: 10,
                      children: [
                        customCircleSvgIcon(
                            imageName: SvgImages.chats,
                            width: 20.w,
                            height: 20.h,
                            imageColor: snapshot.data?.id!=plan.id? Styles.HINT_COLOR:Styles.WHITE_COLOR,
                            color: Colors.transparent),
                        Text(
                          getTranslated("avilable_chats") +
                              " " +
                              plan.numberOfChats.toString(),
                          style: AppTextStyles.w500
                              .copyWith(fontSize: 16, color: snapshot.data?.id!=plan.id? Styles.HEADER:Styles.WHITE_COLOR),
                        ),
                      ],
                    ),
                    if( plan.numberOfLikes !=null)
                    Row(
                      spacing: 10,
                      children: [
                        customCircleSvgIcon(
                            imageName: SvgImages.fav,
                            imageColor: snapshot.data?.id!=plan.id? Styles.HINT_COLOR:Styles.WHITE_COLOR,
                            color: Colors.transparent),
                        Text(
                          getTranslated("avilable_favourit") +
                              " " +
                              plan.numberOfLikes.toString(),
                          style: AppTextStyles.w500
                              .copyWith(fontSize: 16, color: snapshot.data?.id!=plan.id? Styles.HEADER:Styles.WHITE_COLOR),
                        ),
                      ],
                    ),
                    if(plan.worldWowAvailable==1)
                    Row(
                      spacing: 10,
                      children: [
                        customCircleSvgIcon(
                            imageName: SvgImages.profileIcon,
                            imageColor: snapshot.data?.id!=plan.id? Styles.HINT_COLOR:Styles.WHITE_COLOR,
                            color: Colors.transparent),
                        Expanded(
                          child: Text(
                            getTranslated("view_people_from_other_nationality_desc"),
                            style: AppTextStyles.w500
                                .copyWith(fontSize: 16, color: snapshot.data?.id!=plan.id? Styles.HEADER:Styles.WHITE_COLOR),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }
}
