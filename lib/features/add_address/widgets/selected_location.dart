import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/features/add_address/bloc/add_address_bloc.dart';
import 'package:wow/features/add_address/entity/add_address_entity.dart';
import '../../../app/core/app_strings.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../navigation/custom_navigation.dart';
import '../../../navigation/routes.dart';

class SelectedLocation extends StatelessWidget {
  const SelectedLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AddressEntity?>(
        stream: context.read<AddAddressBloc>().entityStream,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return InkWell(
              onTap: () {
                CustomNavigator.push(Routes.pickLocation,
                    arguments: snapshot.data?.location);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                    vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
                decoration: BoxDecoration(
                    color: Styles.WHITE_COLOR,
                    borderRadius: BorderRadius.circular(20.w),
                    border: Border.all(
                      color: Styles.BORDER_COLOR,
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.w),
                          child: SizedBox(
                            height: 160.h,
                            width: context.width,
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                bearing: 192,
                                target: LatLng(
                                  snapshot.data?.location?.latitude ??
                                      AppStrings.defaultLat,
                                  snapshot.data?.location?.longitude ??
                                      AppStrings.defaultLong,
                                ),
                                zoom: 18,
                              ),
                              minMaxZoomPreference:
                                  const MinMaxZoomPreference(0, 100),
                              myLocationButtonEnabled: false,
                              myLocationEnabled: false,
                              onMapCreated:
                                  (GoogleMapController mapController) {
                                context.read<AddAddressBloc>().mapController =
                                    mapController;
                                mapController
                                    .animateCamera(CameraUpdate.newLatLngZoom(
                                        LatLng(
                                          snapshot.data?.location?.latitude ??
                                              AppStrings.defaultLat,
                                          snapshot.data?.location?.longitude ??
                                              AppStrings.defaultLong,
                                        ),
                                        18));
                              },
                              scrollGesturesEnabled: true,
                              zoomControlsEnabled: false,
                              onCameraMove: (CameraPosition cameraPosition) {},
                              markers: {
                                Marker(
                                  markerId: MarkerId('1'),
                                  position: LatLng(
                                    snapshot.data?.location?.latitude ??
                                        AppStrings.defaultLat,
                                    snapshot.data?.location?.longitude ??
                                        AppStrings.defaultLong,
                                  ),
                                )
                              },
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            CustomNavigator.push(Routes.pickLocation,
                                arguments: snapshot.data?.location);
                          },
                          child: SizedBox(
                            height: 160.h,
                            width: context.width,
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL.h),
                      child: RichText(
                        text: TextSpan(
                            text: "${getTranslated("address_details")}: ",
                            style: AppTextStyles.w700
                                .copyWith(fontSize: 14, color: Styles.HEADER),
                            children: [
                              TextSpan(
                                text: snapshot.data?.location?.address ??
                                    AppStrings.defaultAddress,
                                style: AppTextStyles.w500.copyWith(
                                    fontSize: 14, color: Styles.TITLE),
                              )
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        });
  }
}
