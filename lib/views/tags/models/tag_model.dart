import 'dart:convert';

List<TagModel> tagModelFromJson(String str) => List<TagModel>.from(json.decode(str).map((x) => TagModel.fromJson(x)));

String tagModelToJson(List<TagModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TagModel {
    String? name;
    String? slug;
    String? description;
    String? image;
    int? articleCount;

    TagModel({
        this.name,
        this.slug,
        this.description,
        this.image,
        this.articleCount,
    });

    factory TagModel.fromJson(Map<String, dynamic> json) => TagModel(
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
