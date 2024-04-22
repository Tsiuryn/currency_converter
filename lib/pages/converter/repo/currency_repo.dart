// https://www.nbrb.by/api/exrates/

// "yyyy-MM-dd"

//    @GET("rates?periodicity=0")
//     Call<List<Post>> getPosts ();
//
//     @GET("rates?&periodicity=0")
//     Call<List<Post>> getDatePosts (@Query("ondate") String date);

import 'package:curency_converter/pages/converter/repo/api/currency_api.dart';
import 'package:curency_converter/pages/converter/repo/model/post.dart';
import 'package:curency_converter/pages/converter/repo/model/post_bean.dart';
import 'package:dio/dio.dart';

class CurrencyRepository {
  final api = CurrencyApi(Dio());

  Future<List<Post>> getPosts({String? date}) async {
    if(date == null){
      return api.getPosts().then((value) {
        return value.map((e) => e.convertToDomain()).toList();
      });
    }else{
      return api.getPostsByDate(date).then((value) {
        return value.map((e) => e.convertToDomain()).toList();
      });
    }
  }
}
