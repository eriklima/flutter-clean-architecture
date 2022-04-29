import 'dart:convert';

import 'package:flutter_clean_architecture/modules/search/domain/entities/result_search.dart';

class ResultSearchModel extends ResultSearch {
  final String title;
  final String content;
  final String img;

  ResultSearchModel(this.title, this.content, this.img) : super(title, content, img);

  Map<String, dynamic> toMap() {
    return {
      'title': this.title,
      'content': this.content,
      'img': this.img,
    };
  }

  factory ResultSearchModel.fromMap(Map<String, dynamic> map) {
    return ResultSearchModel(
      map['login'] as String,
      map['url'] as String,
      map['avatar_url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  static ResultSearchModel fromJson(String source) => ResultSearchModel.fromMap(json.decode(source));

}