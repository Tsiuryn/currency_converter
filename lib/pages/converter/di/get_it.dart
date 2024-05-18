import 'package:curency_converter/pages/converter/repo/select_currency_repo.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerSingleton<SelectCurrencyRepo>(SelectCurrencyRepoImpl());
}
