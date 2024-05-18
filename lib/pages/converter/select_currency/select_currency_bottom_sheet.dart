import 'package:curency_converter/pages/converter/di/get_it.dart';
import 'package:curency_converter/pages/converter/repo/select_currency_repo.dart';
import 'package:curency_converter/pages/converter/util/currency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Future<void> showSelectCurrencyBottomSheet(BuildContext context) {
  return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => StreamBuilder<List<Currency>>(
          stream: getIt.get<SelectCurrencyRepo>().subscribeChangedCurrency(),
          builder: (context, snapshot) {
            // if(snapshot.hasData){
            return SelectCurrencyBottomSheetContent(
              selectedCurrencies: snapshot.data ?? [],
            );
            // }

            // return const SizedBox();
          }));
}

class SelectCurrencyBottomSheetContent extends StatefulWidget {
  final List<Currency> selectedCurrencies;

  const SelectCurrencyBottomSheetContent({
    super.key,
    required this.selectedCurrencies,
  });

  @override
  State<SelectCurrencyBottomSheetContent> createState() =>
      _SelectCurrencyBottomSheetContentState();
}

class _SelectCurrencyBottomSheetContentState
    extends State<SelectCurrencyBottomSheetContent> {
  final Set<Currency> _selectedCurrency = {};

  @override
  void initState() {
    super.initState();
    setSelectedCurrency(widget.selectedCurrencies);
  }

  @override
  void didUpdateWidget(covariant SelectCurrencyBottomSheetContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      setSelectedCurrency(widget.selectedCurrencies);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              runSpacing: 4,
              spacing: 4,
              children: [
                ...Currency.values.map(
                  (e) => e == Currency.unknown
                      ? const SizedBox()
                      : FilterChip(
                          selected: _selectedCurrency.contains(e),
                          label: Text(e.value),
                          onSelected: e == Currency.byn
                              ? null
                              : (value) {
                                  setState(() {
                                    if (value) {
                                      _selectedCurrency.add(e);
                                    } else {
                                      _selectedCurrency.remove(e);
                                    }
                                  });
                                },
                        ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: OutlinedButton(
                onPressed: () {
                  getIt
                      .get<SelectCurrencyRepo>()
                      .setCurrencies(_selectedCurrency.toList());
                  Navigator.of(context).pop();
                },
                child: const Text('Сохранить'),
              ),
            )
          ],
        ),
      ),
    );
  }

  void setSelectedCurrency(List<Currency> currencies) {
    for (var element in currencies) {
      _selectedCurrency.add(element);
    }
  }
}
