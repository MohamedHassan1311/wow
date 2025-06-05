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
import 'package:wow/components/custom_images.dart';
import 'package:wow/components/empty_widget.dart';
import 'package:wow/components/shimmer/custom_shimmer.dart';
import 'package:wow/data/config/di.dart';
import 'package:wow/features/favourit/bloc/favourit_bloc.dart';
import 'package:wow/features/block/bloc/block_bloc.dart';
import 'package:wow/features/interest/bloc/interest_bloc.dart';
import 'package:wow/main_models/user_model.dart';
import 'package:wow/main_widgets/person_card.dart';
import 'package:wow/navigation/custom_navigation.dart';
import 'package:wow/navigation/routes.dart';
import '../../../app/localization/language_constant.dart';
import '../../../main_blocs/user_bloc.dart';
import '../../../main_widgets/main_app_bar.dart';

class AddToBlockPage extends StatefulWidget {
  const AddToBlockPage({super.key});

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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

          
       Center(
         child: customContainerSvgIcon(
              imageName:SvgImages.report,
              color: Styles.BLACK,
              backGround: Colors.transparent,
              
              width: 80.w,
              height: 80.w,
              padding: 10.w,
            ),
       ),
          SizedBox(height: 30.h),
           Text(
            getTranslated("block_user", context: context),
            //  getTranslated(
                //  "marige_request"),
             style: AppTextStyles.w800.copyWith(
               fontSize: 16.0,
               color: Styles.HEADER,
             ),
           ),
                     SizedBox(height: 10.h),

          Text(
            getTranslated("block_user_desc", context: context),
    
            style: AppTextStyles.w500.copyWith(
              fontSize: 16.0,
              color: Styles.HEADER,
            ),
          ),
                  



        ],),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
