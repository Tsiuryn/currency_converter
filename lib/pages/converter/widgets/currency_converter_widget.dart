import 'package:curency_converter/pages/converter/bloc/converter_bloc.dart';
import 'package:curency_converter/pages/converter/util/currency.dart';
import 'package:curency_converter/pages/converter/util/currency_converter_controller.dart';
import 'package:curency_converter/pages/converter/widgets/card_widget.dart';
import 'package:curency_converter/pages/converter/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CurrencyConverterWidget extends StatefulWidget {
  const CurrencyConverterWidget({super.key});

  @override
  State<CurrencyConverterWidget> createState() =>
      _CurrencyConverterWidgetState();
}

class _CurrencyConverterWidgetState extends State<CurrencyConverterWidget> {
  late CurrencyConverterController _cController;
  ConverterModel _model = ConverterModel.empty();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _cController = CurrencyConverterController(
        converter: AppCurrencyConverter(
          (input, output, value) {
            return currencyConverter(
              inputCurrency: input,
              outputCurrency: output,
              value: value,
              model: _model,
            );
          },
        ),
        // currencies: [Currency.byn, Currency.eur,]
        currencies: _model.currencies);
  }

  @override
  void dispose() {
    super.dispose();
    _cController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConverterBloc, ConverterModel>(
        builder: (context, state) {
      _model = state;

      if (_selectedDate != state.selectedDate) {
        _cController.clearData();
        _selectedDate = state.selectedDate;
      }

      final date = state.converterStates == ConverterStates.loading
          ? ''
          : DateFormat.yMMMMd('ru').format(_selectedDate ?? DateTime.now());
      return CardWidget(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'на $date',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Visibility(
                  visible: state.converterStates == ConverterStates.loading,
                  child: const SizedBox(
                    height: 12,
                    width: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                )
              ],
            ),
          ),
          ..._cController.currencies.map((currency) {
            return Row(
              children: [
                Expanded(
                  child: InputWidget(
                    key: _cController.textControllers[currency]?.inputKey,
                    prefix: currency.value,
                    readOnly: false,
                    controller:
                        _cController.textControllers[currency]?.controller,
                    focusNode:
                        _cController.textControllers[currency]?.focusNode,
                    onTapClear: () {
                      _cController.onTapClearButton(currency);
                    },
                  ),
                ),
              ],
            );
          })
        ],
      ));
    });
  }

  void _unfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}

class AppCurrencyConverter implements Converter {
  final String Function(
      Currency inputCurrency, Currency outputCurrency, double value) convert;

  AppCurrencyConverter(this.convert);

  @override
  String convertInput(
      {required Currency inputCurrency,
      required Currency outputCurrency,
      required double value}) {
    return convert(inputCurrency, outputCurrency, value);
  }
}
