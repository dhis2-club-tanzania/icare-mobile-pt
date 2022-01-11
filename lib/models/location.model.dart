


class LocationModel {
  final String uuid;
  final String display;

  LocationModel({required this.uuid, required this.display});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    // ignore: unnecessary_null_comparison
    if (json == null) {
    }
    return LocationModel(
        uuid: json["uuid"],
        display: json["display"]
    );
  }

  static List<LocationModel> fromJsonList(List list) {
    if (list == null) return [];
    return list.map((item) => LocationModel.fromJson(item)).toList();
  }

  String dataAsString() {
    return this.display;
  }

  @override
  String toString() => display;
}