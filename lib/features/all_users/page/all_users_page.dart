import 'package:wow/app/core/app_event.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/images.dart';
import 'package:wow/app/core/styles.dart';
import 'package:wow/app/core/text_styles.dart';
import 'package:wow/components/animated_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/components/custom_button.dart';
import 'package:wow/components/empty_widget.dart';
import 'package:wow/components/shimmer/custom_shimmer.dart';
import 'package:wow/data/config/di.dart';
import 'package:wow/data/internet_connection/internet_connection.dart';
import 'package:wow/features/all_users/bloc/all_users_bloc.dart';
import 'package:wow/features/all_users/repo/all_users_repo.dart';
import 'package:wow/features/recommendation/bloc/recommendation_bloc.dart';
import 'package:wow/features/recommendation/repo/recommendation_repo.dart';
import 'package:wow/main_models/search_engine.dart';
import 'package:wow/main_models/user_model.dart';
import 'package:wow/main_widgets/person_card.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/custom_loading_text.dart';

class AllUsersPage extends StatefulWidget {
  const AllUsersPage({super.key});

  @override
  State<AllUsersPage> createState() => _AllUsersPageState();
}

class _AllUsersPageState extends State<AllUsersPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(getTranslated("all_users", context: context)),
        ),
        body: Padding(
          padding:  EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
          child: BlocProvider(
            create: (context) => AllUsersBloc(
                repo: sl<AllUsersRepo>(),
                internetConnection: sl<InternetConnection>())
              ..add(Get(arguments: SearchEngine())),
            child: BlocBuilder<AllUsersBloc, AppState>(
              builder: (context, state) {
                if (state is Done) {
                  List<UserModel> list = context.read<AllUsersBloc>().recommendations??[];
                  return Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          controller: context.read<AllUsersBloc>().controller,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Two cards per row
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 3 / 4,
                          ),
                          itemCount: list.length, // Sample count
                          itemBuilder: (context, index) {
                            return PersoneCard(
                              name: list[index].name,
                              user:list[index] ,
                              age: list[index].age.toString(),
                              image: list[index].image,
                            );
                          },
                        ),
                      ),
                      CustomLoadingText(loading: state.loading),

                    ],
                  );
                }
                if (state is Empty) {
                  return EmptyState(                  );
                }
                if (state is Loading) {
                  return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two cards per row
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3 / 4,
                  ),
                  itemCount: 10,
                    itemBuilder: (context, index) {
                      return CustomShimmerContainer(
                        height: 175.h,
                        width: context.width,
                        radius: 24.w,
                      );
                    }
                  );
                }
                if (state is Error) {
                  return Column(
                    children: [
                      EmptyState(
                        txt: getTranslated("something_went_wrong"),
                      ),
                      CustomButton(
                        onTap: () {
                          context.read<AllUsersBloc>().add(Get(arguments: SearchEngine()));
                        },
                        text: getTranslated("try_again"),
                      )
                    ],
                  );
                }
                else {
                  return SizedBox();
                }
              },
            ),
          ),
        ));
    ;
  }
}

class LikesGrid extends StatelessWidget {
  final String type;
  const LikesGrid({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two cards per row
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 3 / 4,
      ),
      itemCount: 10, // Sample count
      itemBuilder: (context, index) {
        return PersoneCard(
          name: type == 'likedYou' ? 'Ahmad' : 'Sara',
          age: 25.toString(),
          image: "assets/images/imagebg.png",
        );
      },
    );
  }
}
