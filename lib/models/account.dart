import 'package:hashr/models/model_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class Account extends ModelBase {
  @JsonKey(name: "apporsitename")
  String? apporsitename = "";
  @JsonKey(name: "description")
  String? desciption = "";
  @JsonKey(name: "hash")
  String? hash = "";
  @JsonKey(name: "username")
  String? username = "";

  @JsonKey(ignore: true)
  @JsonKey(name: "salt")
  String? salt = "";

  Account(
      {id,
      required this.apporsitename,
      this.desciption,
      this.hash,
      this.salt,
      required this.username});

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
  Map<String, dynamic> toJson() => _$AccountToJson(this);
}
