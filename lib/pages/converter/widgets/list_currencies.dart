import 'package:curency_converter/pages/converter/bloc/converter_bloc.dart';
import 'package:curency_converter/pages/converter/repo/model/post.dart';
import 'package:curency_converter/pages/converter/util/currency.dart';
import 'package:curency_converter/pages/converter/util/highlight_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListCurrencies extends StatefulWidget {
  final ConverterModel model;

  const ListCurrencies({
    super.key,
    required this.model,
  });

  @override
  State<ListCurrencies> createState() => _ListCurrenciesState();
}

class _ListCurrenciesState extends State<ListCurrencies> {
  String _searchValue = '';

  List<Post> _filteredList() {
    return widget.model.posts.where((element) {
      return element.currency.value
              .toLowerCase()
              .contains(_searchValue.toLowerCase()) ||
          element.curName.toLowerCase().contains(_searchValue.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CupertinoTextField(
            prefix: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(
                Icons.search_rounded,
                color: Colors.grey,
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchValue = value;
              });
            },
          ),
        ),
        Expanded(
          child: ListView.separated(
              itemCount: filteredList.length,
              separatorBuilder: (_, index) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(),
                );
              },
              itemBuilder: (_, index) {
                final post = filteredList[index];
                bool isLast = filteredList.length - 1 == index;

                return Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 60 : 0.0),
                  child: CurrencyItem(
                    post: post,
                    searchValue: _searchValue,
                  ),
                );
              }),
        ),
      ],
    );
  }
}

class CurrencyItem extends StatelessWidget {
  final Post post;
  final String searchValue;

  const CurrencyItem({
    super.key,
    required this.post,
    required this.searchValue,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ) ??
        const TextStyle();

    final descriptionStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w300,
              color: Colors.grey,
            ) ??
        const TextStyle();
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: highlightText(
                    context: context,
                    value: post.curAbbreviation,
                    searchQuery: searchValue,
                    textStyle: titleStyle,
                    textHighLightStyle: titleStyle.copyWith(
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                ),
                RichText(
                  text: highlightText(
                    context: context,
                    value:
                        '${post.curScale} ${post.curName} = ${post.curOfficialRate} ${Currency.byn.value}',
                    searchQuery: searchValue,
                    textStyle: descriptionStyle,
                    textHighLightStyle: descriptionStyle.copyWith(
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            post.curOfficialRate.toString(),
            style: GoogleFonts.alumniSans(
              color: Colors.blue,
              fontSize: 28,
            ),
          ),
        ],
      ),
    );
  }
}
