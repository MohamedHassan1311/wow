import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/images.dart';
import 'package:wow/app/core/styles.dart';
import 'package:wow/app/core/text_styles.dart';
import 'package:wow/components/animated_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/components/shimmer/custom_shimmer.dart';
import 'package:wow/features/Favourit/bloc/favourit_bloc.dart';
import 'package:wow/main_widgets/person_card.dart';
import 'package:wow/navigation/custom_navigation.dart';
import 'package:wow/navigation/routes.dart';
import '../../../app/localization/language_constant.dart';
import '../../../main_blocs/user_bloc.dart';
// import '../../profile_details/widgets/categories_section.dart';
import '../../../main_widgets/main_app_bar.dart';


class RecommendationPage extends StatefulWidget {
  const RecommendationPage({super.key});

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage>
 {
  @override
  void initState() {
    // sl<HomeAdsBloc>().add(Click());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(getTranslated("recommendation", context: context)),
        
      ),
      body:
      
       BlocBuilder<FavouritBloc, AppState>(
    builder: (context, state) {
      if (state is Done) {
     return           LikesGrid(type: 'likedYou')
;
      
      }
      if (state is Loading) {
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
          child: CustomShimmerContainer(
            height: 175.h,
            width: context.width,
            radius: 24.w,
          ),
        );
      } else {
        return           LikesGrid(type: 'likedYou')
;
        
      
      }
    },
        )
      
      
        
    );;
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
