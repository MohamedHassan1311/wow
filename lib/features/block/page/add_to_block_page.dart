import 'package:wow/app/core/app_event.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/images.dart';
import 'package:wow/app/core/styles.dart';
import 'package:wow/app/core/svg_images.dart';
import 'package:wow/app/core/text_styles.dart';
import 'package:wow/components/animated_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/components/custom_button.dart';
import 'package:wow/components/custom_drop_down_button.dart';
import 'package:wow/components/custom_images.dart';
import 'package:wow/components/custom_text_form_field.dart';
import 'package:wow/components/empty_widget.dart';
import 'package:wow/components/shimmer/custom_shimmer.dart';
import 'package:wow/data/config/di.dart';
import 'package:wow/data/internet_connection/internet_connection.dart';
import 'package:wow/features/block/repo/block_repo.dart';
import 'package:wow/features/favourit/bloc/favourit_bloc.dart';
import 'package:wow/features/block/bloc/block_bloc.dart';
import 'package:wow/features/interest/bloc/interest_bloc.dart';
import 'package:wow/features/setting_option/bloc/setting_option_bloc.dart';
import 'package:wow/features/setting_option/repo/setting_option_repo.dart';
import 'package:wow/main_models/custom_field_model.dart';
import 'package:wow/main_models/user_model.dart';
import 'package:wow/main_widgets/person_card.dart';
import 'package:wow/navigation/custom_navigation.dart';
import 'package:wow/navigation/routes.dart';
import '../../../app/localization/language_constant.dart';
import '../../../main_blocs/user_bloc.dart';
import '../../../main_widgets/main_app_bar.dart';

class AddToBlockPage extends StatefulWidget {
  final UserModel user;
  final bool isFromChat;
  const AddToBlockPage({super.key, required this.user, this.isFromChat = false});

  @override
  State<AddToBlockPage> createState() => _AddToBlockPageState();
}

class _AddToBlockPageState extends State<AddToBlockPage>
    with AutomaticKeepAliveClientMixin<AddToBlockPage> {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(       
          elevation: 0,
          title: Text(getTranslated("blocke_user", context: context)),
        ),
        body: BlocProvider(
          create: (context) => BlockBloc(repo: sl<BlockRepo>(),internetConnection: sl<InternetConnection>()),
          child: BlocBuilder<BlockBloc, AppState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              
                
                SizedBox(height: 30.h),
              
              
                     Center(
               child: Icon(Icons.block, color: Styles.PRIMARY_COLOR, size: 90.w,),
                     ),
                SizedBox(height: 30.h),
                 Text(
                  getTranslated("You are about to be banned", context: context).replaceAll("#", widget.user.nickname??""),
               
                   style: AppTextStyles.w800.copyWith(
                     fontSize: 16.0,
                     color: Styles.HEADER,
                   ),
                 ),
                           SizedBox(height: 10.h),
              
                  Text(
                    getTranslated("block_user_desc", context: context).replaceAll("#", widget.user.nickname??""),
                    
                    style: AppTextStyles.w500.copyWith(
                      fontSize: 16.0,
                      color: Styles.HEADER,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    getTranslated("block_user_note", context: context),
                    style: AppTextStyles.w500.copyWith(
                      fontSize: 16.0,
                      color: Styles.HEADER,
                    ),
                  ),
              
                    //        BlocProvider(
                    //   create: (context) =>
                    //       SettingOptionBloc(repo: sl<SettingOptionRepo>())
                    //         ..add(Get(arguments: {'field_name': "block"})),
                    //   child: BlocBuilder<SettingOptionBloc, AppState>(
                    //       builder: (context, state) {
                    //     if (state is Done) {
                    //       CustomFieldsModel model = state.model as CustomFieldsModel;
              
                    //       return StreamBuilder<CustomFieldModel?>(
                    //           stream: context.read<BlockBloc>().blockReasonStream,
                    //           builder: (context, snapshot) {
                        
                    //               return CustomDropDownButton(
                    //                 label: getTranslated("reason"),
                                    
              
                    
                                
                    //                 value: model.data?.firstWhere(
                    //                   (v) => v.id == snapshot.data?.id,
                    //                   orElse: () => CustomFieldModel(name: "no_data"),
                    //                 ),
              
              
                    //                 onChange: (v) {
                    //                   context
                    //                       .read<BlockBloc>()
                    //                       .updateBlockReason(v as CustomFieldModel);
                    //                 },
                    //                 items: model.data ?? [],
                    //                 name: context
                    //                         .read<BlockBloc>()
                    //                         .blockReason
                    //                         .valueOrNull
                    //                         ?.name ??
                    //                     getTranslated("reason"),
                    //               );
                             
                    //           });
                    //     }
                    //     if (state is Loading) {
                    //       return CustomShimmerContainer(
                    //         height: 60.h,
                    //         width: context.width,
                    //         radius: 30,
                    //       );
                    //     } else {
                    //       return SizedBox();
                    //     }
                    //   }),
                    // ),
                   
              
              
                     CustomTextField(
                      controller:
                      context.read<BlockBloc>().blockReasonController,
                      label: getTranslated("reason"),
                      hint:
                      "${getTranslated("enter")} ${getTranslated("reason")}",
                      inputType: TextInputType.text,
                      pSvgIcon: SvgImages.user,
                    ),       
              
            
            Spacer(),
              CustomButton(
                text: getTranslated("blocke_user"),
                isLoading: state is Loading,
                onTap: () {
                  context.read<BlockBloc>().add(Add(arguments: {

                    "user": widget.user,
                    "isFromChat": widget.isFromChat
                  }));
                },
              ),
              
              Spacer(),
              ],),
            );
          },
                ),
        ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
