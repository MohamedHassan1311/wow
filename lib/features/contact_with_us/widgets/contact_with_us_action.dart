import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/features/contact_with_us/bloc/contact_with_us_bloc.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/svg_images.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/custom_images.dart';
import '../../../../data/config/di.dart';
import '../../language/bloc/language_bloc.dart';

class ContactWithUsAction extends StatelessWidget {
  const ContactWithUsAction({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactWithUsBloc, AppState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: CustomButton(
              text: getTranslated("submit"),
              onTap: () {
                context
                    .read<ContactWithUsBloc>()
                    .formKey
                    .currentState!
                    .validate();
                if (context.read<ContactWithUsBloc>().isBodyValid()) {
                  context.read<ContactWithUsBloc>().add(Click());
                }
              },
              isLoading: state is Loading),
        );
      },
    );
  }
}

