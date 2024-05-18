import 'package:curency_converter/pages/converter/bloc/converter_bloc.dart';
import 'package:curency_converter/pages/converter/di/get_it.dart';
import 'package:curency_converter/pages/converter/repo/currency_repo.dart';
import 'package:curency_converter/pages/converter/repo/select_currency_repo.dart';
import 'package:curency_converter/pages/converter/widgets/currency_converter_widget.dart';
import 'package:curency_converter/pages/converter/widgets/list_currencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ConverterPage extends StatefulWidget {
  const ConverterPage({super.key});

  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConverterBloc>(
      create: (_) => ConverterBloc(
        repo: CurrencyRepository(),
        selectCurrencyRepo: getIt.get<SelectCurrencyRepo>(),
      ),
      child: BlocBuilder<ConverterBloc, ConverterModel>(
        builder: (context, state) {
          final date = state.converterStates == ConverterStates.loading
              ? ''
              : DateFormat.yMMMMd('ru').format(state.selectedDate);
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              appBar: AppBar(
                  title: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Курсы валют НБ РБ'),
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
                                visible: state.converterStates ==
                                    ConverterStates.loading,
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
                      ],
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.date_range_outlined),
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          locale: const Locale('ru'),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now().add(const Duration(days: 1)),
                          currentDate: DateTime.now(),
                          initialDate: state.selectedDate,
                        ).then((value) {
                          if (value != null) {
                            context
                                .read<ConverterBloc>()
                                .fetchCurrencies(dateTime: value);
                          }
                        });
                      },
                    ),
                  ]),
              body: Stack(
                fit: StackFit.expand,
                children: [
                  ListCurrencies(
                    model: state,
                  ),
                  DraggableScrollableSheet(
                    initialChildSize: 0.08,
                    minChildSize: 0.08,
                    maxChildSize: 0.5,
                    snap: true,
                    builder: (context, controller) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12)),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                                child: SingleChildScrollView(
                                    controller: controller,
                                    child: const CurrencyConverterWidget())),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
