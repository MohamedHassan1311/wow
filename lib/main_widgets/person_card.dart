import 'package:flutter/material.dart';
import 'package:wow/app/core/app_event.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/images.dart';
import 'package:wow/app/core/svg_images.dart';
import 'package:wow/components/custom_images.dart';
import 'package:wow/components/custom_network_image.dart';
import 'package:wow/data/config/di.dart';
import 'package:wow/features/Favourit/bloc/favourit_bloc.dart';
import 'package:wow/features/language/bloc/language_bloc.dart';
import 'package:wow/main_models/user_model.dart';
import 'package:wow/navigation/custom_navigation.dart';
import 'package:wow/navigation/routes.dart';

import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';

class PersoneCard extends StatefulWidget {
  final String? name;
  final String? age;
  final String? image;
  final Function()? isFavouritTap;
  final UserModel? user;
  PersoneCard({super.key, this.name, this.age, this.image, this.user,this.isFavouritTap});

  @override
  State<PersoneCard> createState() => _PersoneCardState();
}

class _PersoneCardState extends State<PersoneCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        CustomNavigator.push(Routes.profileDetails, arguments: widget.user?.id);
      },
      child: AspectRatio(
        aspectRatio: 3 / 5, // Adjust based on your desired shape
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomNetworkImage.containerNewWorkImage(
              image: widget.user?.image ??
                  "https://staging.wowzawaj.net/assets/images/user.jpg",
              defaultImage: "assets/images/imagebg.png",
              fit: BoxFit.cover,
              radius: 12,
              onTap: () {
                CustomNavigator.push(Routes.profileDetails,
                    arguments: widget.user?.id);
              },
            ),
            if(widget.isFavouritTap!=null)
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: customContainerSvgIcon(
                  onTap: widget.isFavouritTap,
                  imageName: widget.user?.isFavourit == 0
                      ? SvgImages.star
                      : SvgImages.starFill,
                  color: Styles.WHITE_COLOR,
                  width: 50,
                  height: 50,
                  padding: 10.w,
                  radius: 26.w,
                  borderColor: Styles.WHITE_COLOR,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 36,
                        child: Text(
                          widget.user?.nickname ?? "Mohamed",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.w600.copyWith(
                            color: Styles.BLACK,
                            fontSize: 18,
                          ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
