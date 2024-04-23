import 'package:curency_converter/pages/converter/repo/currency_repo.dart';
import 'package:curency_converter/pages/converter/repo/model/post.dart';
import 'package:curency_converter/pages/converter/util/currency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ConverterBloc extends Cubit<ConverterModel> {
  final CurrencyRepository repo;

  ConverterBloc({
    required this.repo,
  }) : super(ConverterModel.empty()) {
    fetchCurrencies();
  }

  void fetchCurrencies({DateTime? dateTime}) async {
    try {
      emit(state.copyWith(converterStates: ConverterStates.loading));
      late List<Post> posts;
      if (dateTime != null) {
        final formatter = DateFormat('yyyy-MM-dd');
        posts = await repo.getPosts(date: formatter.format(dateTime));
      } else {
        posts = await repo.getPosts();
      }
      emit(state.copyWith(
        converterStates: ConverterStates.success,
        posts: posts,
        selectedDate: dateTime,
      ));
    } catch (e) {
      emit(state.copyWith(converterStates: ConverterStates.error));
    }
  }
}

class ConverterModel {
  final List<Currency> currencies;
  final ConverterStates converterStates;
  final List<Post> posts;
  final DateTime selectedDate;

  const ConverterModel({
    required this.converterStates,
    required this.posts,
    required this.currencies,
    required this.selectedDate,
  });

  ConverterModel.empty()
      : posts = [],
        converterStates = ConverterStates.initial,
        currencies = [
          Currency.byn,
          Currency.usd,
          Currency.eur,
          Currency.rur,
        ],
        selectedDate = DateTime.now();

  ConverterModel copyWith({
    List<Currency>? currencies,
    ConverterStates? converterStates,
    List<Post>? posts,
    DateTime? selectedDate,
  }) {
    return ConverterModel(
      currencies: currencies ?? this.currencies,
      converterStates: converterStates ?? this.converterStates,
      posts: posts ?? this.posts,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}

enum ConverterStates { initial, loading, success, error }
