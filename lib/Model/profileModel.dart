import 'package:json_annotation/json_annotation.dart';

part 'profileModel.g.dart'; // Import the generated file directly

@JsonSerializable()
class ProfileModel {
  final String name;
  final String username;
  final String profession;
  final String DOB;
  final String titleline;
  final String about;

  ProfileModel({
    required this.DOB,
    required this.about,
    required this.name,
    required this.profession,
    required this.titleline,
    required this.username,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}
