class Article {
  final String title;
  final String slug;
  final String excerpt;
  final String content;
  final String featureImage;
  final DateTime publishedAt;

  Article({
    required this.title,
    required this.slug,
    required this.excerpt,
    required this.content,
    required this.featureImage,
    required this.publishedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json){
    return Article( 
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      excerpt: json['excerpt'] ?? '',
      content: json['content'] ?? '', 
      featureImage: json['featureImage'] ?? '',
      publishedAt: json['publishedAt'] != null
      ? DateTime.tryParse(json['publishedAt'].toString()) ?? DateTime.now()
      : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'title': title,
      'slug': slug,
      'excerpt': excerpt,
      'content': content,
      'featureImage': featureImage,
      'publishedAt': publishedAt.toIso8601String(),
    };
  }
}