import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:easy_localization/easy_localization.dart';

class I18nUtils {
  static String t(
    String value, {
    List<String>? args,
    Map<String, String>? namedArgs,
    String? gender,
  }) {
    try {
      return tr(
        value,
        args: args,
        namedArgs: namedArgs,
        gender: gender,
      );
    } on NoSuchMethodError {
      return value;
    }
  }

  static String? countryCode(BuildContext context) {
    Locale? locale = EasyLocalization.of(context)?.locale;
    return locale?.countryCode;
  }

  static String? languageCode(BuildContext context) {
    Locale? locale = EasyLocalization.of(context)?.locale;
    return locale?.languageCode;
  }

  static Future initDateFormat(BuildContext context) {
    return initializeDateFormatting(
        I18nUtils.languageCode(context)?.toLowerCase());
  }

  static String getEnumLabel(dynamic value) {
    String label = value.toString();
    return tr(label);
  }
}
