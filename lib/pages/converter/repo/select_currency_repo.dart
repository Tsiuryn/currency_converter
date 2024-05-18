import 'dart:convert';

import 'package:curency_converter/pages/converter/util/currency.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _selectedCurrencyKey = 'selectedCurrencyKey';

abstract interface class SelectCurrencyRepo {
  Future<bool> setCurrencies(List<Currency> currencies);

  Stream<List<Currency>> subscribeChangedCurrency();
}

class SelectCurrencyRepoImpl implements SelectCurrencyRepo {
  Future<SharedPreferences> get _pref => SharedPreferences.getInstance();

  SelectCurrencyRepoImpl() {
    _getSelectedCurrencies();
  }

  final BehaviorSubject<List<Currency>> _subject = BehaviorSubject();

  Future<void> _getSelectedCurrencies() async {
    final pref = await _pref;
    final listCurText = pref.getStringList(_selectedCurrencyKey);
    final List<Currency> currencies = listCurText != null
        ? listCurText
            .map((e) => Currency.values.firstWhere(
                  (element) => e == element.value,
                  orElse: () => Currency.unknown,
                ))
            .toList()
        : [Currency.byn];

    _subject.value = currencies;
  }

  @override
  Future<bool> setCurrencies(List<Currency> currencies) async {
    final pref = await _pref;

    return pref
        .setStringList(
            _selectedCurrencyKey, currencies.map((e) => e.value).toList())
        .then((value) {
      if (value) {
        _subject.value = currencies;
      }

      return value;
    });
  }

  @override
  Stream<List<Currency>> subscribeChangedCurrency() {
    return _subject.stream;
  }
}
