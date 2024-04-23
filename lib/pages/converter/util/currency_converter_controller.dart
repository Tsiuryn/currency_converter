import 'package:curency_converter/pages/converter/util/currency.dart';
import 'package:curency_converter/pages/converter/widgets/input_widget.dart';
import 'package:flutter/material.dart';

class CurrencyConverterController {
  final Converter converter;
  final List<Currency> currencies;

  CurrencyConverterController({
    required this.converter,
    this.currencies = Currency.values,
  }) {
    _initTextControllers();
    _selectedCurrency = currencies.firstOrNull ?? Currency.byn;
  }

  late Currency _selectedCurrency;
  final Map<Currency, InputData> textControllers = {};

  bool _usedController = false;

  void onTapClearButton(Currency type) {
    if (!_usedController) {
      textControllers[type]?.controller.text = '';
    }
  }

  void clearData() {
    _usedController = true;
    textControllers.forEach((key, value) {
      value.controller.text = '';
    });
    _usedController = false;
  }

  void _initTextControllers() {
    for (var currency in currencies) {
      final controller = TextEditingController();
      final focusNode = FocusNode();
      final key = GlobalKey<InputWidgetState>();
      textControllers[currency] = InputData(
          inputKey: key, controller: controller, focusNode: focusNode);
      controller.addListener(() {
        _controllerListener(currency, controller);
      });
      focusNode.addListener(() {
        _focusListener(currency, focusNode);
      });
    }
  }

  void _focusListener(Currency currency, FocusNode focus) {
    if (focus.hasFocus) {
      _selectedCurrency = currency;
    }
    final inputKey = textControllers[currency]?.inputKey;
    if (!focus.hasFocus) {
      inputKey?.currentState?.clearButton(false);
    }
    if (currency != _selectedCurrency) return;

    final text = textControllers[currency]?.controller.text ?? '';
    if (focus.hasFocus) {
      inputKey?.currentState?.clearButton(text.isNotEmpty);
    }
  }

  void _controllerListener(
      Currency currency, TextEditingController controller) {
    final focusNode = textControllers[currency]?.focusNode;
    if (focusNode != null) {
      _focusListener(currency, focusNode);
    }

    if (_selectedCurrency == currency && !_usedController) {
      _usedController = true;
      final value = double.tryParse(controller.text) ?? 0;
      textControllers.forEach((cur, data) {
        if (cur != currency) {
          data.controller.text = converter.convertInput(
            inputCurrency: currency,
            outputCurrency: cur,
            value: value,
          );
        }
      });
      _usedController = false;
    }
  }

  void dispose() {
    textControllers.forEach((key, value) {
      value.controller.dispose();
      value.focusNode.dispose();
    });
  }
}

class InputData {
  final GlobalKey<InputWidgetState> inputKey;
  final TextEditingController controller;
  final FocusNode focusNode;

  const InputData({
    required this.inputKey,
    required this.controller,
    required this.focusNode,
  });
}

abstract class Converter {
  String convertInput({
    required Currency inputCurrency,
    required Currency outputCurrency,
    required double value,
  });
}
