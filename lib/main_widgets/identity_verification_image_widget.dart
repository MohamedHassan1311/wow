import 'dart:io';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/images.dart';
import 'package:wow/features/language/bloc/language_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app/core/styles.dart';
import '../app/core/svg_images.dart';
import '../components/custom_images.dart';
import '../components/custom_network_image.dart';
import '../components/image_pop_up_viewer.dart';
import '../data/config/di.dart';
import '../helpers/pickers/view/image_picker_helper.dart';
import '../main_blocs/user_bloc.dart';

class IdentityVerificationWidget extends StatelessWidget {
  const IdentityVerificationWidget(
      {required this.withEdit,
      this.radius = 55,
      super.key,
      this.onGet,
      this.onTap,
      this.imageFile,
      this.image});

  final bool withEdit;
  final Function(File)? onGet;
  final File? imageFile;
  final double radius;
  final String? image;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, AppState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (onTap != null) {
              onTap?.call();
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              imageFile != null
                  ? GestureDetector(
                      onTap: () => showDialog(
                          context: context,
                          barrierColor: Colors.black.withOpacity(0.75),
                          builder: (context) {
                            return ImagePopUpViewer(
                              image: imageFile != null ? imageFile! : image,
                              isFromInternet: imageFile == null,
                              title: "",
                            );
                          }),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          imageFile!,
                          height: context.width,
                          width: context.width,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                              child: Container(
                                  height: radius * 2,
                                  width: radius * 2,
                                  color: Colors.grey,
                                  child: const Center(
                                      child: Icon(Icons.replay,
                                          color: Colors.green)))),
                        ),
                      ),
                    )
                  : image != null
                      ? GestureDetector(
                          onTap: () {
                            if (withEdit) {
                              ImagePickerHelper.showOptionDialog(onGet: onGet);
                            }
                          },
                          child: SizedBox(
                            height: context.width,
                            width: context.width,
                            child: Image.network(
                              image!,
                              fit: BoxFit.cover,

                              height: context.width,
                              width: context.width,
                            ),
                          ),
                        )
                      : GestureDetector(
                onTap: () {
                  if (withEdit) {
                    ImagePickerHelper.showOptionDialog(onGet: onGet);
                  }
                },
                        child: Image.asset(
                            Images.verfi,
                            height: context.width,
                            width: context.width,
                          ),
                      ),

              ///Tow Show if not complete his profile
              if (withEdit)
                Positioned(
                  bottom: 0,
                  left: sl<LanguageBloc>().isLtr ? null : 0,
                  right: sl<LanguageBloc>().isLtr ? 0 : null,
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      if (withEdit) {
                        ImagePickerHelper.showOptionDialog(onGet: onGet);
                      }
                    },
                    child: Container(
                        height: 25.w,
                        width: 25.w,
                        padding: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                            boxShadow: kElevationToShadow[1],
                            color: Styles.PRIMARY_COLOR,
                            borderRadius: BorderRadius.circular(100)),
                        child: customImageIconSVG(
                          imageName: SvgImages.cameraIcon,
                          color: Styles.WHITE_COLOR,
                        )),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
