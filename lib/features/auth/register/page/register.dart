import 'package:wow/app/core/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/core/dimensions.dart';
import '../../../../app/core/images.dart';
import '../../../../components/animated_widget.dart';
import '../../../../data/config/di.dart';
import '../bloc/register_bloc.dart';
import '../repo/register_repo.dart';
import '../widget/register_actions.dart';
import '../widget/register_body.dart';
import '../widget/register_header.dart';

class Register extends StatelessWidget {
  final String? userName;
  const Register({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(repo: sl<RegisterRepo>()),
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: BlocBuilder<RegisterBloc, AppState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListAnimator(
                      customPadding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                      data: [
                        RegisterHeader(),
                        RegisterBody(userName: userName,),
                        RegisterActions(),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
