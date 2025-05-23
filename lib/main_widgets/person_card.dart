import 'package:flutter/material.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/images.dart';
import 'package:wow/app/core/svg_images.dart';
import 'package:wow/components/custom_images.dart';
import 'package:wow/components/custom_network_image.dart';
import 'package:wow/features/language/bloc/language_bloc.dart';
import 'package:wow/main_models/user_model.dart';
import 'package:wow/navigation/custom_navigation.dart';
import 'package:wow/navigation/routes.dart';

import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';

class PersoneCard extends StatelessWidget {
  final String? name;
  final String? age;
  final String? image;
  final UserModel? user;
  PersoneCard({super.key, this.name, this.age, this.image, this.user});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        CustomNavigator.push(Routes.profileDetails, arguments: user?.id);
      },
      child: AspectRatio(
        aspectRatio: 3 / 5, // Adjust based on your desired shape
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomNetworkImage.containerNewWorkImage(
              image: user?.image ??
                  "https://staging.wowzawaj.net/assets/images/user.jpg",
              defaultImage: "assets/images/imagebg.png",
              fit: BoxFit.cover,
              radius: 12,
              onTap: (){
                CustomNavigator.push(Routes.profileDetails, arguments: user?.id);
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                          user?.name ?? "Mohamed",
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
                        user?.age.toString() ?? "28",
                        style: AppTextStyles.w600.copyWith(
                          color: Styles.BLACK,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 5),
                      if(user?.isVerified == 1)
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
