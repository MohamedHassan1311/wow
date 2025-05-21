import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:wow/app/core/styles.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/components/animated_widget.dart';
import 'package:wow/components/custom_expansion_tile.dart';

import 'package:wow/features/fillter/bloc/filtter_bloc.dart';

class Age extends StatelessWidget {
  const Age({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: ListAnimator(
        scroll: false,
        data: [
          CustomExpansionTile(
              initiallyExpanded: false,  
              title: getTranslated("age"),
              backgroundColor: Styles.WHITE_COLOR,
              children: [
                StreamBuilder<String?>(
                    stream: context.read<FilterBloc>().ageStream,
                    builder: (context, snapshot) {
                      return Column(
                        spacing: 5,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getTranslated("age"),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Wrap(
                            children: context.read<FilterBloc>().ageList.map(
                              (hobby) {
                                return GestureDetector(
                                  onTap: () {
                                    if (context.read<FilterBloc>().age.value ==
                                        hobby)
                                      context
                                          .read<FilterBloc>()
                                          .updateAge(null);
                                    else
                                      context
                                          .read<FilterBloc>()
                                          .updateAge(hobby);
                                  },
                                  child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 4),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 12),
                                        decoration: BoxDecoration(
                                             color: Color(0xFFF3F3F3),
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            border: Border.all(
                                                color: snapshot.data == hobby
                                                    ? Styles.PRIMARY_COLOR
                                                    : Colors.transparent,
                                                width: 2)),
                                        child: Text(
                                          hobby ?? "",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                      )),
                                );
                              },
                            ).toList(),
                          )
                        ],
                      );
                    })
              ]),
        ],
      ),
    );
  }
}
