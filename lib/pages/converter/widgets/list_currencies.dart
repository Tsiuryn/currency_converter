import 'package:curency_converter/pages/converter/bloc/converter_bloc.dart';
import 'package:curency_converter/pages/converter/repo/model/post.dart';
import 'package:curency_converter/pages/converter/util/currency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListCurrencies extends StatelessWidget {
  final ConverterModel model;

  const ListCurrencies({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: model.posts.length,
          itemBuilder: (_, index) {
            final post = model.posts[index];
            bool isLast = model.posts.length - 1 == index;

            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 50 :  0.0),
              child: CurrencyItem(post: post),
            );
          }),
    );
  }
}

class CurrencyItem extends StatelessWidget {
  final Post post;

  const CurrencyItem({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.curAbbreviation,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Text(post.curName,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  '${post.curScale} ${post.curAbbreviation} = ${post.curOfficialRate} ${Currency.byn.value}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w300,
                      color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
          Text(
            post.curOfficialRate.toString(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.blue,
                  fontSize: 18,
                ),
          ),
        ],
      ),
    );
  }
}
