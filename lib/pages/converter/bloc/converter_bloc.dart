import 'package:curency_converter/pages/converter/repo/currency_repo.dart';
import 'package:curency_converter/pages/converter/repo/model/post.dart';
import 'package:curency_converter/pages/converter/repo/select_currency_repo.dart';
import 'package:curency_converter/pages/converter/util/currency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ConverterBloc extends Cubit<ConverterModel> {
  final CurrencyRepository repo;
  final SelectCurrencyRepo selectCurrencyRepo;

  ConverterBloc({
    required this.repo,
    required this.selectCurrencyRepo,
  }) : super(ConverterModel.empty()) {
    fetchCurrencies();
    _listenSelectedCurrency();
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
          changedCurrencies: false));
    } catch (e) {
      emit(state.copyWith(
        converterStates: ConverterStates.error,
        changedCurrencies: false,
      ));
    }
  }

  void _listenSelectedCurrency() {
    selectCurrencyRepo.subscribeChangedCurrency().listen((event) {
      emit(
        state.copyWith(currencies: event, changedCurrencies: true),
      );
    });
  }
}

class ConverterModel {
  final List<Currency> currencies;
  final ConverterStates converterStates;
  final List<Post> posts;
  final bool changedCurrencies;
  final DateTime selectedDate;

  const ConverterModel({
    required this.converterStates,
    required this.posts,
    required this.currencies,
    required this.selectedDate,
    required this.changedCurrencies,
  });

  ConverterModel.empty()
      : posts = [],
        converterStates = ConverterStates.initial,
        currencies = [],
        changedCurrencies = false,
        selectedDate = DateTime.now();

  ConverterModel copyWith({
    List<Currency>? currencies,
    ConverterStates? converterStates,
    List<Post>? posts,
    bool? changedCurrencies,
    DateTime? selectedDate,
  }) {
    return ConverterModel(
      currencies: currencies ?? this.currencies,
      converterStates: converterStates ?? this.converterStates,
      posts: posts ?? this.posts,
      changedCurrencies: changedCurrencies ?? this.changedCurrencies,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}

enum ConverterStates { initial, loading, success, error }
