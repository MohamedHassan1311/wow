import 'package:wow/features/categories/bloc/categories_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';
import '../../../components/shimmer/custom_shimmer.dart';
import '../../../data/config/di.dart';
import '../../../data/internet_connection/internet_connection.dart';
import '../model/categories_model.dart';
import '../repo/categories_repo.dart';

class CategoriesTabBar extends StatelessWidget {
  const CategoriesTabBar({super.key, required this.onSelect, this.category});

  final Function(CategoryModel?) onSelect;
  final CategoryModel? category;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoriesBloc(
          internetConnection: sl<InternetConnection>(),
          repo: sl<CategoriesRepo>())
        ..add(Click(
          arguments: {
            if (category?.vendorId != null)"${category?.isVendor == true ? "vendor" : "brand"}_id": category?.vendorId,
            if (category?.subChild != null)"${category?.subChild}": category?.id,
          },
        )),
      child: BlocBuilder<CategoriesBloc, AppState>(
        builder: (context, state) {
          if (state is Done) {
            List<CategoryModel> data = state.list as List<CategoryModel>;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding:
                  EdgeInsets.symmetric(vertical: Dimensions.paddingSizeMini.h),
              child: Row(
                children: [
                  SizedBox(width: Dimensions.paddingSizeExtraSmall.w),
                  ...List.generate(data.length, (i) {
                    context
                        .read<CategoriesBloc>()
                        .globalKeys
                        .add(GlobalKey(debugLabel: "$i"));

                    return InkWell(
                      key: context.read<CategoriesBloc>().globalKeys[i],
                      onTap: () => onSelect.call(data[i]),
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF1F1F1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeMini.w),
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 8.h),
                        child: Text(
                          data[i].name ?? "",
                          style: AppTextStyles.w600.copyWith(
                              fontSize: 14, color: Styles.DETAILS_COLOR),
                        ),
                      ),
                    );
                  })
                ],
              ),
            );
          }
          if (state is Loading) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding:
                  EdgeInsets.symmetric(vertical: Dimensions.paddingSizeMini.h),
              child: Row(
                children: [
                  SizedBox(width: Dimensions.paddingSizeExtraSmall.w),
                  ...List.generate(
                    8,
                    (i) => Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeMini.w),
                      child: CustomShimmerContainer(
                        width: 100.w,
                        height: 35,
                        radius: 100,
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            List<CategoryModel> data = [
              CategoryModel(id: 0, name: "Cat"),
              CategoryModel(id: 1, name: "Animal"),
              CategoryModel(id: 3, name: "small Animal"),
            ];

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding:
                  EdgeInsets.symmetric(vertical: Dimensions.paddingSizeMini.h),
              child: Row(
                children: [
                  SizedBox(width: Dimensions.paddingSizeExtraSmall.w),
                  ...List.generate(data.length, (i) {
                    context
                        .read<CategoriesBloc>()
                        .globalKeys
                        .add(GlobalKey(debugLabel: "$i"));

                    return InkWell(
                      key: context.read<CategoriesBloc>().globalKeys[i],
                      onTap: () => onSelect.call(data[i]),
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF1F1F1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeMini.w),
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 8.h),
                        child: Text(
                          data[i].name ?? "",
                          style: AppTextStyles.w600.copyWith(
                              fontSize: 14, color: Styles.DETAILS_COLOR),
                        ),
                      ),
                    );
                  })
                ],
              ),
            );
            return const SizedBox();
          }
        },
      ),
    );
  }
}
