import 'package:flutter/material.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/styles.dart';
import 'package:wow/app/core/svg_images.dart';
import 'package:wow/components/back_icon.dart';
import 'package:wow/components/custom_alert_dialog.dart';
import 'package:wow/components/custom_images.dart';
import 'package:wow/components/custom_network_image.dart';
import 'package:wow/features/profile_details/widgets/maridge_request_dialog.dart';

class PersonalImage extends StatelessWidget {
  final String image;
  const PersonalImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomNetworkImage.containerNewWorkImage(
          image: image,
          radius: 25,
          width: context.width,
          height: context.height * .45,
                        defaultImage: "assets/images/imagebg.png",

          fit: BoxFit.cover,
        ),
        Positioned(
            top: 10,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FilteredBackIcon(),
            )),
        Positioned(
            bottom: 10,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: customContainerSvgIcon(
                    onTap: () {},
                    imageName: SvgImages.star,
                    color: Styles.WHITE_COLOR,
                    width: 50.w,
                    height: 50.w,
                    padding: 10.w,
                    radius: 26.w,
                    borderColor: Styles.WHITE_COLOR,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: customContainerSvgIcon(
                    onTap: () {},
                    imageName: SvgImages.chats,
                    color: Styles.WHITE_COLOR,
                    width: 50.w,
                    height: 50.w,
                    padding: 10.w,
                    radius: 26.w,
                    borderColor: Styles.WHITE_COLOR,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: customContainerSvgIcon(
                    onTap: () {
                      CustomAlertDialog.show(
                          dailog: AlertDialog(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: Dimensions.PADDING_SIZE_DEFAULT.w,
                                  horizontal:
                                      Dimensions.PADDING_SIZE_DEFAULT.w),
                              insetPadding: EdgeInsets.symmetric(
                                  vertical:
                                      Dimensions.PADDING_SIZE_EXTRA_LARGE.w,
                                  horizontal: context.width * 0.1),
                              shape: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(20.0)),
                              content: MaridgeRequestDialog()));
                    },
                    imageName: SvgImages.ring,
                    color: Styles.WHITE_COLOR,
                    width: 50.w,
                    height: 50.w,
                    padding: 10.w,
                    radius: 26.w,
                    borderColor: Styles.WHITE_COLOR,
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
