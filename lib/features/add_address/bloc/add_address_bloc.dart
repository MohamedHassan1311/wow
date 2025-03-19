import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wow/app/core/app_strings.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/features/add_address/entity/add_address_entity.dart';
import 'package:wow/features/addresses/model/addresses_model.dart';
import 'package:wow/features/maps/models/location_model.dart';
import 'package:wow/navigation/custom_navigation.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_state.dart';
import '../../../../data/error/failures.dart';
import '../../../app/core/app_notification.dart';
import '../../../app/core/styles.dart';
import '../repo/add_address_repo.dart';

class AddAddressBloc extends Bloc<AppEvent, AppState> {
  final AddAddressRepo repo;

  AddAddressBloc({required this.repo}) : super(Start()) {
    on<Click>(onClick);
    on<Init>(onInit);
    on<Update>(onUpdate);
  }

  GoogleMapController? mapController;
  final FocusNode nameNode = FocusNode();
  final FocusNode detailsNode = FocusNode();
  final FocusNode phoneNode = FocusNode();
  final FocusNode typeNode = FocusNode();
  final FocusNode blockNode = FocusNode();
  final FocusNode landmarkNode = FocusNode();

  final formKey = GlobalKey<FormState>();

  final entity = BehaviorSubject<AddressEntity?>();
  Function(AddressEntity?) get updateEntity => entity.sink.add;
  Stream<AddressEntity?> get entityStream => entity.stream.asBroadcastStream();

  bool isBodyValid() {
    log("==>Body${entity.valueOrNull?.toJson()}");
    for (var entry in (entity.valueOrNull?.toJson())!.entries) {
      final value = entry.value;
      if (value == null || (value is String && value.trim().isEmpty)) {
        return false;
      }
    }
    return true;
  }

  clear() {
    updateEntity(null);
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    try {
      emit(Loading());

      Either<ServerFailure, Response> response =
          await repo.addAddress(entity.valueOrNull!);

      response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.red));
        emit(Error());
      }, (success) {
        clear();
        CustomNavigator.pop();
        AppCore.showSnackBar(
            notification: AppNotification(
                message: getTranslated("address_added_successfully"),
                isFloating: true,
                backgroundColor: Styles.ACTIVE,
                borderColor: Styles.ACTIVE));
        emit(Done());
      });
    } catch (e) {
      AppCore.showSnackBar(
          notification: AppNotification(
        message: e.toString(),
        backgroundColor: Styles.IN_ACTIVE,
        borderColor: Styles.RED_COLOR,
      ));
      emit(Error());
    }
  }

  Future<void> onInit(Init event, Emitter<AppState> emit) async {
    updateEntity(AddressEntity(
      location: LocationModel(onChange: (v) {
        updateEntity(entity.valueOrNull?.copyWith(location: v));
        if (mapController != null) {
          mapController?.animateCamera(CameraUpdate.newLatLngZoom(
              LatLng(
                v.latitude ??
                    entity.valueOrNull?.location?.latitude ??
                    AppStrings.defaultLat,
                v.longitude ??
                    entity.valueOrNull?.location?.longitude ??
                    AppStrings.defaultLong,
              ),
              18));
        }
      }),
      name: TextEditingController(),
      details: TextEditingController(),
      phone: TextEditingController(),
      landmark: TextEditingController(),
      block: TextEditingController(),
    ));
  }

  Future<void> onUpdate(Update event, Emitter<AppState> emit) async {
    AddressModel address = event.arguments as AddressModel;
    updateEntity(AddressEntity(
      id: address.id,
      location: LocationModel(
          onChange: (v) {
            updateEntity(entity.valueOrNull?.copyWith(location: v));
            if (mapController != null) {
              mapController?.animateCamera(CameraUpdate.newLatLngZoom(
                  LatLng(
                    v.latitude ??
                        entity.valueOrNull?.location?.latitude ??
                        AppStrings.defaultLat,
                    v.longitude ??
                        entity.valueOrNull?.location?.longitude ??
                        AppStrings.defaultLong,
                  ),
                  18));
            }
          },
          latitude: address.lat,
          longitude: address.long,
          address: address.addressDetails),
      name: TextEditingController(text: address.addressName),
      details: TextEditingController(text: address.addressDetails),
      landmark: TextEditingController(text: address.landmark),
      block: TextEditingController(text: address.block),
      type: AddressType.values.firstWhere((e) => e.name == address.addressType),
      phone: TextEditingController(text: address.phone),
    ));
  }
}
