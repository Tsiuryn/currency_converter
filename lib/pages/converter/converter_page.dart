import 'package:curency_converter/pages/converter/bloc/converter_bloc.dart';
import 'package:curency_converter/pages/converter/repo/currency_repo.dart';
import 'package:curency_converter/pages/converter/widgets/currency_converter_widget.dart';
import 'package:curency_converter/pages/converter/widgets/list_currencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConverterPage extends StatefulWidget {
  const ConverterPage({super.key});

  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConverterBloc>(
      create: (_) => ConverterBloc(repo: CurrencyRepository()),
      child: BlocBuilder<ConverterBloc, ConverterModel>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Конвертер валют по НБ РБ'),
            ),
            body: Column(
              children: [
                const CurrencyConverterWidget(),
                ListCurrencies(
                  model: state,
                )
              ],
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.date_range_outlined),
              onPressed: () {
                showDatePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now().add(const Duration(days: 1)),
                  currentDate: state.selectedDate,
                ).then((value) {
                  if (value != null) {
                    context.read<ConverterBloc>().fetchCurrencies(dateTime: value);
                  }
                });
              },
            ),
          );
        },
      ),
    );
  }
}
