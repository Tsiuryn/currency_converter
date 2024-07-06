import 'package:curency_converter/pages/converter/bloc/converter_bloc.dart';
import 'package:curency_converter/pages/converter/select_currency/select_currency_bottom_sheet.dart';
import 'package:curency_converter/pages/converter/util/currency.dart';
import 'package:curency_converter/pages/converter/util/currency_converter_controller.dart';
import 'package:curency_converter/pages/converter/widgets/input_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    _cController = getCurrencyController(_model.currencies);
  }

  void _updateController(List<Currency> currencies) {
    _cController.dispose();
    setState(() {
      _cController = getCurrencyController(currencies);
    });
  }

  CurrencyConverterController getCurrencyController(
          List<Currency> currencies) =>
      CurrencyConverterController(
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
        currencies: currencies,
      );

  @override
  void dispose() {
    super.dispose();
    _cController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConverterBloc, ConverterModel>(
      listener: (context, state) {
        if (state.changedCurrencies) {
          _updateController(state.currencies);
        }
      },
      builder: (context, state) {
        _model = state;

        if (_selectedDate != state.selectedDate) {
          _cController.clearData();
          _selectedDate = state.selectedDate;
        }

        return Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 84,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 8,
              ),
              // Stack(
              //   alignment: Alignment.centerRight,
              //   children: [
              //     Row(
              //       children: [
              //         Expanded(
              //           child: Column(
              //             mainAxisSize: MainAxisSize.min,
              //             children: [
              //               const Icon(Icons.keyboard_arrow_up_rounded),
              //               Padding(
              //                 padding: const EdgeInsets.only(bottom: 16.0),
              //                 child: Text(
              //                   'Конвертер валют',
              //                   style: Theme.of(context).textTheme.bodyMedium,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //     IconButton(
              //       onPressed: () {
              //         showSelectCurrencyBottomSheet(context);
              //       },
              //       icon: const Icon(Icons.select_all_rounded),
              //     ),
              //   ],
              // ),
              ..._cController.currencies.map(
                (currency) {
                  return Row(
                    children: [
                      Expanded(
                        child: InputWidget(
                          key: _cController.textControllers[currency]?.inputKey,
                          prefix: currency.value,
                          readOnly: false,
                          controller: _cController
                              .textControllers[currency]?.controller,
                          focusNode:
                              _cController.textControllers[currency]?.focusNode,
                          onTapClear: () {
                            _cController.onTapClearButton(currency);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
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
