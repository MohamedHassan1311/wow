import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/images.dart';
import '../../../app/core/styles.dart';
import '../../../app/localization/language_constant.dart';
import '../bloc/complete_profile_bloc.dart';

class SelectGender extends StatelessWidget {
  final bool isEdit;
  const SelectGender({super.key, this.isEdit = false});

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<int?>(
      stream:  context.read<CompleteProfileBloc>().genderStream,
      builder: (context, snapshot) {
        return Row(
          spacing: 15,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: (){
                  if(!isEdit){
                    context.read<CompleteProfileBloc>().updateGender(1);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Styles.PRIMARY_COLOR_transparent,
                      borderRadius: BorderRadius.circular(25),
                      border:
                      Border.all(color:snapshot.data==1? Styles.PRIMARY_COLOR:Colors.transparent)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                        vertical: Dimensions.PADDING_SIZE_DEFAULT/1.5),
                    child: Row(
                      spacing: 12,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text(
                          getTranslated("male") ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                            color: Styles.HEADER,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ) ,
            Expanded(
              child: GestureDetector(
                onTap: (){
                  if(!isEdit){
                    context.read<CompleteProfileBloc>().updateGender(2);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Styles.PRIMARY_COLOR_transparent,
                      borderRadius: BorderRadius.circular(25),
                      border:
                      Border.all(color:snapshot.data==2? Styles.PRIMARY_COLOR:Colors.transparent)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                        vertical: Dimensions.PADDING_SIZE_DEFAULT/1.5),
                    child: Row(
                      spacing: 12,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text(
                          getTranslated("female") ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                            color: Styles.HEADER,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      }
    );
  }
}
