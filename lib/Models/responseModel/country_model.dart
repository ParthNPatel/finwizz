class CountryModel {
  final String name;
  final String flag;
  final String code;
  final String dial_code;

  CountryModel(this.name, this.flag, this.code, this.dial_code);

  factory CountryModel.fromJson(dynamic json) {
    return CountryModel(
      json['name'] as String,
      json['flag'] as String,
      json['code'] as String,
      json['dial_code'] as String,
    );
  }
}
