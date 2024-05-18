import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// RU: [highlightText] функция выделения текста:
/// [value] - основной текст, который нужно выделить;
/// [searchQuery] - искомый текст в основном тексте;
/// [textStyle] - стиль основного текста (аргумент не обязательный, по умолчанию используется [UnibankStyles.listItemSubtitleTextStyle]);
/// [textHighLightStyle] - стиль выделенного текста (аргумент не обязательный, по умолчанию используется [UnibankStyles.listItemTitleTextStyle]);
///
/// ENG: [highlightText] is a text highlighting function:
/// [value] - the main text to be highlighting;
/// [searchQuery] - the search text in the main text;
/// [textStyle] - style of the main text (the argument is optional, by default [UnibankStyles.listItemSubtitleTextStyle]);
/// [textHighLightStyle] - style of the selected text (the argument is optional, the default is [UnibankStyles.listItemTitleTextStyle]);
///
TextSpan highlightText({
  required BuildContext context,
  required String value,
  required String searchQuery,
  Function? onHighlightedTextTap,
  required TextStyle textStyle,
  required TextStyle textHighLightStyle,
}) {
  TextStyle defStyle = textStyle;
  TextStyle customStyle = textHighLightStyle;

  List<InlineSpan> children = [];
  final lowerValue = value.toLowerCase();
  final lowerSearchQuery = searchQuery.toLowerCase();

  if (searchQuery.isNotEmpty && lowerValue.contains(lowerSearchQuery)) {
    var firstIndex = lowerValue.indexOf(lowerSearchQuery);
    var lastIndex = lowerValue.indexOf(lowerSearchQuery) + searchQuery.length;

    children
      ..add(TextSpan(text: value.substring(0, firstIndex)))
      ..add(TextSpan(
        style: customStyle,
        text: value.substring(firstIndex, lastIndex),
        recognizer: TapGestureRecognizer()
          ..onTap = onHighlightedTextTap as GestureTapCallback?,
      ))
      ..add(TextSpan(text: value.substring(lastIndex, value.length)));
  } else {
    children.add(TextSpan(text: value));
  }

  return TextSpan(style: defStyle, children: children);
}
