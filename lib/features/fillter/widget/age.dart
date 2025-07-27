import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:wow/app/core/styles.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/components/animated_widget.dart';
import 'package:wow/components/custom_bottom_sheet.dart';
import 'package:wow/features/fillter/bloc/filtter_bloc.dart';

import '../../../components/custom_expansion_tile.dart';
import '../../../components/custom_text_form_field.dart';
import '../../../navigation/custom_navigation.dart';

class Age extends StatelessWidget {
  const Age({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<FilterBloc>();

    return Form(
      child: CustomExpansionTile(
        initiallyExpanded: false,
        title: getTranslated("age"),
        backgroundColor: Styles.WHITE_COLOR,
        children:  [
          StreamBuilder<String?>(
            stream: bloc.ageStream,
            builder: (context, snapshot) {
              final selectedAge = snapshot.data;

              return CustomTextField(
                readOnly: true,
                sufWidget: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Styles.ACCENT_COLOR,
                ),
                onTap: () {
                  CustomBottomSheet.show(
                    label: getTranslated("age"),
                    onCancel: () => CustomNavigator.pop(),
                    onConfirm: () => CustomNavigator.pop(),
                    widget: ListView(
                      shrinkWrap: true,
                      children: bloc.ageList.map((age) {
                        final isSelected = selectedAge == age;

                        return ListTile(
                          title: Text(age ?? ""),
                          trailing: isSelected
                              ? Icon(Icons.radio_button_checked, color: Styles.PRIMARY_COLOR)
                              : Icon(Icons.radio_button_unchecked),
                          onTap: ()  {
                            bloc.updateAge(
                              isSelected ? null : age,
                            );
                            CustomNavigator.pop();
                          },
                        );
                      }).toList(),
                    ),
                  );
                },
                controller: TextEditingController(
                  text: selectedAge ?? "",
                ),
                label: getTranslated("age"),
                hint: getTranslated("age"),
              );
            },
          ),
        ],
      ),
    );
  }
}
