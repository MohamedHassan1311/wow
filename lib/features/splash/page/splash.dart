import 'dart:developer';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/components/custom_images.dart';
import 'package:wow/features/splash/repo/splash_repo.dart';
import 'package:wow/main_blocs/user_bloc.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/images.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/svg_images.dart';
import '../../../app/core/text_styles.dart';
import '../../../data/config/di.dart';
import '../bloc/splash_bloc.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with WidgetsBindingObserver {
  bool _showImage = false;

  @override
  void initState() {
    FlutterNativeSplash.remove();

    WidgetsBinding.instance.addObserver(this);
    Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() {
        _showImage = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc(repo: sl<SplashRepo>())..add(Click()),
      child: BlocBuilder<SplashBloc, AppState>(
        builder: (context, state) {
          return Scaffold(
            body: Container(
              width: context.width,
              height: context.height,
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Spacer(),
                        Center(
                          child: Image.asset(
                            Images.splash,
                            height: 170.h,
                            width: 170.h,
                            fit: BoxFit.cover,
                          )
                              .animate()
                              .scale(
                                begin: const Offset(0.5, 0.5),
                                end: const Offset(1.0, 1.0),
                                duration: 1000.ms,
                                delay: 0.ms,
                                curve: Curves.easeInOut,
                              )
                              .then(delay: 200.ms)
                              .shimmer(
                                  duration: 1000.ms, curve: Curves.easeInOut),
                        ),
                        Spacer(),
                        BlocBuilder<UserBloc, AppState>(
                            builder: (context, state) {
                          print(context.read<UserBloc>().user?.countryId?.code);
                          // if (context.read<UserBloc>().user != null)
                          {
                            return Image.asset(
                              context
                                          .read<UserBloc>()
                                          .user
                                          ?.countryId
                                          ?.code
                                          ?.toLowerCase() ==
                                      "sa"
                                  ? Images.sa
                                  : Images.globel,
                              height: 60.h,
                              width: 60.h,
                              fit: BoxFit.contain,
                            );
                          }

                          return SizedBox();
                        }),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              children: [
                                Center(
                                    child: customImageIcon(
                                  imageName: SvgImages.SPC,
                                  fit: BoxFit.contain,
                                  width: 180,
                                      height: 60
                                ).animate(delay: Duration(seconds: 60))),
                                Text(
                                  " ترخيص رقم 0000020446",
                                  style:
                                      AppTextStyles.w600.copyWith(fontSize: 18),
                                ),
                              ],
                            )),
                        SizedBox(
                          height: 18,
                        )
                      ],
                    ),
                  ),
                  if (_showImage)
                    Center(
                        child: Image.asset(
                      Images.splash2,
                      height: context.height,
                      width: context.width,
                      fit: BoxFit.contain,
                    ).animate(delay: Duration(seconds: 60))),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
