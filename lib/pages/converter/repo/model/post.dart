import 'package:curency_converter/pages/converter/util/currency.dart';

class Post {
  final int curId;
  final DateTime date;
  final String curAbbreviation;
  final int curScale;
  final double curOfficialRate;
  final String curName;

  const Post({
    required this.curId,
    required this.date,
    required this.curAbbreviation,
    required this.curScale,
    required this.curOfficialRate,
    required this.curName,
  });

  Currency get currency {
    return Currency.values.firstWhere(
      (element) => element.value == curAbbreviation,
      orElse: () => Currency.byn,
    );
  }
}
