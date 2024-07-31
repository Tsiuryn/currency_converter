import 'package:collection/collection.dart';
import 'package:curency_converter/pages/converter/di/get_it.dart';
import 'package:curency_converter/pages/converter/repo/model/post.dart';
import 'package:curency_converter/pages/converter/repo/select_currency_repo.dart';
import 'package:curency_converter/pages/converter/util/currency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

/*Future<void> showSelectCurrencyBottomSheet(BuildContext context,
    {required List<Post> posts}) {
  return showDialog(
    context: context,
    useSafeArea: true,
    builder: (_) => AlertDialog(
      title: Text('Выберите валюту:', style: TextStyle(
        fontSize: 16,
      ),),
      contentPadding: EdgeInsets.zero,
      actions: [
        TextButton(onPressed: (){}, child: Text('Отмена')),
        TextButton(onPressed: (){}, child: Text('Отмена')),
        TextButton(onPressed: (){}, child: Text('Отмена')),
      ],
      content: StreamBuilder<List<Currency>>(
        stream: getIt.get<SelectCurrencyRepo>().subscribeChangedCurrency(),
        builder: (context, snapshot) {
          return SelectCurrencyBottomSheetContent(
            selectedCurrencies: snapshot.data ?? [],
            posts: posts,
          );
        },
      ),
    ),
  );
}*/

class SelectCurrency extends StatelessWidget {
  const SelectCurrency({
    super.key,
    required this.posts,
  });

  final List<Post> posts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<Currency>>(
          stream: getIt.get<SelectCurrencyRepo>().subscribeChangedCurrency(),
          builder: (context, snapshot) {
            return SelectCurrencyBottomSheetContent(
              selectedCurrencies: snapshot.data ?? [],
              posts: posts,
            );
          },
        ),
      ),
    );
  }
}

class SelectCurrencyBottomSheetContent extends StatefulWidget {
  final List<Currency> selectedCurrencies;
  final List<Post> posts;

  const SelectCurrencyBottomSheetContent({
    super.key,
    required this.selectedCurrencies,
    required this.posts,
  });

  @override
  State<SelectCurrencyBottomSheetContent> createState() =>
      _SelectCurrencyBottomSheetContentState();
}

class _SelectCurrencyBottomSheetContentState
    extends State<SelectCurrencyBottomSheetContent> {
  final Set<Currency> _selectedCurrency = {};
  bool _isSelectedAll = false;

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
      _isSelectedAll = widget.selectedCurrencies.length > 1;
    });
  }

  void onTapSelectedAll() {
    setState(() {
      if (_isSelectedAll) {
        _selectedCurrency.clear();
        _selectedCurrency.add(Currency.byn);
        _isSelectedAll = !_isSelectedAll;
      } else {
        var currencies = List<Currency>.from(Currency.values);
        currencies.remove(Currency.byn);
        currencies.remove(Currency.unknown);
        _isSelectedAll = !_isSelectedAll;
        setSelectedCurrency(currencies);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cur = List<Currency>.from(Currency.values)
      ..sort((a, b) => a.value.compareTo(b.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: IconButton(
            onPressed: Navigator.of(context).pop,
            icon: Icon(Icons.close_rounded),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...cur.map((e) {
                  var name = widget.posts
                          .firstWhereOrNull((post) => post.currency == e)
                          ?.curName ??
                      '';
                  if (e == Currency.byn) {
                    name = 'Белорусский рубль';
                  }
                  return e == Currency.unknown
                      ? const SizedBox()
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SwitchListTile(
                                activeTrackColor:
                                    e == Currency.byn ? null : Colors.blue,
                                title: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          e.value,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            ' $name',
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                GoogleFonts.cormorantGaramond()
                                                    .copyWith(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                visualDensity: const VisualDensity(
                                    horizontal: VisualDensity.minimumDensity,
                                    vertical: VisualDensity.minimumDensity),
                                value: _selectedCurrency.contains(e),
                                // enabled: e != Currency.byn,
                                onChanged: e == Currency.byn
                                    ? null
                                    : (value) {
                                        setState(() {
                                          if (value == true) {
                                            _selectedCurrency.add(e);
                                          } else {
                                            _selectedCurrency.remove(e);
                                          }
                                          _isSelectedAll =
                                              _selectedCurrency.length > 1;
                                        });
                                      }),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Divider(),
                            )
                          ],
                        );
                }),
              ],
            ),
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: IconButton(
                  onPressed: () {
                    getIt
                        .get<SelectCurrencyRepo>()
                        .setCurrencies(_selectedCurrency.toList());
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.save,
                    size: 32,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: onTapSelectedAll,
                  icon: Icon(
                    _isSelectedAll
                        ? Icons.remove_done_rounded
                        : Icons.done_all_rounded,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  void setSelectedCurrency(List<Currency> currencies) {
    for (var element in currencies) {
      _selectedCurrency.add(element);
    }
  }
}
