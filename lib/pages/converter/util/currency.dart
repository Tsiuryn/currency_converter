import 'package:collection/collection.dart';
import 'package:curency_converter/pages/converter/bloc/converter_bloc.dart';
import 'package:curency_converter/pages/converter/repo/model/post.dart';

enum Currency {
  byn('BYN'),
  usd('USD'),
  eur('EUR'),
  rub('RUB'),
  aud('AUD'),
  amd('AMD'),
  bgn('BGN'),
  brl('BRL'),
  uah('UAH'),
  dkk('DKK'),
  aed('AED'),
  vnd('VND'),
  pln('PLN'),
  jpy('JPY'),
  inr('INR'),
  irr('IRR'),
  isk('ISK'),
  cad('CAD'),
  cny('CNY'),
  kwd('KWD'),
  mdl('MDL'),
  nzd('NZD'),
  nok('NOK'),
  xdr('XDR'),
  sgd('SGD'),
  kgs('KGS'),
  kzt('KZT'),
  tur('TRY'),
  gbp('GBP'),
  czk('CZK'),
  sek('SEK'),
  chf('CHF'),
  unknown('');

  const Currency(this.value);

  final String value;
}

String currencyConverter({
  required Currency inputCurrency,
  required Currency outputCurrency,
  required double value,
  required ConverterModel model,
}) {
  final outputPost = model.posts
      .firstWhereOrNull((element) => element.currency == outputCurrency);
  final inputPost = model.posts
      .firstWhereOrNull((element) => element.currency == inputCurrency);
  if (inputCurrency == Currency.byn) {
    if (outputPost == null) return 'nan';

    return convertBynToCurrency(post: outputPost, value: value).roundNumber(4);
  }
  if (outputCurrency == Currency.byn) {
    if (inputPost == null) return 'nan';

    return convertCurrencyToByn(post: inputPost, value: value).roundNumber(4);
  }

  if (inputPost == null || outputPost == null) {
    return 'nan';
  }

  final inByn = convertCurrencyToByn(post: inputPost, value: value);

  return convertBynToCurrency(post: outputPost, value: inByn).roundNumber(4);
}

double convertBynToCurrency({
  required Post post,
  required double value,
}) {
  return (value * post.curScale / post.curOfficialRate);
}

double convertCurrencyToByn({
  required Post post,
  required double value,
}) {
  return (value * post.curOfficialRate / post.curScale);
}

extension MathExtension on double {
  ///
  /// int fractionDigits = 2
  ///
  /// Example double num = 2.00009232; Result - 2
  ///
  /// Example double num = 2.0009; Result - 2
  ///
  /// Example double num = 2.009; Result - 2.01
  ///
  /// Example double num = 2.90; Result - 2.90
  ///
  String roundNumber(int fractionDigits) {
    int roundNumb = toInt();
    double testNum = double.parse(toStringAsFixed(fractionDigits));
    if ((testNum - roundNumb.toDouble()) > 0) {
      return toStringAsFixed(fractionDigits);
    } else {
      return roundNumb.toString();
    }
  }
}
