import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/features/add_address/widgets/selected_location.dart';
import 'package:wow/features/addresses/model/addresses_model.dart';
import 'package:wow/main_models/custom_field_model.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/svg_images.dart';
import '../../../app/core/validation.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/animated_widget.dart';
import '../../../components/custom_bottom_sheet.dart';
import '../../../components/custom_single_selector.dart';
import '../../../components/custom_text_form_field.dart';
import '../../../navigation/custom_navigation.dart';
import '../bloc/add_address_bloc.dart';
import '../entity/add_address_entity.dart';

class AddAddressBody extends StatelessWidget {
  const AddAddressBody({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AddressEntity?>(
        stream: context.read<AddAddressBloc>().entityStream,
        builder: (context, snapshot) {
          return Form(
            key: context.read<AddAddressBloc>().formKey,
            child: Expanded(
              child: ListAnimator(
                customPadding: EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                ),
                data: [
                  ///Map
                  SelectedLocation(),

                  ///Address
                  CustomTextField(
                    controller: snapshot.data?.name,
                    label: getTranslated("address_name"),
                    hint: getTranslated("enter_address_name"),
                    inputType: TextInputType.text,
                    pSvgIcon: SvgImages.location,
                    focusNode: context.read<AddAddressBloc>().nameNode,
                    nextFocus: context.read<AddAddressBloc>().blockNode,
                    validate: (v) {
                      context.read<AddAddressBloc>().updateEntity(snapshot.data
                          ?.copyWith(
                              nameError: Validations.field(v,
                                      fieldName:
                                          getTranslated("address_name")) ??
                                  ""));
                      return null;
                    },
                    errorText: snapshot.data?.nameError,
                    customError: snapshot.data?.nameError != null &&
                        snapshot.data?.nameError != "",
                  ),

                  ///Block
                  CustomTextField(
                    controller: snapshot.data?.block,
                    label: getTranslated("address_block"),
                    hint: getTranslated("enter_address_block"),
                    inputType: TextInputType.text,
                    pSvgIcon: SvgImages.location,
                    focusNode: context.read<AddAddressBloc>().blockNode,
                    nextFocus: context.read<AddAddressBloc>().detailsNode,
                    validate: (v) {
                      context.read<AddAddressBloc>().updateEntity(snapshot.data
                          ?.copyWith(
                              blockError: Validations.field(v,
                                      fieldName: getTranslated("block")) ??
                                  ""));
                      return null;
                    },
                    errorText: snapshot.data?.blockError,
                    customError: snapshot.data?.blockError != null &&
                        snapshot.data?.blockError != "",
                  ),

                  ///Address Details
                  CustomTextField(
                    controller: snapshot.data?.details,
                    label: getTranslated("address_details"),
                    hint: getTranslated("enter_address_details"),
                    inputType: TextInputType.text,
                    pSvgIcon: SvgImages.message,
                    focusNode: context.read<AddAddressBloc>().detailsNode,
                    nextFocus: context.read<AddAddressBloc>().landmarkNode,
                    validate: (v) {
                      context.read<AddAddressBloc>().updateEntity(snapshot.data
                          ?.copyWith(
                              detailsError: Validations.field(v,
                                      fieldName:
                                          getTranslated("address_details")) ??
                                  ""));
                      return null;
                    },
                    errorText: snapshot.data?.detailsError,
                    customError: snapshot.data?.detailsError != null &&
                        snapshot.data?.detailsError != "",
                  ),

                  ///LandMark(Optional)
                  CustomTextField(
                    controller: snapshot.data?.landmark,
                    label:
                        "${getTranslated("landmark")} (${getTranslated("optional")})",
                    hint: getTranslated("enter_landmark"),
                    inputType: TextInputType.text,
                    pSvgIcon: SvgImages.location,
                    focusNode: context.read<AddAddressBloc>().landmarkNode,
                  ),

                  ///Phone Number
                  CustomTextField(
                    controller: snapshot.data?.phone,
                    label: getTranslated("phone"),
                    hint: getTranslated("enter_phone"),
                    inputType: TextInputType.phone,
                    pSvgIcon: SvgImages.phone,
                    keyboardAction: TextInputAction.done,
                    focusNode: context.read<AddAddressBloc>().phoneNode,
                    validate: (v) {
                      context.read<AddAddressBloc>().updateEntity(snapshot.data
                          ?.copyWith(phoneError: Validations.phone(v) ?? ""));
                      return null;
                    },
                    errorText: snapshot.data?.phoneError,
                    customError: snapshot.data?.phoneError != null &&
                        snapshot.data?.phoneError != "",
                  ),

                  ///Address Type
                  CustomTextField(
                    readOnly: true,
                    onTap: () {
                      CustomBottomSheet.show(
                        label: getTranslated("select_address_type"),
                        onConfirm: () => CustomNavigator.pop(),
                        widget: CustomSingleSelector(
                          list: AddressType.values
                              .map((e) => CustomFieldModel(
                                  id: e.index, name: e.name.capitalize()))
                              .toList(),
                          initialValue: snapshot.data?.type?.index,
                          onConfirm: (v) {
                            context.read<AddAddressBloc>().updateEntity(
                                snapshot.data?.copyWith(
                                    type: AddressType.values[v?.id ?? 0]));
                          },
                        ),
                      );
                    },
                    label: getTranslated("address_type"),
                    hint: getTranslated("select_address_type"),
                    controller:
                        TextEditingController(text: snapshot.data?.type?.name.capitalize()),
                    pSvgIcon: SvgImages.location,
                    validate: (v) {
                      context.read<AddAddressBloc>().updateEntity(snapshot.data
                          ?.copyWith(
                              typeError: Validations.field(v,
                                      fieldName:
                                          getTranslated("address_type")) ??
                                  ""));
                      return null;
                    },
                    errorText: snapshot.data?.typeError,
                    customError: snapshot.data?.typeError != null &&
                        snapshot.data?.typeError != "",
                    sufWidget: Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: Styles.DETAILS_COLOR,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
