// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostBean _$PostBeanFromJson(Map<String, dynamic> json) => PostBean(
      curId: (json['Cur_ID'] as num?)?.toInt(),
      date: json['Date'] as String?,
      curAbbreviation: json['Cur_Abbreviation'] as String?,
      curScale: (json['Cur_Scale'] as num?)?.toInt(),
      curOfficialRate: (json['Cur_OfficialRate'] as num?)?.toDouble(),
      curName: json['Cur_Name'] as String?,
    );

Map<String, dynamic> _$PostBeanToJson(PostBean instance) => <String, dynamic>{
      'Cur_ID': instance.curId,
      'Date': instance.date,
      'Cur_Abbreviation': instance.curAbbreviation,
      'Cur_Scale': instance.curScale,
      'Cur_OfficialRate': instance.curOfficialRate,
      'Cur_Name': instance.curName,
    };
