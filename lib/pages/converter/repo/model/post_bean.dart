import 'package:curency_converter/pages/converter/repo/model/post.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_bean.g.dart';

@JsonSerializable()
class PostBean {
  @JsonKey(name: 'Cur_ID')
  final int? curId;

  @JsonKey(name: 'Date')
  final String? date;

  @JsonKey(name: 'Cur_Abbreviation')
  final String? curAbbreviation;

  @JsonKey(name: 'Cur_Scale')
  final int? curScale;

  @JsonKey(name: 'Cur_OfficialRate')
  final double? curOfficialRate;

  @JsonKey(name: 'Cur_Name')
  final String? curName;

  const PostBean({
    required this.curId,
    required this.date,
    required this.curAbbreviation,
    required this.curScale,
    required this.curOfficialRate,
    required this.curName,
  });

  factory PostBean.fromJson(Map<String, dynamic> json) =>
      _$PostBeanFromJson(json);

  Map<String, dynamic> toJson() => _$PostBeanToJson(this);
}

extension PostBeanExtension on PostBean {
  Post convertToDomain() {
    return Post(
      curId: curId ?? -1,
      date: DateTime.tryParse(date ?? '') ?? DateTime(1970),
      curAbbreviation: curAbbreviation ?? '',
      curScale: curScale ?? -1,
      curOfficialRate: curOfficialRate ?? -1,
      curName: curName ?? '',
    );
  }
}
