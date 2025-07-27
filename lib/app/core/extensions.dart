import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../data/config/di.dart';
import '../../features/language/bloc/language_bloc.dart';

extension CountryFlagEmoji on String {
  /// Converts a 2-letter country code (ISO 3166-1 alpha-2) to a flag emoji.
  /// Example: "US" => 🇺🇸
  String get toFlagEmoji {
    if (length != 2) return this; // fallback if not valid code

    final int base = 0x1F1E6; // Regional Indicator Symbol Letter A
    final upper = toUpperCase();

    final int first = upper.codeUnitAt(0) - 0x41 + base;
    final int second = upper.codeUnitAt(1) - 0x41 + base;

    return String.fromCharCode(first) + String.fromCharCode(second);
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }



  Color get toColor {
    String colorStr = this;
    colorStr = "FF$colorStr";
    colorStr = colorStr.replaceAll("#", "");
    int val = 0;
    int len = colorStr.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = colorStr.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw const FormatException(
            "An error occurred when converting a color");
      }
    }
    return Color(val);
  }

  String hiddenNumber() {
    return this[length - 2] + this[length - 1] + "*" * (length - 2);
  }
}

extension DateExtention on DateTime {
  String dateTimeFormatChat() {
    return DateFormat("dd-MM-y - hh:mm aa",sl<LanguageBloc>().selectLocale!.languageCode).format(this);
  }
  String dateFormat({required String format, String? lang}) {
    return DateFormat(
            format,
        // sl<LanguageBloc>().selectLocale!.languageCode
    )
        .format(this);
  }

  String arTimeFormat() {
    return DateFormat("hh,mm aa").format(this);
  }
}

extension DefaultFormat on DateTime {
  String defaultFormat() {
    return DateFormat("d MMM yyyy").format(this);
  }

  String defaultFormat2() {
    return DateFormat("d/M/yyyy").format(this);
  }
}

String localeCode = sl<LanguageBloc>().selectLocale!.languageCode;

extension ProposalStatusExtension on int {
  String get proposalStatusText {
    switch (this) {
      case 1:
        return 'pendingRequest';
      case 2:
        return 'acceptedRequest';
      case 3:
        return 'rejectedRequest';
      case 4:
        return 'Accepted';
      case 5:
        return 'cancelRequest';
      default:
        return 'Unknown';
    }
  }
}

extension ConvertDigits on String {
  String convertDigits() {
    var sb = StringBuffer();
    if (localeCode == "en") {
      return this;
    } else {
      for (int i = 0; i < length; i++) {
        switch (this[i]) {
          case '0':
            sb.write('٠');
            break;
          case '1':
            sb.write('۱');
            break;
          case '2':
            sb.write('۲');
            break;
          case '3':
            sb.write('۳');
            break;
          case '4':
            sb.write('٤');
            break;
          case '5':
            sb.write('٥');
            break;
          case '6':
            sb.write('٦');
            break;
          case '7':
            sb.write('٧');
            break;
          case '8':
            sb.write('۸');
            break;
          case '9':
            sb.write('۹');
            break;
          default:
            sb.write(this[i]);
            break;
        }
      }
    }
    return sb.toString();
  }
}

extension MediaQueryValues on BuildContext {
  double get height => MediaQuery.of(this).size.height;

  double get width => MediaQuery.of(this).size.width;

  double get toPadding => MediaQuery.of(this).viewPadding.top;

  double get bottom => MediaQuery.of(this).viewInsets.bottom;
}
