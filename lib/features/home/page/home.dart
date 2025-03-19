import 'package:wow/app/core/app_state.dart';
import 'package:wow/components/animated_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/localization/language_constant.dart';
import '../../../main_blocs/user_bloc.dart';
import '../../categories/widgets/categories_section.dart';
import '../../../main_widgets/main_app_bar.dart';
import '../widgets/main_services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
  @override
  void initState() {
    // sl<HomeAdsBloc>().add(Click());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: const MainAppBar(),
      body: BlocBuilder<UserBloc, AppState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: ListAnimator(
                  data: [
                    const MainServices(),
                    CategoriesSection(title: getTranslated("shop_by_pets")),
                    const SizedBox(height: 24)
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
