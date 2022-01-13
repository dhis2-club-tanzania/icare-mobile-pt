class DrugResults {
  final dynamic results;
  DrugResults(this.results);
}



class DataModel {
  final String uuid;
  final String display;
  final dynamic concept;

  DataModel({required this.uuid, required this.display, this.concept});

  factory DataModel.fromJson(Map<String, dynamic> json) {
    // ignore: unnecessary_null_comparison
    if (json == null) {
    }
    return DataModel(
      uuid: json["uuid"],
      display: json["display"],
      concept: {
        'uuid': json['concept']['uuid'],
        'display': json['concept']['uuid']
      }
    );
  }

  static List<DataModel> fromJsonList(List list) {
    if (list == null) return [];
    return list.map((item) => DataModel.fromJson(item)).toList();
  }

  String dataAsString() {
    return this.display;
  }

  @override
  String toString() => display;
}

class ConceptReferenceTermModel {
  final String uuid;
  ConceptReferenceTermModel({required this.uuid});

  factory ConceptReferenceTermModel.fromJson(Map<String, dynamic> json) {
    return ConceptReferenceTermModel(
        uuid: json["uuid"]
    );
  }

  @override
  String toString() => uuid;
}

class DrugReferenceMapModel {
  final String uuid;
  DrugReferenceMapModel({required this.uuid});

  factory DrugReferenceMapModel.fromJson(Map<String, dynamic> json) {
    return DrugReferenceMapModel(
        uuid: json["uuid"]
    );
  }

  @override
  String toString() => uuid;
}