import '../../../../core/json_utilities/json_utilities.dart';

class ProductModel {
  final Data? data;
  final String message;
  final int status;

  ProductModel({
    required this.data,
    required this.message,
    required this.status,
  });

  // Factory constructor لتحليل JSON إلى كائن ProductModel
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      message: fromJsonString(json["message"]),
      status: fromJsonInt(json["status"]),
    );
  }
}

class Data {
  final List<dynamic> ads;
  final List<ProductDatum> section;

  Data({
    required this.ads,
    required this.section,
  });

  // Factory constructor لتحليل JSON إلى كائن Data
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      ads: fromJsonList<dynamic>(json['ads'], (item) => item) ?? [],
      section: fromJsonList<ProductDatum>(
              json['section'], (item) => ProductDatum.fromJson(item)) ??
          [],
    );
  }
}

class ProductDatum {
  final int id;
  final String image;
  final String titleAr;
  final String titleEn;
  final List<Subsection> subsection;

  ProductDatum({
    required this.id,
    required this.image,
    required this.titleAr,
    required this.titleEn,
    required this.subsection,
  });

  // Factory constructor لتحليل JSON إلى كائن ProductDatum
  factory ProductDatum.fromJson(Map<String, dynamic> json) {
    return ProductDatum(
      id: fromJsonInt(json["id"]),
      image: fromJsonString(json["image"]),
      titleAr: fromJsonString(json["title_ar"]),
      titleEn: fromJsonString(json["title_en"]),
      subsection: fromJsonList<Subsection>(
              json['subsection'], (item) => Subsection.fromJson(item)) ??
          [],
    );
  }
}

class Subsection {
  final int id;
  final String titleAr;
  final String titleEn;
  final String price;
  final String sectionId;

  Subsection({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.price,
    required this.sectionId,
  });

  // Factory constructor لتحليل JSON إلى كائن Subsection
  factory Subsection.fromJson(Map<String, dynamic> json) {
    return Subsection(
      id: fromJsonInt(json["id"]),
      titleAr: fromJsonString(json["title_ar"]),
      titleEn: fromJsonString(json["title_en"]),
      price: fromJsonString(json["price"]),
      sectionId: fromJsonString(json["section_id"]),
    );
  }
}
