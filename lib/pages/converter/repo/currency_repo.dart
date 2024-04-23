// https://www.nbrb.by/api/exrates/

// "yyyy-MM-dd"

//    @GET("rates?periodicity=0")
//     Call<List<Post>> getPosts ();
//
//     @GET("rates?&periodicity=0")
//     Call<List<Post>> getDatePosts (@Query("ondate") String date);

import 'package:collection/collection.dart';
import 'package:curency_converter/pages/converter/repo/api/currency_api.dart';
import 'package:curency_converter/pages/converter/repo/model/post.dart';
import 'package:curency_converter/pages/converter/repo/model/post_bean.dart';
import 'package:curency_converter/pages/converter/util/currency.dart';
import 'package:dio/dio.dart';

class CurrencyRepository {
  final api = CurrencyApi(Dio());

  Future<List<Post>> getPosts({String? date}) async {
    List<Post> posts;
    if (date == null) {
      posts = await api.getPosts().then((value) {
        return value.map((e) => e.convertToDomain()).toList();
      });
    } else {
      posts = await api.getPostsByDate(date).then((value) {
        return value.map((e) => e.convertToDomain()).toList();
      });
    }

    return _sortPosts(posts);
  }

  List<Post> _sortPosts(List<Post> posts) {
    if (posts.isEmpty) return posts;
    final listCurrency = [
      Currency.usd,
      Currency.eur,
      Currency.rur,
      Currency.gbp
    ];
    final currentListPost = [...posts];
    for (var i = 0; i < listCurrency.length; ++i) {
      final post = currentListPost
          .firstWhereOrNull((e) => e.currency == listCurrency[i]);
      if (post != null) {
        currentListPost.remove(post);
        currentListPost.insert(i, post);
      }
    }
    return currentListPost;
  }
}
