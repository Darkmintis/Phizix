import 'dart:convert';

List<CategoryModel> categoryModelFromJson(String str) => List<CategoryModel>.from(json.decode(str).map((x) => CategoryModel.fromJson(x)));

String categoryModelToJson(List<CategoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryModel {
    String? name;
    String? slug;
    String? description;
    String? image;
    int? articleCount;

    CategoryModel({
        this.name,
        this.slug,
        this.description,
        this.image,
        this.articleCount,
    });

    factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        name: json["name"],
        slug: json["slug"],
        description: json["description"],
        image: json["image"],
        articleCount: json["articleCount"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
        "description": description,
        "image": image,
        "articleCount": articleCount,
    };
}
