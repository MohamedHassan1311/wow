import 'package:wow/main_widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/components/animated_widget.dart';
import '../../../app/core/app_event.dart';
import '../../../data/config/di.dart';
import '../../../main_blocs/user_bloc.dart';
import '../../language/bloc/language_bloc.dart';
import '../../profile/bloc/profile_bloc.dart';
import '../widgets/more_profile_options.dart';
import '../widgets/more_settings_options.dart';

class More extends StatefulWidget {
  const More({super.key});

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  @override
  void initState() {
    ///To Update Balance
    if (sl<ProfileBloc>().isLogin) {
      sl<ProfileBloc>().add(Get());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LanguageBloc, AppState>(
        builder: (context, state) {
          return Column(
            children: [
              MainAppBar(),
              Expanded(
                child: BlocBuilder<UserBloc, AppState>(
                  builder: (context, state) {
                    return ListAnimator(
                      data: [
                        if (sl<UserBloc>().isLogin)
                          MoreProfileOptions(),
                        MoreSettingsOptions(),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
