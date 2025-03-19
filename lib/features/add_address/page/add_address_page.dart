import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/components/custom_app_bar.dart';
import 'package:wow/features/add_address/bloc/add_address_bloc.dart';
import 'package:wow/features/add_address/repo/add_address_repo.dart';
import 'package:wow/features/addresses/model/addresses_model.dart';

import '../../../app/core/app_event.dart';
import '../../../components/custom_button.dart';
import '../../../data/config/di.dart';
import '../widgets/add_address_body.dart';

class AddAddressPage extends StatelessWidget {
  const AddAddressPage({super.key, this.address});

  final AddressModel? address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title:
            getTranslated(address != null ? "edit_address" : "add_new_address"),
      ),
      body: SafeArea(
          child: BlocProvider(
        create: (context) => AddAddressBloc(repo: sl<AddAddressRepo>())
          ..add(address != null ? Update(arguments: address) : Init()),
        child: BlocBuilder<AddAddressBloc, AppState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AddAddressBody(),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                  child: CustomButton(
                      text: getTranslated("submit"),
                      onTap: () {
                        context
                            .read<AddAddressBloc>()
                            .formKey
                            .currentState!
                            .validate();
                        if (context.read<AddAddressBloc>().isBodyValid()) {
                          context.read<AddAddressBloc>().add(Click());
                        }
                      },
                      isLoading: state is Loading),
                )
              ],
            );
          },
        ),
      )),
    );
  }
}
