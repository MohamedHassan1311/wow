import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/features/categories/bloc/categories_bloc.dart';
import 'package:wow/features/categories/model/categories_model.dart';
import 'package:wow/features/categories/widgets/category_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/main_widgets/section_title.dart';
import 'package:wow/navigation/custom_navigation.dart';
import 'package:wow/navigation/routes.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';

import '../../../components/shimmer/custom_shimmer.dart';
import '../../../data/config/di.dart';
import '../../../data/internet_connection/internet_connection.dart';
import '../repo/categories_repo.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key, this.title, this.category});
  final String? title;
  final CategoryModel? category;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoriesBloc(
          internetConnection: sl<InternetConnection>(),
          repo: sl<CategoriesRepo>())
        ..add(Click(
          arguments: {
            if (category?.vendorId != null) "vendor_id": category?.vendorId,
            // if (category?.vendorId != null)"${category?.isVendor == true ? "vendor" : "brand"}_id": category?.vendorId,
            // if (category?.subChild != null)"${category?.subChild}": category?.id,
          },
        )),
      child: Column(
        children: [
          SectionTitle(
            title: title ?? getTranslated("categories"),
            withView: true,
            onViewTap: () => CustomNavigator.push(Routes.categories,
                arguments: category?.vendorId),
          ),
          BlocBuilder<CategoriesBloc, AppState>(
            builder: (context, state) {
              if (state is Done) {
                List<CategoryModel> list = state.list as List<CategoryModel>;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      SizedBox(width: Dimensions.paddingSizeExtraSmall.w),
                      ...List.generate(
                        list.length,
                        (i) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: CategoryCard(
                            model: list[i],
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
              if (state is Loading) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                      vertical: Dimensions.PADDING_SIZE_SMALL.h),
                  child: Row(
                    children: [
                      SizedBox(width: Dimensions.paddingSizeExtraSmall.w),
                      ...List.generate(
                        5,
                        (i) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomShimmerContainer(
                                height: 80.w,
                                width: 80.w,
                                radius: 20.w,
                              ),
                              SizedBox(height: 4.h),
                              CustomShimmerText(
                                height: 16.h,
                                width: 60.w,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      SizedBox(width: Dimensions.paddingSizeExtraSmall.w),
                      ...List.generate(
                        5,
                        (i) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: CategoryCard(
                            model: CategoryModel(isComingSoon: i == 2),
                          ),
                        ),
                      )
                    ],
                  ),
                );
                return SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}
