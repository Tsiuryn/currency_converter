import 'package:curency_converter/pages/converter/repo/model/post_bean.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'currency_api.g.dart';

@RestApi(baseUrl: 'https://api.nbrb.by/exrates')
abstract class CurrencyApi {
  factory CurrencyApi(Dio dio, {String baseUrl}) = _CurrencyApi;

  @GET('/rates?periodicity=0')
  Future<List<PostBean>> getPosts();

  @GET('/rates?periodicity=0')
  Future<List<PostBean>> getPostsByDate(@Query('ondate') String date);
}
