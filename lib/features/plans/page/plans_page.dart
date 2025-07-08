import 'package:wow/app/core/app_event.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/images.dart';
import 'package:wow/app/core/styles.dart';
import 'package:wow/app/core/text_styles.dart';
import 'package:wow/components/animated_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/components/custom_button.dart';
import 'package:wow/components/empty_widget.dart';
import 'package:wow/components/shimmer/custom_shimmer.dart';
import 'package:wow/data/config/di.dart';
import 'package:wow/data/internet_connection/internet_connection.dart';
import 'package:wow/features/favourit/bloc/favourit_bloc.dart';
import 'package:wow/features/block/bloc/block_bloc.dart';
import 'package:wow/features/interest/bloc/interest_bloc.dart';
import 'package:wow/features/plans/bloc/plan_bloc.dart';
import 'package:wow/features/plans/model/plans_model.dart';
import 'package:wow/features/plans/repo/plan_repo.dart';
import 'package:wow/features/plans/widgets/paln_card.dart';
import 'package:wow/main_models/user_model.dart';
import 'package:wow/main_widgets/person_card.dart';
import 'package:wow/navigation/custom_navigation.dart';
import 'package:wow/navigation/routes.dart';
import '../../../app/core/validation.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/custom_bottom_sheet.dart';
import '../../../components/custom_drop_down_button.dart';
import '../../../main_blocs/user_bloc.dart';
import '../../../main_models/custom_field_model.dart';
import '../../../main_widgets/main_app_bar.dart';
import '../../setting_option/bloc/setting_option_bloc.dart';
import '../../setting_option/repo/setting_option_repo.dart';

class PlansPage extends StatefulWidget {
  const PlansPage({super.key});

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage>
    with AutomaticKeepAliveClientMixin<PlansPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(getTranslated("plans", context: context)),
        ),
        body: BlocProvider(
          create: (context) => PlanBloc(
              repo: sl<PlanRepo>(),
              internetConnection: sl<InternetConnection>())
            ..add(Get()),
          child: BlocBuilder<PlanBloc, AppState>(
            builder: (contextPlanBloc, state) {
              if (state is Done) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),

                        itemCount:
                        contextPlanBloc.read<PlanBloc>().plans?.data?.length ??
                                0, // Sample count
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PalnCard(
                              plan:
                              contextPlanBloc.read<PlanBloc>().plans!.data![index]!,
                            ),
                          );
                        },
                      ),
                    ),
                    StreamBuilder<PlanData>(
                        stream: contextPlanBloc.read<PlanBloc>().selectedPlanStream,
                        builder: (context, snapshot) {
                          return SafeArea(
                            bottom: true,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                                  vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
                              child: CustomButton(
                                onTap: snapshot.data != null
                                    ? () {

                                        if (snapshot.data?.worldWowAvailable ==
                                            1) {
                                          CustomBottomSheet.show(
                                            height: 350.h,
                                            label: getTranslated(
                                                "select_partner_nationality"),
                                            widget: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  BlocProvider(
                                                    create: (context) =>
                                                    SettingOptionBloc(repo: sl<SettingOptionRepo>())
                                                      ..add(Get(arguments: {'field_name': "country","city":"0"})),
                                                    child: BlocBuilder<SettingOptionBloc, AppState>(
                                                        builder: (context, state) {
                                                          if (state is Done) {
                                                            CustomFieldsModel model = state.model as CustomFieldsModel;

                                                            return StreamBuilder<CustomFieldModel?>(
                                                                stream: contextPlanBloc
                                                                    .read<PlanBloc>()
                                                                    .nationalityStream,
                                                                builder: (context, snapshot) {
                                                                  if (snapshot.data != null) {
                                                                    return CustomDropDownButton(
                                                                      label: getTranslated("nationality"),
                                                                      labelErorr: UserBloc
                                                                          .instance.user?.validation?.nationalityId,
                                                                      validation: (v) =>
                                                                          Validations.field(snapshot.data?.name),
                                                                      value: model.data?.firstWhere(
                                                                            (v) => v.id == snapshot.data?.id,
                                                                        orElse: () => CustomFieldModel(name: "no_data"),
                                                                      ),
                                                                      items: model.data?.where((m) => m.code != "SA").toList()?? [],
                                                                      onChange: (v) {
                                                                        contextPlanBloc
                                                                            .read<PlanBloc>()
                                                                            .updateNationality(v as CustomFieldModel);
                                                                      },
                                                                      name: contextPlanBloc
                                                                          .read<PlanBloc>()
                                                                          .nationality
                                                                          .valueOrNull
                                                                          ?.name ??
                                                                          getTranslated("nationality"),
                                                                    );
                                                                  } else
                                                                    return SizedBox();
                                                                });
                                                          }
                                                          if (state is Loading) {
                                                            return CustomShimmerContainer(
                                                              height: 60.h,
                                                              width: context.width,
                                                              radius: 30,
                                                            );
                                                          } else {
                                                            return SizedBox();
                                                          }
                                                        }),
                                                  ),

                                                  SafeArea(
                                                    bottom:true,
                                                    child: CustomButton(onTap: (){
                                                      context.read<PlanBloc>().add(
                                                          Add(arguments: snapshot.data!.id));
                                                      CustomNavigator.pop();
                                                    },
                                                      text: getTranslated("payment"),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }else{
                                          context.read<PlanBloc>().add(
                                              Add(arguments: snapshot.data!.id));
                                        }
                                      }
                                    : null,
                                text: getTranslated("payment"),
                              ),
                            ),
                          );
                        })
                  ],
                );
              }
              if (state is Loading) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                  child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: 10, // Sample count
                      itemBuilder: (context, index) {
                        return CustomShimmerContainer(
                          height: 175.h,
                          width: context.width,
                          radius: 24.w,
                        );
                      }),
                );
              }
              if (state is Error || state is Empty) {
                return Column(
                  children: [
                    Expanded(
                      child: ListAnimator(
                        customPadding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                          vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
                        ),
                        data: [
                          SizedBox(
                            height: 50.h,
                          ),
                          EmptyState(
                            txt: state is Error
                                ? getTranslated("something_went_wrong")
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return SafeArea(child: Container());
              }
            },
          ),
        ));
    ;
  }

  @override
  bool get wantKeepAlive => true;
}
