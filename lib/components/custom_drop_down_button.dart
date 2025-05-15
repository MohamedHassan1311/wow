import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:wow/app/core/extensions.dart';
import '../app/core/dimensions.dart';
import '../app/core/styles.dart';
import '../app/core/text_styles.dart';
import 'custom_images.dart';

class CustomDropDownButton extends StatefulWidget {
  final List<dynamic> items;
  final Widget? icon;
  final String? pAssetIcon;
  final String? pSvgIcon;
  final Color? pIconColor;
  final double iconSize;
  final bool isEnabled;
  final String? label;
  final String? labelErorr;
  final String name;
  final Object? value;
  final dynamic dataType;
  final void Function(Object?)? onChange;
  final String? Function(Object?)? validation;

  const CustomDropDownButton({
    required this.items,
    this.value,
    this.pAssetIcon,
    this.pSvgIcon,
    this.pIconColor,
    this.onChange,
    this.validation,
    this.isEnabled=true,
    this.icon,
    this.label,
    this.labelErorr,
    this.dataType,
    required this.name,
    this.iconSize = 22,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomDropDownButton> createState() => _CustomDropDownButtonState();
}

class _CustomDropDownButtonState extends State<CustomDropDownButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 5,
              child: Text(
                widget.label ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                  color: Styles.HEADER,
                ),
              ),
            ),
            Spacer(),
            if(widget.labelErorr !=null)
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Styles.ERORR_COLOR.withOpacity(.10),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.labelErorr ?? "",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                          color: Styles.ERORR_COLOR,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        FormBuilderDropdown(
          enabled:widget.isEnabled ,
          items: widget.items.map((item) {
            return DropdownMenuItem(
              value: item,

              child: Text(
                item.name,
                style:
                    AppTextStyles.w500.copyWith(color: Styles.TITLE, fontSize: 14),
              ),
            );
          }).toList(),
          style: AppTextStyles.w500  .copyWith(color: Styles.PRIMARY_COLOR, fontSize: 14),
          onChanged: widget.onChange,
          menuMaxHeight: context.height * 0.4,

          initialValue: widget.value,
          isDense: true,
          validator: widget.validation,
          isExpanded: true,
          dropdownColor: Styles.FILL_COLOR,
          itemHeight: 50,
          icon: widget.icon ??
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Styles.ACCENT_COLOR,
              ),
          iconSize: widget.iconSize,
          borderRadius:
              const BorderRadius.all(Radius.circular(Dimensions.RADIUS_DEFAULT)),
          decoration: InputDecoration(

            hintStyle:
                AppTextStyles.w400.copyWith(color: Styles.DISABLED, fontSize: 14),
            hintText: widget.name,
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8.w,
              ),
              child: widget.pAssetIcon != null
                  ? Image.asset(
                      widget.pAssetIcon!,
                      height: 20.h,
                      width: 20.w,
                      color: widget.pIconColor ?? Colors.black,
                    )
                  : widget.pSvgIcon != null
                      ? customImageIconSVG(
                          imageName: widget.pSvgIcon!,
                          color: widget.pIconColor ?? Colors.black,
                          height: 20.h,
                        )
                      : null,
            ),filled: true,
            fillColor: Styles.GREY_BORDER,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  Dimensions.RADIUS_DEFAULT,
                ),
              ),
              borderSide: BorderSide(
                  color: Styles.LIGHT_BORDER_COLOR,
                  width: 1,
                  style: BorderStyle.solid),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  Dimensions.RADIUS_DEFAULT,
                ),
              ),
              borderSide: BorderSide(
                  color: Styles.ACCENT_COLOR, width: 1, style: BorderStyle.solid),
            ),
            disabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  Dimensions.RADIUS_DEFAULT,
                ),
              ),
              borderSide: BorderSide(
                  color: Styles.LIGHT_BORDER_COLOR,
                  width: 1,
                  style: BorderStyle.solid),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  Dimensions.RADIUS_DEFAULT,
                ),
              ),
              borderSide: BorderSide(
                  color: Styles.LIGHT_BORDER_COLOR,
                  width: 1,
                  style: BorderStyle.solid),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  Dimensions.RADIUS_DEFAULT,
                ),
              ),
              borderSide: BorderSide(
                  color: Styles.FAILED_COLOR, width: 1, style: BorderStyle.solid),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  Dimensions.RADIUS_DEFAULT,
                ),
              ),
              borderSide: BorderSide(
                  color: Styles.FAILED_COLOR, width: 1, style: BorderStyle.solid),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
            prefixIconConstraints: BoxConstraints(
              maxHeight: 20.h,
            ),
            // labelText: widget.label,
            alignLabelWithHint: false,
            errorStyle: AppTextStyles.w500
                .copyWith(color: Styles.FAILED_COLOR, fontSize: 11),
            labelStyle:
                AppTextStyles.w400.copyWith(color: Styles.DISABLED, fontSize: 14),
          ),

          name: widget.name,
          elevation: 1,
        ),
      ],
    );
  }
}
