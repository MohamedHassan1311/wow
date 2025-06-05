import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/app_event.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/images.dart';
import 'package:wow/app/core/svg_images.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/components/custom_button.dart';
import 'package:wow/components/custom_images.dart';
import 'package:wow/components/custom_network_image.dart';
import 'package:wow/data/config/di.dart';
import 'package:wow/features/Favourit/bloc/favourit_bloc.dart';
import 'package:wow/features/block/bloc/block_bloc.dart';
import 'package:wow/features/language/bloc/language_bloc.dart';
import 'package:wow/main_models/user_model.dart';
import 'package:wow/main_widgets/profile_image_widget.dart';
import 'package:wow/navigation/custom_navigation.dart';
import 'package:wow/navigation/routes.dart';

import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';

class UerBlockCard extends StatefulWidget {
  final String? name;
  final String? age;
  final String? image;
  final Function()? isFavouritTap;
  final UserModel? user;
  UerBlockCard(
      {super.key,
      this.name,
      this.age,
      this.image,
      this.user,
      this.isFavouritTap});

  @override
  State<UerBlockCard> createState() => _UerBlockCardState();
}

class _UerBlockCardState extends State<UerBlockCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        CustomNavigator.push(Routes.profileDetails, arguments: widget.user?.id);
      },
      child: Container(
        width: context.width,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0), 
          child: Row(
            spacing: 10,
            children: [
              ProfileImageWidget(
                        withEdit: false,
                        radius: 40,
                        image: widget.user?.image ??
                      "https://staging.wowzawaj.net/assets/images/user.jpg",
                      ),
               
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.user?.nickname ?? "Mohamed",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.w600.copyWith(
                        color: Styles.BLACK,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      widget.user?.age.toString() ?? "28",
                      style: AppTextStyles.w600.copyWith(
                        color: Styles.BLACK,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 5),
                    if (widget.user?.isVerified == 1)
                      customImageIconSVG(
                        imageName: SvgImages.verify,
                        width: 20,
                        height: 20,
                      ),
                  ],
                ),
              ),
            
            CustomButton(
              width: 80,
              height: 30,
              textSize: 10,
              onTap: () {
                context.read<BlockBloc>().add(Delete(arguments: widget.user?.id ?? ""));
              },
              text: getTranslated("unblock", context: context),
              // color: Styles.PRIMARY_COLOR,
            )
            
            ],
          ),
        ),
      ),
    );
 
  }
}
