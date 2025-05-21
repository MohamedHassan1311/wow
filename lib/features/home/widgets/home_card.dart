import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:wow/app/core/app_event.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/images.dart';
import 'package:wow/data/config/di.dart';
import 'package:wow/features/Favourit/bloc/favourit_bloc.dart';
import 'package:wow/features/language/bloc/language_bloc.dart';

import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/images/imagebg.png",
          width: context.width,
          height: context.height,
          fit: BoxFit.cover,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_DEFAULT,
       ),
                child: Row(
                  spacing: 15,
                  children: [
                    Text(
                      "Mohamed",
                      style: AppTextStyles.w800
                          .copyWith(color: Styles.WHITE_COLOR, fontSize: 28),
                    ),
                    Text(
                      "28",
                      style: AppTextStyles.w800
                          .copyWith(color: Styles.WHITE_COLOR, fontSize: 22),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_DEFAULT,
        ),
                child: Row(
                  spacing: 15,
                  children: [
                    Text(
                      "Egypt",
                      style: AppTextStyles.w800
                          .copyWith(color: Styles.WHITE_COLOR, fontSize: 16),
                    ),
                    Text(
                      "28",
                      style: AppTextStyles.w800
                          .copyWith(color: Styles.WHITE_COLOR, fontSize: 16),
                    ),
                  ],
                ),
              ),
              Wrap(
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                children: [
                  Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          "جامعي",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      )),
                  Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          "جامعي",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      )),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(

              vertical: Dimensions.PADDING_SIZE_DEFAULT),
                child: Row(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Dismissible(
                                key: Key('unique_key'),
                                direction: DismissDirection.startToEnd, // 👈 Only allow swipe left


                                confirmDismiss: (direction) async {
                                    sl<FavouritBloc>().add(Add(arguments: 1));

                                  // ❗ Prevent the widget from being removed
                                  return false;
                                },
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Icon(Icons.arrow_forward,
                                      color: Colors.white),
                                ),
                                secondaryBackground: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Icon(Icons.arrow_back,
                                      color: Colors.white),
                                ),
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Image.asset(
                                    Images.swipeHertButton,
                                    matchTextDirection: LanguageBloc.instance.isLtr,
                                    height: 70,
                                  ),
                                ),
                              )),



                                Expanded(
                                  child: Dismissible(
                                key: Key('unique_key'),
                                direction: DismissDirection.endToStart, // 👈 Only allow swipe left


                                confirmDismiss: (direction) async {
                                  if (direction ==
                                      DismissDirection.startToEnd) {
                                    print("Swiped Right");
                                  } else if (direction ==
                                      DismissDirection.endToStart) {
                                    print("Swiped Left");
                                  }

                                  // ❗ Prevent the widget from being removed
                                  return false;
                                },
                                background: Container(
                                  color: Colors.redAccent,
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Icon(Icons.arrow_forward,
                                      color: Colors.white),
                                ),
                                secondaryBackground: Container(
                                  color: Colors.black,
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Icon(Icons.arrow_back,
                                      color: Colors.white),
                                ),
                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                  Directionality(
  textDirection: TextDirection.rtl,
                                     child: Image.asset(
                                                                         matchTextDirection: LanguageBloc.instance.isLtr,

                                                                       Images.swipeLeft,
                                                                       height: 70,
                                                                     ),
                                   ),
                                ],)
                              )),



                            ],
                          )

                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
