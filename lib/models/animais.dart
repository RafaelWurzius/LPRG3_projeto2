import 'package:flutter/material.dart';

class Animal {
  int id;
  String avatar;

  Animal({
    required this.id,
    required this.avatar,
  });

  static Animal fromJson(Map<dynamic, dynamic> animalItem) {
    return Animal(
      id: int.parse(animalItem['id']),
      avatar: animalItem['avatar'] as String,
    );
  }
}
