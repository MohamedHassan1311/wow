import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/svg_images.dart';
import '../../../../app/core/validation.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/custom_text_form_field.dart';
import '../../countries/view/country_selection.dart';
import '../bloc/contact_with_us_bloc.dart';
import '../enitity/contact_with_us_entity.dart';

class ContactWithUsBody extends StatelessWidget {
  const ContactWithUsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactWithUsBloc, AppState>(
      builder: (context, state) {
        return StreamBuilder<ContactWithUsEntity?>(
            stream: context.read<ContactWithUsBloc>().entityStream,
            initialData: ContactWithUsEntity(
              name: TextEditingController(),
              email: TextEditingController(),
              phone: TextEditingController(),
              message: TextEditingController(),
            ),
            builder: (context, snapshot) {
              return Form(
                  key: context.read<ContactWithUsBloc>().formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///Name
                      CustomTextField(
                        controller: snapshot.data?.name,
                        label: getTranslated("name"),
                        hint: getTranslated("enter_your_name"),
                        inputType: TextInputType.name,
                        pSvgIcon: SvgImages.user,
                        nextFocus: context.read<ContactWithUsBloc>().emailNode,
                        focusNode: context.read<ContactWithUsBloc>().nameNode,
                        validate: (v) {
                          context.read<ContactWithUsBloc>().updateEntity(
                              snapshot.data?.copyWith(
                                  nameError: Validations.name(v) ?? ""));
                          return null;
                        },
                        errorText: snapshot.data?.nameError,
                        customError: snapshot.data?.nameError != null &&
                            snapshot.data?.nameError != "",
                      ),

                      ///Mail
                      CustomTextField(
                        controller: snapshot.data?.email,
                        focusNode: context.read<ContactWithUsBloc>().emailNode,
                        nextFocus: context.read<ContactWithUsBloc>().phoneNode,
                        label: getTranslated("mail"),
                        hint: getTranslated("enter_your_mail"),
                        inputType: TextInputType.emailAddress,
                        pSvgIcon: SvgImages.mail,
                        validate: (v) {
                          context.read<ContactWithUsBloc>().updateEntity(
                              snapshot.data?.copyWith(
                                  emailError: Validations.mail(v) ?? ""));
                          return null;
                        },
                        errorText: snapshot.data?.emailError,
                        customError: snapshot.data?.emailError != null &&
                            snapshot.data?.emailError != "",
                      ),

                      ///Phone
                      CustomTextField(
                        controller: snapshot.data?.phone,
                        label: getTranslated("phone"),
                        hint: getTranslated("enter_your_phone"),
                        inputType: TextInputType.phone,
                        pSvgIcon: SvgImages.phone,
                        focusNode: context.read<ContactWithUsBloc>().phoneNode,
                        nextFocus:
                            context.read<ContactWithUsBloc>().countryNode,
                        validate: (v) {
                          context.read<ContactWithUsBloc>().updateEntity(
                              snapshot.data?.copyWith(
                                  phoneError: Validations.phone(v) ?? ""));
                          return null;
                        },
                        errorText: snapshot.data?.phoneError,
                        customError: snapshot.data?.phoneError != null &&
                            snapshot.data?.phoneError != "",
                      ),

                      ///Country
                      CountrySelection(
                        initialSelection: snapshot.data?.country,
                        onSelect: (v) {
                          context.read<ContactWithUsBloc>().updateEntity(
                              snapshot.data?.copyWith(country: v));
                        },
                        focusNode:
                            context.read<ContactWithUsBloc>().countryNode,
                        nextFocus:
                            context.read<ContactWithUsBloc>().messageNode,

                        validate: (v) {
                          context.read<ContactWithUsBloc>().updateEntity(
                              snapshot.data?.copyWith(
                                  countryError: Validations.field(
                                          snapshot.data?.country?.name,
                                          fieldName:
                                              getTranslated("country")) ??
                                      ""));
                          return null;
                        },
                        error: snapshot.data?.countryError,
                        haseError: snapshot.data?.countryError != null &&
                            snapshot.data?.countryError != "",
                      ),

                      ///Message
                      CustomTextField(
                        controller: snapshot.data?.message,
                        label: getTranslated("message"),
                        hint: getTranslated("enter_your_message"),
                        focusNode:
                            context.read<ContactWithUsBloc>().messageNode,
                        inputType: TextInputType.text,
                        pSvgIcon: SvgImages.message,
                        keyboardAction: TextInputAction.done,
                        validate: (v) {
                          context
                              .read<ContactWithUsBloc>()
                              .updateEntity(snapshot.data?.copyWith(
                                messageError: Validations.field(
                                      v,
                                      fieldName: getTranslated("message"),
                                    ) ??
                                    "",
                              ));
                          return null;
                        },
                        errorText: snapshot.data?.messageError,
                        customError: snapshot.data?.messageError != null &&
                            snapshot.data?.messageError != "",
                        maxLines: 5,
                        minLines: 1,
                      ),
                    ],
                  ));
            });
      },
    );
  }
}
