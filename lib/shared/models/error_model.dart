import 'dart:convert';

ErrorModel errorFromJson(String str) => ErrorModel.fromJson(json.decode(str));

String errorToJson(ErrorModel data) => json.encode(data.toJson());

class ErrorModel {
    bool? error;
    String? url;
    int? statusCode;
    String? message;

    ErrorModel({
        this.error,
        this.url,
        this.statusCode,
        this.message,
    });

    factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
        error: json["error"],
        url: json["url"],
        statusCode: json["statusCode"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "url": url,
        "statusCode": statusCode,
        "message": message,
    };
}
