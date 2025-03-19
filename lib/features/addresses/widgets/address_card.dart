import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/svg_images.dart';
import 'package:wow/app/core/text_styles.dart';
import 'package:wow/components/custom_images.dart';
import 'package:wow/features/addresses/bloc/addresses_bloc.dart';
import 'package:wow/features/addresses/bloc/delete_address_bloc.dart';
import 'package:wow/features/addresses/model/addresses_model.dart';
import 'package:wow/main_widgets/delete_item.dart';
import 'package:wow/navigation/custom_navigation.dart';
import 'package:wow/navigation/routes.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/styles.dart';
import '../../../components/custom_bottom_sheet.dart';
import '../../../data/config/di.dart';
import '../repo/addresses_repo.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({super.key, required this.address});
  final AddressModel address;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeleteAddressBloc(repo: sl<AddressesRepo>()),
      child: BlocBuilder<DeleteAddressBloc, AppState>(
        builder: (context, state) {
          return Container(
            margin:
                EdgeInsets.symmetric(vertical: Dimensions.paddingSizeMini.h),
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
              vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.w),
              border: Border.all(color: Styles.LIGHT_BORDER_COLOR),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    customImageIconSVG(
                        width: 24.w,
                        height: 18.h,
                        imageName: SvgImages.address),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        address.addressType ?? "Address Type",
                        style: AppTextStyles.w500
                            .copyWith(fontSize: 16, color: Styles.HEADER),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: customContainerSvgIcon(
                          onTap: () => CustomNavigator.push(Routes.addAddress,
                              arguments: address),
                          backGround: Styles.PRIMARY_COLOR.withOpacity(0.1),
                          color: Styles.PRIMARY_COLOR,
                          width: 35.w,
                          height: 35.w,
                          radius: 8.w,
                          padding: 8.w,
                          imageName: SvgImages.edit),
                    ),
                    customContainerSvgIcon(
                        onTap: () => CustomBottomSheet.show(
                            height: 305.h,
                            widget: BlocProvider(
                              create: (context) =>
                                  DeleteAddressBloc(repo: sl<AddressesRepo>()),
                              child: BlocBuilder<DeleteAddressBloc, AppState>(
                                  builder: (context, state) {
                                return DeleteItem(
                                  id: address.id ?? 0,
                                  isLoading: state is Loading,
                                  onTap: () =>
                                      context.read<DeleteAddressBloc>().add(
                                            Delete(
                                              arguments: {
                                                "id": address.id,
                                                "onSuccess": () => context
                                                    .read<AddressesBloc>()
                                                    .add(
                                                      Delete(
                                                        arguments: address.id,
                                                      ),
                                                    )
                                              },
                                            ),
                                          ),
                                );
                              }),
                            )),
                        backGround: Styles.RED_COLOR.withOpacity(0.1),
                        color: Styles.RED_COLOR,
                        width: 35.w,
                        height: 35.w,
                        radius: 8.w,
                        padding: 8.w,
                        imageName: SvgImages.trash),
                  ],
                ),
                Divider(
                    color: Styles.LIGHT_BORDER_COLOR,
                    height: Dimensions.PADDING_SIZE_DEFAULT.h),
                Text(
                  address.addressDetails ?? "Address Details",
                  style: AppTextStyles.w500
                      .copyWith(fontSize: 14, color: Styles.TITLE),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
