import 'package:flutter/material.dart';
import 'package:wow/app/core/styles.dart';
import 'package:wow/main_models/custom_field_model.dart';

class CustomSelectWidget extends StatelessWidget {
  final CustomFieldModel hobby;
  final bool isSelected;
  const CustomSelectWidget(
      {super.key, required this.hobby, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
          decoration: BoxDecoration(
              color: Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                  color: isSelected ? Styles.PRIMARY_COLOR : Colors.transparent,
                  width: 2)),
          child: Text(
            hobby.name ?? "",
            style: TextStyle(
                color:  Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 14),
          ),
        ));
    ;
  }
}
