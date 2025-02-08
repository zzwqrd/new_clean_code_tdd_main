import '../../../../core/json_utilities/json_utilities.dart';

class ProductModel {
  late Data? data;
  late String message;
  late int status;

  ProductModel.fromJson(Map<String, dynamic> json) {
    data = fromJsonObject<Data>(json['data'], (item) => Data.fromJson(item));
    message = fromJsonString(json["message"]);
    status = fromJsonInt(json["status"]);
  }
}

class Data {
  late List<dynamic> ads;
  late List<ProductDatum> section;
  Data.fromJson(Map<String, dynamic> json) {
    ads = fromJsonList<dynamic>(json['ads'], (item) => item);
    section = fromJsonList<ProductDatum>(
        json['section'], (item) => ProductDatum.fromJson(item)); // return Data(
  }
}

class ProductDatum {
  late int id;
  late String image;
  late String titleAr;
  late String titleEn;

  late List<Subsection> subsection;

  ProductDatum.fromJson(Map<String, dynamic> json) {
    id = fromJsonInt(json["id"]);
    image = fromJsonString(json["image"]);

    subsection = fromJsonList<Subsection>(
        json['section'], (item) => Subsection.fromJson(item));
  }
}

class Subsection {
  late int id;
  late String titleAr;
  late String titleEn;
  late String price;
  late String sectionId;

  Subsection();

  Subsection.fromJson(Map<String, dynamic> json) {
    id = fromJsonInt(json["id"]);
    titleAr = fromJsonString(json["title_ar"]);
    titleEn = fromJsonString(json["title_en"]);
    price = fromJsonString(json["price"]);
    sectionId = fromJsonString(json["section_id"]);
  }
}
