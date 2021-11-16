// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      id: json['id'],
      apporsitename: json['apporsitename'] as String?,
      desciption: json['description'] as String?,
      hash: json['hash'] as String?,
      username: json['username'] as String?,
    )
      ..createdOn = DateTime.parse(json['created_on'] as String)
      ..modifiedOn = json['modified_on'] == null
          ? null
          : DateTime.parse(json['modified_on'] as String);

Map<String, dynamic> _$AccountToJson(Account instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['created_on'] = instance.createdOn.toIso8601String();
  val['modified_on'] = instance.modifiedOn?.toIso8601String();
  val['apporsitename'] = instance.apporsitename;
  val['description'] = instance.desciption;
  val['hash'] = instance.hash;
  val['username'] = instance.username;
  return val;
}
